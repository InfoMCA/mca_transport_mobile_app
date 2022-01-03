import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:transportation_mobile_app/app_common/globals.dart';
import 'package:transportation_mobile_app/app_common/utils/app_colors.dart';
import 'package:transportation_mobile_app/app_customer/controllers/transfer_form.dart';
import 'package:transportation_mobile_app/app_customer/utils/interfaces/transfer.dart';
import 'package:transportation_mobile_app/app_customer/widgets/expansion_tile.dart';
import 'package:transportation_mobile_app/app_customer/widgets/report_text_field.dart';
import 'package:transportation_mobile_app/app_customer/widgets/us_state_picker.dart';

class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  TransferRequest request;

  @override
  void initState() {
    super.initState();
    request = TransferRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.portGore,
        title: Text("Vehicle transfer request"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
        child: ListView(
          children: [
            FormExpansionTile(
              title: "General Information",
              children: [
                for (Map<String, dynamic> question
                    in request.questions['general'])
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: getQuestionWidget(question),
                  )
              ],
            ),
            FormExpansionTile(
              title: "Pick-up Information",
              children: [
                for (Map<String, dynamic> question
                    in request.questions['pickUp'])
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: getQuestionWidget(question),
                  )
              ],
            ),
            FormExpansionTile(
              title: "Drop-off Information",
              children: [
                for (Map<String, dynamic> question
                    in request.questions['dropOff'])
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: getQuestionWidget(question),
                  )
              ],
            ),
            Container(
              color: AppColors.portGore,
              child: TextButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            title: Text('Are you sure you want to submit?'),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    Modular.to.pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      primary: AppColors.silverChalice,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 50, vertical: 20),
                                      textStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                  child: Text("Cancel")),
                              ElevatedButton(
                                  onPressed: () {
                                    Modular.to.pop();
                                    if (!request.canSendRequest()) {
                                      showSnackBar(
                                          text:
                                              "There are items missing. Please fill out the form and try again",
                                          context: context,
                                          backgroundColor: Colors.red);
                                      return;
                                    }
                                    _sendRequest();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      primary: AppColors.portGore,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 50, vertical: 20),
                                      textStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                  child: Text("Send"))
                            ],
                            contentTextStyle: TextStyle(color: Colors.black),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Missing on general section",
                                  style: TextStyle(color: Colors.red),
                                ),
                                for (String item in request.getMissingItems(
                                    section: "general"))
                                  Text(item),
                                Text(
                                  "Missing on pick-up section",
                                  style: TextStyle(color: Colors.red),
                                ),
                                for (String item in request.getMissingItems(
                                    section: "pickUp"))
                                  Text(item),
                                Text("Missing on drop-off section",
                                    style: TextStyle(color: Colors.red)),
                                for (String item in request.getMissingItems(
                                    section: "dropOff"))
                                  Text(item),
                              ],
                            ),
                          ));
                },
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                    Text(
                      "Submit",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getQuestionWidget(Map<String, dynamic> question) {
    switch (question["questionFormat"]) {
      case "VinField":
        return Column(
          children: [
            Text(
              question['name'],
              style: TextStyle(color: Colors.black45),
            ),
            ReportTextField(
              initialValue: question['value'],
              maxLength: 17,
              onlyCaps: true,
              onChange: (newVal) => question['value'] = newVal,
            ),
          ],
        );
      case "TextField":
      case "VinField":
      case "NumberField":
      case "PhoneField":
        String format = question["questionFormat"];
        return Column(
          children: [
            Text(
              question['name'],
              style: TextStyle(color: Colors.black45),
            ),
            ReportTextField(
              maxLength: format == "VinField" ? 17 : null,
              onlyCaps: format == "VinField",
              inputType: format == "NumberField"
                  ? TextInputType.numberWithOptions(
                      signed: false, decimal: false)
                  : format == "PhoneField"
                      ? TextInputType.phone
                      : null,
              initialValue: question['value'],
              onChange: (newVal) => question['value'] = newVal,
            ),
          ],
        );
      case "StatePicker":
        return USStatePicker(onChange: (value) => question['value'] = value);
      case "DatePicker":
        return Column(
          children: [
            Text(
              question["name"],
              style: TextStyle(color: Colors.black45),
            ),
            Container(
              color: AppColors.portGore,
              width: double.maxFinite,
              child: TextButton(
                onPressed: () => showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 30)))
                    .then((value) => setState(() {
                          question['value'] =
                              value.toUtc().millisecondsSinceEpoch ~/ 1000;
                        })),
                child: Text(
                  question['value'] == 0 || question['value'] == null
                      ? "Select date"
                      : DateTime.fromMillisecondsSinceEpoch(
                              question['value'] * 1000)
                          .toString()
                          .split(" ")[0],
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        );
      default:
        return Container();
    }
  }

  void _sendRequest() async {
    try {
      showSnackBar(
          text: "Sending request ...",
          context: context,
          backgroundColor: Colors.grey);
      await TransportInterface().sendTransferRequest(
        request.getRequest(),
      );
      setState(() {
        request = TransferRequest();
      });
      showSnackBar(
          text: "Request sent successfully!",
          context: context,
          backgroundColor: Colors.lightGreen);
    } catch (e, s) {
      log("Error sending transfer request: " + e.toString());
      showSnackBar(
          text: "Error sending request, please try again.",
          context: context,
          backgroundColor: Colors.redAccent);
    }
  }
}
