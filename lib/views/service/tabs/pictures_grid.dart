import 'dart:async';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transportation_mobile_app/models/entities/globals.dart';
import 'package:transportation_mobile_app/models/entities/inspection_item.dart';
import 'package:transportation_mobile_app/models/entities/modular-args.dart';
import 'package:transportation_mobile_app/models/entities/report_enums.dart';
import 'package:transportation_mobile_app/models/entities/session.dart';
import 'package:transportation_mobile_app/utils/app_colors.dart';

class GridPicturePage extends StatefulWidget {
  final ReportCategories reportTabName;
  final List<InspectionItem> gridItems;
  final bool isEditable;

  GridPicturePage(
      {this.reportTabName, this.gridItems, this.isEditable, Key key})
      : super(key: key);

  @override
  _GridPicturePageState createState() => _GridPicturePageState();
}

class _GridPicturePageState extends State<GridPicturePage> {
  InspectionItem currentImage;
  SessionObject session = getCurrentSession();
  Timer uploadTimer;
  int uploadProgress = 0;

  Widget build(BuildContext context) {
    double imageCardWidth = (MediaQuery.of(context).size.width - 48) / 2;
    return SingleChildScrollView(
        child: Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: <Widget>[
          Row(children: [Container(height: 32)]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              makeCaptureImageCard(widget.gridItems[0], imageCardWidth),
              makeCaptureImageCard(widget.gridItems[1], imageCardWidth),
            ],
          ),
          Row(children: [Container(height: 8)]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              makeCaptureImageCard(widget.gridItems[2], imageCardWidth),
              makeCaptureImageCard(widget.gridItems[3], imageCardWidth),
            ],
          ),
          Row(children: [Container(height: 8)]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              makeCaptureImageCard(widget.gridItems[4], imageCardWidth),
              makeCaptureImageCard(widget.gridItems[5], imageCardWidth),
            ],
          ),
          Row(children: [Container(height: 16)]),
        ],
      ),
    ));
  }

  FutureOr onGoBack(Object value) {
    if (value != null) {
      InspectionItem item = value as InspectionItem;
      setState(() {
        currentImage.value = item.value;
        currentImage.comments = item.comments;
        currentImage.format = 'image/jpg';
      });
    }
  }

  Widget makeCaptureImageCard(InspectionItem question, double width) {
    Widget child;
    GestureTapCallback callback;
    if (question.value == null || question.value.isEmpty) {
      callback = () {
        currentImage = question;
        Modular.to
            .pushNamed(findOrientation(question.name), arguments: question)
            .then(onGoBack);
      };
      child = Container(
        height: 40.0,
        width: 40.0,
        child: Center(
            child: Icon(
          Icons.camera_alt_rounded,
          color: AppColors.silver,
          size: 16.0,
        )),
      );
    } else {
      callback = () {
        currentImage = question;
        Modular.to
            .pushNamed('picture/single-picture',
                arguments: PhotoDetailsArgs(question, widget.isEditable))
            .then(onGoBack);
      };
      child = Container(
        child: Center(child: Image.file(File(question.value))),
      );
    }
    return GestureDetector(
      onTap: widget.reportTabName.canUserEditTab(session.sessionStatus)
          ? callback
          : null,
      child: Container(
        height: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/' +
                      question.name.toLowerCase().replaceAll(' ', '_') +
                      '.png',
                  width: 40,
                  height: 40,
                ),
                SizedBox(
                  width: 6.0,
                ),
                Text(question.name,
                    textAlign: TextAlign.right,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ))
              ],
            ),
            Container(
              width: width - 40,
              height: width - 40,
              decoration: BoxDecoration(
                  color: AppColors.wildSand,
                  borderRadius: BorderRadius.circular(16.0)),
              child: Center(
                child: DottedBorder(
                    color: AppColors.silver,
                    dashPattern: [3],
                    strokeWidth: 2.0,
                    strokeCap: StrokeCap.butt,
                    borderType: BorderType.RRect,
                    radius: Radius.circular(12),
                    child: child),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget floatButton({var background, var text, VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40.0,
        width: 160.0,
        decoration: BoxDecoration(
            color: background, borderRadius: BorderRadius.circular(16.0)),
        child: Center(
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
