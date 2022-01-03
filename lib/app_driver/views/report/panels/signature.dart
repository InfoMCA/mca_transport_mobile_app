import 'dart:async';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:transportation_mobile_app/app_driver/models/entities/globals.dart';
import 'package:transportation_mobile_app/app_driver/models/entities/inspection_item.dart';
import 'package:transportation_mobile_app/app_driver/models/entities/report_enums.dart';
import 'package:transportation_mobile_app/app_common/utils/app_colors.dart';
import 'package:transportation_mobile_app/app_driver/utils/services/local_storage.dart';

class SignatureTabPage extends StatefulWidget {
  final ReportCategories reportTabName;
  final List<ReportCategories> reportingCategories;

  SignatureTabPage(
      {@required this.reportTabName,
      @required this.reportingCategories,
      Key key})
      : super(key: key);

  @override
  _SignatureTabPageState createState() => _SignatureTabPageState();
}

class _SignatureTabPageState extends State<SignatureTabPage> {
  SignatureController _controller;
  InspectionItem signatureImage;
  InspectionItem customerName;
  bool canUserEdit = false;
  bool signatureAvail = false;
  static const String NO_SIGNATURE_NOTE = "No signer available";

  void _savePoints() {
    signatureImage.signaturePoints = _controller.points;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      signatureImage = getCurrentSession()
          .categoryItems[widget.reportTabName.getName()]
          .firstWhere((InspectionItem element) =>
              element.name == ReportCategoryItems.SignatureImage.getName());
      customerName = getCurrentSession()
          .categoryItems[widget.reportTabName.getName()]
          .firstWhere((element) =>
              element.name == ReportCategoryItems.CustomerName.getName());
      signatureAvail = customerName.value != NO_SIGNATURE_NOTE;
      canUserEdit = widget.reportTabName
          .canUserEditTab(getCurrentSession().sessionStatus);
      _controller = SignatureController(
          penStrokeWidth: 1,
          penColor: Colors.black,
          exportBackgroundColor: Colors.transparent,
          onDrawEnd: _savePoints,
          points: signatureImage.signaturePoints);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (signatureAvail) ..._getSignatureWidgets(),
          ],
        ),
      ),
    );
  }

  Future _saveSignatureImage() async {
    signatureImage.data = await _controller.toPngBytes();
    signatureImage.image = await _controller.toImage();
    if (signatureImage.image == null || signatureImage.data == null) {
      return;
    }
    signatureImage.value = await LocalStorage.saveFile(
        ReportCategoryItems.SignatureImage.getName(),
        FileType.png,
        await _controller.toPngBytes());
  }

  List<Widget> _getSignatureWidgets() {
    return [
      Text("Receiving customer's Name",
          style: TextStyle(
              fontFamily: 'poppins',
              fontSize: 14,
              fontWeight: FontWeight.w600)),
      TextFormField(
        style: TextStyle(fontFamily: 'poppins', color: Colors.black),
        initialValue: customerName.value,
        enabled: widget.reportTabName
            .canUserEditTab(getCurrentSession().sessionStatus),
        onChanged: (String value) => customerName.value = value,
      ),
      SizedBox(height: 16),
      Text(
        "Please have receiver electronically sign below",
        style: TextStyle(
            fontFamily: 'poppins', fontSize: 14, fontWeight: FontWeight.w600),
      ),
      SizedBox(height: 16),
      if (canUserEdit) ...[
        Signature(
          controller: _controller,
          height: 100,
          backgroundColor: Color(0xFFccdcf0),
        ),
        Row(
          children: [
            TextButton(
                onPressed: () {
                  _saveSignatureImage();
                },
                child: Row(
                  children: [
                    Text(
                      "Save",
                      style: TextStyle(
                          color: AppColors.portGore,
                          fontFamily: 'poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                    Icon(
                      Icons.save,
                      color: AppColors.alizarinCrimson,
                      size: 20,
                    ),
                  ],
                )),
            TextButton(
                onPressed: () {
                  _controller.clear();
                  _savePoints();
                },
                child: Row(
                  children: [
                    Text(
                      "Clear",
                      style: TextStyle(
                          color: AppColors.portGore,
                          fontFamily: 'poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                    Icon(
                      Icons.clear,
                      color: AppColors.alizarinCrimson,
                      size: 20,
                    ),
                  ],
                )),
          ],
        ),
      ] else if (signatureImage.data != null && signatureImage.data.isNotEmpty)
        Image.memory(signatureImage.data)
      else
        Container(
            color: Colors.grey,
            padding: EdgeInsets.all(10),
            child: Center(
              child: Text(
                "No signature to show",
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
            )),
    ];
  }
}
