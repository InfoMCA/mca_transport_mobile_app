import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
// ignore: directives_ordering
import 'package:open_file/open_file.dart' as open_file;
// import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:transportation_mobile_app/models/entities/address.dart';
import 'package:transportation_mobile_app/models/entities/globals.dart';
import 'package:transportation_mobile_app/models/entities/inspection_item.dart';
import 'package:transportation_mobile_app/models/entities/session.dart';

class BillOfLadingPage extends StatelessWidget {

  SessionObject session = getCurrentSession();

  Future<File> saveAndLaunchFile(List<int> bytes, String fileName) async {
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
      await open_file.OpenFile.open('$path/$fileName');
    } else if (Platform.isWindows) {
      await Process.run('start', <String>['$path\\$fileName'], runInShell: true);
    } else if (Platform.isMacOS) {
      await Process.run('open', <String>['$path/$fileName'], runInShell: true);
    } else if (Platform.isLinux) {
      await Process.run('xdg-open', <String>['$path/$fileName'],
          runInShell: true);
    }
    return file;
  }

  void fillPDF(final bill) async {
    final byteData = await rootBundle.load('assets/${bill}.pdf');
    String templatePath = '${(await getTemporaryDirectory()).path}/${bill}_template.pdf';
    final file = File(templatePath);
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    final PdfDocument document = PdfDocument(inputBytes: File(templatePath).readAsBytesSync());
    for (int i = 0; i < document.form.fields.count; i++) {
      final PdfField field = document.form.fields[i];
      switch(i) {
        case 0:
          (field as PdfTextBoxField).text = session.id;
          break;
        case 1:
          (field as PdfTextBoxField).text = session.broker;
          break;
        case 2:
          (field as PdfTextBoxField).text = session.driver;
          break;
        case 3:
          if (session.truck != null) {
            (field as PdfTextBoxField).text = session.truck;
          }
          break;
        case 4:
          (field as PdfTextBoxField).text = session.title;
          break;
        case 5:
          (field as PdfTextBoxField).text = session.title;
          break;
        case 6:
          (field as PdfTextBoxField).text = session.reportItems[1].value;
          break;
        case 7:
          (field as PdfTextBoxField).text = session.title;
          break;
        case 8:
          (field as PdfTextBoxField).text = session.vin;
          break;
        case 9:
          (field as PdfTextBoxField).text = "";
          break;
        case 10:
          String dstName = session.dstName;
          if (dstName != null) {
            (field as PdfTextBoxField).text = session.dstName;
          }
          break;
        case 11:
          String srcName = session.srcName;
          if (srcName != null) {
            (field as PdfTextBoxField).text = session.srcName;
          }
          break;
        case 12:
          Address srcAddress = session.srcAddress;
          if (srcAddress != null) {
            (field as PdfTextBoxField).text = session.srcAddress.address1;
          }
          break;
        case 13:
          Address dstAddress = session.dstAddress;
          if (dstAddress != null) {
            (field as PdfTextBoxField).text = session.dstAddress.address1;
          }
          break;
        case 14:
          Address srcAddress = session.srcAddress;
          if (srcAddress != null) {
            (field as PdfTextBoxField).text = session.srcAddress.city;
          }
          break;
        case 15:
          Address srcAddress = session.srcAddress;
          if (srcAddress != null) {
            (field as PdfTextBoxField).text = session.srcAddress.state;
          }
          break;
        case 16:
          Address dstAddress = session.dstAddress;
          if (dstAddress != null) {
            (field as PdfTextBoxField).text = session.dstAddress.city;
          }
          break;
        case 17:
          Address dstAddress = session.dstAddress;
          if (dstAddress != null) {
            (field as PdfTextBoxField).text = session.dstAddress.state;
          }
          break;
        case 18:
          Address dstAddress = session.dstAddress;
          if (dstAddress != null) {
            (field as PdfTextBoxField).text = session.dstAddress.phone;
          }
          break;
        case 19:
          Address srcAddress = session.srcAddress;
          if (srcAddress != null) {
            (field as PdfTextBoxField).text = session.srcAddress.phone;
          }
          break;
      }
    }
    final List<int> bytes = document.save();
    document.dispose();
    File pdfFile = await saveAndLaunchFile(bytes, bill + '.pdf');
    // docInspectionItemsPdf[bill].value = pdfFile.path;
    // final data = rootBundle.load(bill);
    // final buffer = data.buffer;
    // final PdfDocument document = PdfDocument(inputBytes: await buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
    // (document.form.fields[0] as PdfTextBoxField).text = 'test';
    // final file = File('filled_bill.pdf');
    // file.writeAsBytesSync(document.save());
    // return file.path;
  }

  @override
  Widget build(BuildContext context) {
    final bill = 'bill';
    fillPDF(bill);
    return Scaffold();
  }
}