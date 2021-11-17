import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transportation_mobile_app/models/entities/inspection_item.dart';
import 'package:transportation_mobile_app/models/entities/modular-args.dart';
import 'package:transportation_mobile_app/utils/app_colors.dart';
import 'package:transportation_mobile_app/widgets/service/report_panel.dart';

class PhotoDetails extends StatefulWidget {
  InspectionItem item;
  InspectionItem itemIssues;
  bool canEdit;

  PhotoDetails(ModularArguments args) {
    PhotoDetailsArgs argsItem = args.data as PhotoDetailsArgs;
    item = argsItem.item;
    itemIssues = argsItem.itemIssues;
    canEdit = argsItem.isEditable;
  }

  @override
  _PhotoDetailsState createState() => _PhotoDetailsState();
}

class _PhotoDetailsState extends State<PhotoDetails> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.portGore,
        title: Text(
          widget.item.name + " Pictures",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xffeeeeee),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: const Color(0xff7099b2)),
          color: const Color(0xff7099b2),
          onPressed: () {
            handlePop(context);
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
        child: ListView(
          children: [
            Container(
              height: 300,
              child: Image.file(
                File(widget.item.value),
                fit: BoxFit.fill,
              ),
            ),
            Divider(),
            VehiclePanelReport(
                issues: decodeIssues(widget.itemIssues.value),
                sideName: widget.item.name.toLowerCase(),
                onIssueReported: (List<Map<String, dynamic>> newIssues) {
                  List<Map<String, dynamic>> decodedList =
                      decodeIssues(widget.itemIssues.value);
                  for (Map<String, dynamic> newIssue in newIssues) {
                    decodedList.removeWhere(
                        (element) => element["name"] == newIssue["name"]);
                  }
                  decodedList.addAll(newIssues);
                  widget.itemIssues.value = json.encode(decodedList);
                  return "";
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                !widget.canEdit
                    ? Container()
                    : customButton(
                        text: "DELETE",
                        color: AppColors.alizarinCrimson,
                        onPressed: () {
                          widget.item.value = "";
                          handlePop(context);
                        }),
                customButton(
                    text: "BACK",
                    color: AppColors.portGore,
                    onPressed: () => handlePop(context)),
              ],
            )
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> decodeIssues(String listString) {
    listString = listString == null || listString.isEmpty ? "[]" : listString;
    List<Map<String, dynamic>> list =
        new List<Map<String, dynamic>>.from(json.decode(listString));
    return list;
  }

  Widget customButton({String text, Color color, VoidCallback onPressed}) {
    return TextButton(
        child: Container(
          width: 120,
          height: 34,
          child: Center(
              child: Text(
            text,
            style: TextStyle(color: Colors.white),
          )),
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(6.0)),
        ),
        onPressed: onPressed);
  }

  void handlePop(context) {
    Navigator.pop(context, widget.item);
  }
}
