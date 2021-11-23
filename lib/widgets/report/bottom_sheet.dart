import 'package:flutter/material.dart';
import 'package:transportation_mobile_app/models/entities/calling_options.dart';
import 'package:transportation_mobile_app/models/entities/globals.dart';
import 'package:transportation_mobile_app/utils/app_colors.dart';
import 'package:transportation_mobile_app/utils/app_images.dart';

void showCallOptionsBottomSheet({var context, List<CallingOptions> numbers}) {
  showModalBottomSheet(
      context: context,
      builder: (builder) {
        return new Container(
            decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(10.0),
                    topRight: const Radius.circular(10.0))),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    ..._getPhoneList(numbers),
                  ],
                ),
              ),
            ));
      });
}

void showNotesBottomSheet({BuildContext context, List<String> notes}) {
  showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Container(
          color: Colors.transparent, //could change this to Color(0xFF737373),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  "Notes:",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
              new Container(
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(10.0),
                          topRight: const Radius.circular(10.0))),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                          children: notes
                              .map((e) => Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        border: Border.all(
                                            color: AppColors.blueHaze,
                                            width: 1.0)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        e,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ))
                              .toList()),
                    ),
                  )),
            ],
          ),
        );
      });
}

List<Widget> _getPhoneList(List<CallingOptions> numbers) {
  List<Widget> phoneList = [];
  for (CallingOptions number in numbers) {
    phoneList.add(
      _contactItem(
          text: number.phoneNumber ?? "No phone provided",
          icon: AppImages.phoneCustomer,
          label: number.name),
    );
    phoneList.add(SizedBox(
      height: 24.0,
    ));
  }
  return phoneList;
}

Widget _contactItem({var icon, var text, var label}) {
  return GestureDetector(
    onTap: () => launchURL(text, scheme: "tel"),
    child: Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: AppColors.blueHaze, width: 1.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            Image.asset(
              icon,
              height: 32.0,
              width: 32.0,
            ),
            SizedBox(
              width: 16.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Text(
                  text,
                  style: TextStyle(color: AppColors.emperor),
                )
              ],
            ),
          ],
        ),
      ),
    ),
  );
}