import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:transportation_mobile_app/app_driver/models/entities/globals.dart';
import 'package:transportation_mobile_app/app_driver/models/entities/inspection_item.dart';
import 'package:transportation_mobile_app/app_driver/models/entities/report_enums.dart';
import 'package:transportation_mobile_app/app_driver/utils/interfaces/admin_interface.dart';
import 'package:transportation_mobile_app/app_driver/utils/interfaces/data_interface.dart';
import 'package:transportation_mobile_app/app_driver/utils/services/local_storage.dart';

import 'address.dart';

enum SessionStatus {
  Dispatched,
  Started,
  Pickup,
  Transferring,
  Dropped,
  Completed,
  Canceled,
  Uploading,
  None
}

extension SessionStatusString on SessionStatus {
  String getName() {
    print(this);
    switch (this) {
      case SessionStatus.Dispatched:
        return "Dispatched";
      case SessionStatus.Started:
        return "Started";
      case SessionStatus.Pickup:
        return "Picked Up";
      case SessionStatus.Transferring:
        return "In Transit";
      case SessionStatus.Dropped:
        return "Drop Off";
      case SessionStatus.Completed:
        return "Completed";
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
  Address source;
  Address destination;
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
      this.source,
      this.destination,
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
      source: Address.fromJson(jsonData['source']),
      destination: Address.fromJson(jsonData['destination']),
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
      'source': source,
      'destination': destination,
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
    if (reportCategory == ReportCategories.PickupPictures) {
      pickupPictureIsUploaded = true;
    } else if (reportCategory == ReportCategories.PickupSignature) {
      updateStatus(SessionStatus.Pickup);
      updateStatus(SessionStatus.Transferring);
    } else if (reportCategory == ReportCategories.DropOffPictures) {
      dropOffPictureIsUploaded = true;
    } else if (reportCategory == ReportCategories.DropOffSignature) {
      updateStatus(SessionStatus.Completed);
    }
  }

  Future<void> uploadAttachments() async {
    updateStatus(SessionStatus.Uploading);
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
    updateStatus(SessionStatus.Completed);
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
      case SessionStatus.Started:
        if (pickupPictureIsUploaded) {
          return ReportCategories.PickupSignature;
        } else {
          return ReportCategories.PickupPictures;
        }
        break;
      case SessionStatus.Pickup:
      case SessionStatus.Dropped:
      case SessionStatus.Transferring:
        if (dropOffPictureIsUploaded) {
          return ReportCategories.DropOffSignature;
        } else {
          return ReportCategories.DropOffPictures;
        }
        break;
      case SessionStatus.Dispatched:
      case SessionStatus.Completed:
      case SessionStatus.Canceled:
      case SessionStatus.Uploading:
      case SessionStatus.None:
        break;
    }
    return ReportCategories.PickupPictures;
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
