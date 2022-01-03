import 'package:flutter/material.dart';
import 'package:transportation_mobile_app/app_driver/models/entities/calling_options.dart';
import 'package:transportation_mobile_app/app_driver/models/entities/globals.dart';
import 'package:transportation_mobile_app/app_common/utils/app_colors.dart';
import 'package:transportation_mobile_app/app_driver/utils/app_images.dart';

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
              padding: const EdgeInsets.all(8.0),
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
  numbers.where((element) => element.phoneNumber != null).forEach((element) {
    phoneList.add(
      _contactItem(
          text: element.phoneNumber,
          icon: AppImages.phoneUser,
          label: element.name),
    );
    phoneList.add(SizedBox(
      height: 8.0,
    ));
  });
  return phoneList;
}

Widget _contactItem({var icon, var text, var label}) {
  return GestureDetector(
    onTap: () => launchURL(text, scheme: "tel"),
    child: Container(
      height: 60,
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
                SizedBox(
                  height: 4.0,
                ),
                Text(
                  label,
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'poppins',
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 4.0,
                ),
                Text(
                  text,
                  style: TextStyle(
                      color: AppColors.emperor,
                      fontFamily: 'poppins',
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 4.0,
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
