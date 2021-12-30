import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:open_file/open_file.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:transportation_mobile_app/app_driver/models/entities/address.dart';
import 'package:transportation_mobile_app/app_driver/models/entities/globals.dart';
import 'package:transportation_mobile_app/app_driver/models/entities/inspection_item.dart';
import 'package:transportation_mobile_app/app_driver/models/entities/report_enums.dart';
import 'package:transportation_mobile_app/app_driver/models/entities/session.dart';

class IssueItemJson {
  String name;
  String value;

  IssueItemJson(this.name, this.value);

  Map<String, dynamic> toJson() => {'name': name, 'value': value};

  factory IssueItemJson.fromJson(dynamic json) {
    return IssueItemJson(json['name'], json['value']);
  }
}

class BillOfLading {
  SessionObject session = getCurrentSession();

  Future<File> _saveAndLaunchFile(List<int> bytes, String fileName) async {
    //Get the storage folder location using path_provider package.
    String path;
    if (Platform.isAndroid ||
        Platform.isIOS ||
        Platform.isLinux ||
        Platform.isWindows) {
      final Directory directory =
          await path_provider.getApplicationSupportDirectory();
      path = directory.path;
    } else {
      path = await PathProviderPlatform.instance.getApplicationSupportPath();
    }
    final File file =
        File(Platform.isWindows ? '$path\\$fileName' : '$path/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    if (Platform.isAndroid || Platform.isIOS) {
      //Launch the file (used open_file package)
      await OpenFile.open('$path/$fileName');
    } else if (Platform.isWindows) {
      await Process.run('start', <String>['$path\\$fileName'],
          runInShell: true);
    } else if (Platform.isMacOS) {
      await Process.run('open', <String>['$path/$fileName'], runInShell: true);
    } else if (Platform.isLinux) {
      await Process.run('xdg-open', <String>['$path/$fileName'],
          runInShell: true);
    }
    return file;
  }

  Future<ByteData> _getBolFile(String broker) {
    switch (broker) {
      case "GATowing":
        return rootBundle.load('assets/bol/ga_towing.pdf');
      default:
        return rootBundle.load('assets/bol/default.pdf');
    }
  }

  void generate(SessionObject session, List<InspectionItem> reportItems) async {
    final byteData = await _getBolFile(session.broker);
    String templatePath =
        '${(await getTemporaryDirectory()).path}/bill_template.pdf';
    final file = File(templatePath);
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    final PdfDocument document =
        PdfDocument(inputBytes: File(templatePath).readAsBytesSync());
    Address srcAddress = session.source;
    Address dstAddress = session.destination;

    String issues =
        reportItems.firstWhere((element) => element.name == "Issues").value;
    List<IssueItemJson> issueItems = [];
    if (issues.isNotEmpty) {
      for (Map item in jsonDecode(issues)) {
        issueItems.add(IssueItemJson.fromJson(item));
      }
    }
    for (int i = 0; i < document.form.fields.count; i++) {
      final PdfField field = document.form.fields[i];
      if (field.name.contains("top_") ||
          field.name.contains("back_") ||
          field.name.contains("right_") ||
          field.name.contains("front_") ||
          field.name.contains("left_")) {
        (field as PdfTextBoxField).text = issueItems
            .firstWhere((element) => element.name == field.name,
                orElse: () => IssueItemJson(field.name, ''))
            .value;
      }
      switch (field.name.toString()) {
        case 'LID':
          (field as PdfTextBoxField).text = session.id;
          break;
        case 'Broker':
          (field as PdfTextBoxField).text = session.broker;
          break;
        case 'Driver':
          (field as PdfTextBoxField).text = session.driver;
          break;
        case 'Trucker':
          if (session.truck != null) {
            (field as PdfTextBoxField).text = session.truck;
          }
          break;
        case 'Make':
          (field as PdfTextBoxField).text = session.title.split(" ")[1];
          break;
        case 'Model':
          (field as PdfTextBoxField).text = session.title.split(" ")[2];
          break;
        case 'Mileage':
          (field as PdfTextBoxField).text = reportItems
              .firstWhere((element) => element.name == "Odometer",
                  orElse: () => InspectionItem(value: ""))
              .value;
          break;
        case 'Year':
          (field as PdfTextBoxField).text = session.title.split(" ")[0];
          break;
        case 'VIN':
          (field as PdfTextBoxField).text = session.vin;
          break;
        case 'Note':
          (field as PdfTextBoxField).text = "";
          break;
        case 'DContact':
          if (dstAddress != null) {
            (field as PdfTextBoxField).text = (dstAddress.firstName ?? "") +
                " " +
                (dstAddress.lastName ?? "");
          }
          break;
        case 'PContact':
          if (srcAddress != null) {
            (field as PdfTextBoxField).text = (srcAddress.firstName ?? "") +
                " " +
                (srcAddress.lastName ?? "");
          }
          break;
        case 'PAddress':
          if (srcAddress != null) {
            (field as PdfTextBoxField).text = srcAddress.address1;
          }
          break;
        case 'Delivery_date':
          DateTime now = new DateTime.now();
          (field as PdfTextBoxField).text =
              "${now.month}/${now.day}/${now.year}";
          break;
        case 'Pickup_date':
          DateTime now = new DateTime.now();
          (field as PdfTextBoxField).text =
              "${now.month}/${now.day}/${now.year}";
          break;
        case 'DAddress':
          if (dstAddress != null) {
            (field as PdfTextBoxField).text = dstAddress.address1;
          }
          break;
        case 'PCity':
          if (srcAddress != null) {
            (field as PdfTextBoxField).text = srcAddress.city;
          }
          break;
        case 'PState':
          if (srcAddress != null) {
            (field as PdfTextBoxField).text = srcAddress.state;
          }
          break;
        case 'DCity':
          if (dstAddress != null) {
            (field as PdfTextBoxField).text = dstAddress.city;
          }
          break;
        case 'DState':
          if (dstAddress != null) {
            (field as PdfTextBoxField).text = dstAddress.state;
          }
          break;
        case 'DPhone':
          Address dstAddress = session.destination;
          if (dstAddress != null) {
            (field as PdfTextBoxField).text = dstAddress.phone;
          }
          break;
        case 'PPhone':
          Address srcAddress = session.source;
          if (srcAddress != null) {
            (field as PdfTextBoxField).text = srcAddress.phone;
          }
          break;
        case 'Shipper_Name':
          (field as PdfTextBoxField).text = reportItems
              .firstWhere(
                  (element) =>
                      element.name ==
                          ReportCategoryItems.CustomerName.getName() &&
                      element.category ==
                          ReportCategories.PickupSignature.getName(),
                  orElse: () => InspectionItem(value: ""))
              .value;
          break;
        case 'Receiver_Name':
          (field as PdfTextBoxField).text = reportItems
              .firstWhere(
                  (element) =>
                      element.name == "Customer Name" &&
                      element.category == "Drop-off Signature",
                  orElse: () => InspectionItem(value: ""))
              .value;
          break;
        case 'Driver_Name':
          (field as PdfTextBoxField).text = session.driver;
          break;
      }
    }

    reportItems.forEach((element) {
      print(element.name + " " + element.category);
    });
    Iterable<InspectionItem> shipperSignature = reportItems.where((element) =>
        element.name == ReportCategoryItems.SignatureImage.getName() &&
        element.category == ReportCategories.PickupSignature.getName());

    if (shipperSignature.isNotEmpty) {
      Uint8List signaturePng = shipperSignature.first.data;
      if (signaturePng != null) {
        print("add signature");
        document.pages[0].graphics.drawImage(
            PdfBitmap(signaturePng), Rect.fromLTWH(195, 635, 100, 24));
      }
    }

    Iterable<InspectionItem> receiverSignature = reportItems.where((element) =>
        element.name == ReportCategoryItems.SignatureImage.getName() &&
        element.category == ReportCategories.DropOffSignature.getName());
    if (receiverSignature.isNotEmpty) {
      Uint8List signaturePng = receiverSignature.first.data;
      if (signaturePng != null) {
        document.pages[0].graphics.drawImage(
            PdfBitmap(signaturePng), Rect.fromLTWH(425, 635, 100, 24));
      }
    }

    final List<int> bytes = document.save();
    document.dispose();
    File pdfFile = await _saveAndLaunchFile(bytes, 'bill.pdf');
    InspectionItem inspectionItem = reportItems
        .where((element) =>
            element.name == ReportCategoryItems.BillOfLading.getName())
        .first;
    inspectionItem.value = pdfFile.path;
  }
}
