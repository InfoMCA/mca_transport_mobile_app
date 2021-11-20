import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:transportation_mobile_app/models/entities/globals.dart';
import 'package:transportation_mobile_app/models/entities/inspection_item.dart';
import 'package:transportation_mobile_app/models/entities/report_enums.dart';
import 'package:transportation_mobile_app/utils/interfaces/admin_interface.dart';
import 'package:transportation_mobile_app/utils/interfaces/data_interface.dart';
import 'package:transportation_mobile_app/utils/services/local_storage.dart';

import 'address.dart';

enum SessionStatus {
  DISPATCHED,
  STARTED,
  PICKUP,
  TRANSFERRING,
  DROPPED,
  COMPLETED,
  CANCELED,
  UPLOADING,
  NONE
}

extension SessionStatusString on SessionStatus {
  String getName() {
    switch (this) {
      case SessionStatus.DISPATCHED:
        return "Dispatched";
      case SessionStatus.PICKUP:
        return "Picking Up";
      case SessionStatus.TRANSFERRING:
        return "In Transit";
      case SessionStatus.DROPPED:
        return "Dropping Off";
      case SessionStatus.COMPLETED:
        return "Cancelled";
      default:
        return "Unknown";
    }
  }
}

class SessionObject {
  /// Items pertaining to Session object in the backend
  String id;
  SessionStatus sessionStatus;
  String customer;
  String customerPhone;
  String broker;
  String brokerPhone;
  String srcName;
  Address srcAddress;
  String dstName;
  Address dstAddress;
  DateTime scheduledDate;
  String title;
  String vin;
  String serviceAgreement;
  List<String> notes;
  String driver;
  String truck;

  Map<String, List<InspectionItem>> categoryItems;
  List<InspectionItem> reportItems;
  List<String> serviceCategories;

  // Control variables
  int uploaded;
  int uploadingItems;
  bool isInvalidated;
  bool pickupPictureIsUploaded;
  bool dropOffPictureIsUploaded;

  SessionObject(
      {this.id,
      this.sessionStatus,
      this.title,
      this.vin,
      this.customer,
      this.customerPhone,
      this.serviceAgreement,
      this.notes,
      this.srcName,
      this.srcAddress,
      this.dstName,
      this.dstAddress,
      this.broker,
      this.brokerPhone,
      this.scheduledDate,
      this.serviceCategories,
      this.categoryItems,
      this.reportItems,
      this.uploaded,
      this.uploadingItems,
      this.isInvalidated,
      this.driver,
      this.truck}) {
    uploaded = 0;
    uploadingItems = 0;
    isInvalidated = false;
    pickupPictureIsUploaded = false;
    dropOffPictureIsUploaded = false;
  }

  factory SessionObject.fromJson(dynamic jsonData) {
    Map<String, dynamic> confMap = Map();
    Map<String, dynamic> defaultConfig = getInspectionConfig();
    confMap['reportItems'] =
        jsonData['reportItems'] ?? defaultConfig['reportItems'];
    confMap['categories'] =
        jsonData['serviceCategories'] ?? defaultConfig['categories'];
    InspectionConfig inspectionConfig = InspectionConfig.fromJson(confMap);

    return SessionObject(
      id: jsonData['id'] as String,
      sessionStatus: EnumToString.fromString(
          SessionStatus.values, jsonData['status'] as String),
      title: jsonData['title'] as String,
      vin: jsonData['vin'] as String,
      srcName: jsonData['address1'] as String,
      srcAddress: Address.fromJson(jsonData['srcAddress']),
      dstName: jsonData['address1'] as String,
      dstAddress: Address.fromJson(jsonData['dstAddress']),
      customer: jsonData['customer'] as String,
      customerPhone: jsonData['customerPhone'] as String,
      broker: jsonData['broker'] as String,
      brokerPhone: jsonData['brokerPhone'] as String,
      driver: jsonData['driver'] as String,
      truck: jsonData['truck'] as String,
      scheduledDate: DateTime.parse(jsonData['scheduledDate'] as String),
      serviceAgreement: jsonData['serviceAgreement'],
      notes: List<String>.from(jsonData['notes'] ?? ["No notes to show"]),
      categoryItems: inspectionConfig.categoryItems,
      reportItems: inspectionConfig.items,
      serviceCategories: inspectionConfig.categories,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': EnumToString.convertToString(sessionStatus),
      'title': title,
      'vin': vin,
      'customer': customer,
      'customerPhone': customerPhone,
      'srcName': srcName,
      'srcAddress': srcAddress,
      'dstName': dstName,
      'dstAddress': dstAddress,
      'broker': broker,
      'brokerPhone': brokerPhone,
      'driver': driver,
      'truck': truck,
      'scheduledDate': scheduledDate.toString(),
      'categoryItems': categoryItems?.map(
          (key, value) => MapEntry(key, value.map((e) => e.toJson()).toList())),
      'reportItems': this.reportItems?.map((i) => i.toJson())?.toList(),
      'serviceCategories': serviceCategories,
      'notes': notes,
      'uploaded': uploaded,
      'uploadingItems': uploadingItems,
      'isInvalidated': isInvalidated,
      'pickupPictureIsUploaded': pickupPictureIsUploaded,
      'dropOffPictureIsUploaded': dropOffPictureIsUploaded,
    };
  }

  // Get PreSigned Url for upload the object to S3
  Future<String> getUploadUrl(String objectName) async {
    return AdminInterface()
        .getPreSignedUri(id, sessionStatus, objectName, true);
  }

  // Get PreSigned Url to download the object from S3
  Future<String> getDownloadUrl(String objectName) async {
    return AdminInterface()
        .getPreSignedUri(id, sessionStatus, objectName, false);
  }

  /// Upload Media to S3
  Future<void> uploadMedia(InspectionMedia item) async {
    var preSignedUri = await getUploadUrl(item.name);
    final file = File(item.value);
    await DataInterface()
        .uploadMedia(preSignedUri, file.readAsBytesSync(), item.format);
  }

  Future<void> updateIndex() async {
    var body = json.encode({
      'categories': serviceCategories.toList(),
      'reportItems': reportItems.map((e) => e.toJson()).toList()
    });
    var preSignedUri = await getUploadUrl("index.json");
    await DataInterface().uploadText(preSignedUri, body);
  }

  /// Check if item has some media to uploaded
  List<InspectionMedia> getCapturedMedia(InspectionItem item) {
    if (item.value == null || item.value.isEmpty) {
      return [];
    }
    switch (item.type) {
      case InspectionInputType.Image:
      case InspectionInputType.Audio:
        return [InspectionMedia.fromInspectionItem(item)];

      case InspectionInputType.Animation:
        var media = List<InspectionMedia>.empty(growable: true);
        for (int i = 0; i < int.parse(item.value); i++) {
          if (item.options[i].length > 0) {
            media.add(InspectionMedia(
                name: "${item.name} $i",
                value: item.options[i],
                format: item.format));
          }
        }
        return media;
      default:
        return [];
    }
  }

  /// Upload Service Report Items and Index to S3.
  Future<void> uploadReport(ReportCategories reportCategory) async {
    uploaded = 0;
    String category = reportCategory.getName();
    uploadingItems = categoryItems[category]
        .where((element) => element.value != null)
        .length;
    for (InspectionItem inspectionItem in categoryItems[category]) {
      for (InspectionMedia media in getCapturedMedia(inspectionItem)) {
        await uploadMedia(media);
      }
      uploaded++;
    }

    updateIndex();

    uploaded = uploadingItems;
    print("Upload is completed");
    if (reportCategory == ReportCategories.PICKUP_PICTURES) {
      pickupPictureIsUploaded = true;
    } else if (reportCategory == ReportCategories.PICKUP_SIGNATURE) {
      updateStatus(SessionStatus.PICKUP);
      updateStatus(SessionStatus.TRANSFERRING);
    } else if (reportCategory == ReportCategories.DROP_OFF_PICTURES) {
      dropOffPictureIsUploaded = true;
    } else if (reportCategory == ReportCategories.DROP_OFF_SIGNATURE) {
      updateStatus(SessionStatus.COMPLETED);
    }
  }

  Future<void> uploadAttachments() async {
    updateStatus(SessionStatus.UPLOADING);
    uploaded = 0;
    uploadingItems = categoryItems.length + 1;

    for (InspectionItem inspectionItem in categoryItems['Attachment']) {
      for (InspectionMedia media in getCapturedMedia(inspectionItem)) {
        uploadMedia(media);
      }
      uploaded++;
    }

    updateIndex();

    uploaded = uploadingItems;
    print("Upload is completed");
    updateStatus(SessionStatus.COMPLETED);
  }

  // Update status of Session, sending an update to admin and refresh dashboard
  void updateStatus(SessionStatus sessionStatus) async {
    print(this.title + " status is updated to: " + sessionStatus.toString());
    SessionStatus oldStatus = this.sessionStatus;
    this.sessionStatus = sessionStatus;
    currentStaff.updateSessionStatus(this, oldStatus);
    if (oldStatus != sessionStatus) {
      AdminInterface().sendUpdateStatus(id, sessionStatus);
    }
  }

  // Return list of report category with incomplete item(s)
  List<String> getIncompleteCategory() {
    Set<String> incompleteList = Set<String>();
    for (String category in serviceCategories) {
      for (InspectionItem inspectionItem in categoryItems[category]) {
        if (inspectionItem.value.isEmpty) {
          incompleteList.add(category);
        }
      }
    }
    return incompleteList.toList();
  }

  /// Return upload progress percentage
  int getUploadProgress() {
    return uploaded * 100 ~/ uploadingItems;
  }

  ReportCategories getCurrentReportTab() {
    switch (this.sessionStatus) {
      case SessionStatus.STARTED:
        if (pickupPictureIsUploaded) {
          return ReportCategories.PICKUP_SIGNATURE;
        } else {
          return ReportCategories.PICKUP_PICTURES;
        }
        break;
      case SessionStatus.PICKUP:
      case SessionStatus.DROPPED:
      case SessionStatus.TRANSFERRING:
        if (dropOffPictureIsUploaded) {
          return ReportCategories.DROP_OFF_SIGNATURE;
        } else {
          return ReportCategories.DROP_OFF_PICTURES;
        }
        break;
      case SessionStatus.DISPATCHED:
      case SessionStatus.COMPLETED:
      case SessionStatus.CANCELED:
      case SessionStatus.UPLOADING:
      case SessionStatus.NONE:
        break;
    }
    return ReportCategories.PICKUP_PICTURES;
  }

  void saveToLocalStorage() {
    LocalStorage.saveObject(
        type: ObjectType.sessionObject, object: this, objectId: this.id);
  }

  static Future<SessionObject> getFromLocalStorage(String sessionId) async {

    try {
      return SessionObject.fromJson(json.decode(await LocalStorage.getObject(
          ObjectType.sessionObject,
          objectId: sessionId)));
    } catch (e) {
      print(e);
      // log(e, stackTrace: e);
      log("No session found in local storage");
      return null;
    }
  }
}
