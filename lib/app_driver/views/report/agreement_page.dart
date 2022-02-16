import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:transportation_mobile_app/app_driver/models/entities/calling_options.dart';
import 'package:transportation_mobile_app/app_driver/models/entities/globals.dart';
import 'package:transportation_mobile_app/app_driver/models/entities/report_enums.dart';
import 'package:transportation_mobile_app/app_driver/models/entities/session.dart';
import 'package:transportation_mobile_app/app_common/utils/app_colors.dart';
import 'package:transportation_mobile_app/app_driver/utils/app_images.dart';
import 'package:transportation_mobile_app/app_driver/widgets/report/bottom_sheet.dart';
import 'package:transportation_mobile_app/app_driver/widgets/report/call_msg_button.dart';
import 'package:transportation_mobile_app/app_driver/widgets/report/marquee_widget.dart';
import 'package:transportation_mobile_app/app_driver/widgets/report/rectangular_button.dart';
import 'package:transportation_mobile_app/app_driver/widgets/report/time_left_widget.dart';

class AgreementPage extends StatefulWidget {
  @override
  _AgreementPageState createState() => _AgreementPageState();
}

class _AgreementPageState extends State<AgreementPage>
    with AutomaticKeepAliveClientMixin<AgreementPage> {
  bool get wantKeepAlive => true;
  Color checkboxColor = const Color(0xff112a39);
  Color checkboxBorderColor = const Color(0xff7099b2);
  bool _hasAgreedConditions = false;
  SessionObject session = getCurrentSession();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: AppColors.portGore,
        actions: <Widget>[
          CallMsgButton(
            onTap: () {
              showCallOptionsBottomSheet(
                context: context,
                numbers: [
                  CallingOptions(
                    name: session.customer ?? "Customer",
                    phoneNumber: session.customerPhone ??
                        "Phone number is not available",
                  ),
                  CallingOptions(
                    name: session.broker ?? "Broker",
                    phoneNumber:
                        session.brokerPhone ?? "Phone number is not available",
                  ),
                  CallingOptions(
                    name: session.source ?? "Pickup Location",
                    phoneNumber:
                        session.source.phone ?? "Phone number is not available",
                  ),
                  CallingOptions(
                    name: session.destination ?? "Drop off Location",
                    phoneNumber: session.destination.phone ??
                        "Phone number is not available",
                  )
                ],
              );
            },
          ),
        ],
        leading: IconButton(
            icon: Icon(
              Icons.chevron_left,
              color: AppColors.alizarinCrimson,
              size: 32.0,
            ),
            color: const Color(0xff7099b2),
            onPressed: () {
              Modular.to.popUntil(ModalRoute.withName('/inspection/dashboard'));
            }),
        centerTitle: true,
      ),
      body: SingleChildScrollView(child: _newScreen()),
    );
  }

  Widget _newScreen() {
    return Column(
      children: [
        header(),
        bodyPart(),
      ],
    );
  }

  Widget header() {
    return Container(
        decoration: BoxDecoration(color: AppColors.portGore),
        // height: 285.0,
        width: double.infinity,
        child: Column(children: [
          SizedBox(height: 15.0),
          Image.asset(AppImages.carPicBig, height: 100.0),
          SizedBox(height: 15.0),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 28.0),
              child: MarqueeWidget(
                child: Text(
                  session.title,
                  style: TextStyle(
                      fontFamily: 'poppins',
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18.0),
                ),
              ),
            ),
          ),
          SizedBox(height: 20.0),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.only(left: 28.0),
              width: 140.0,
              decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: AppColors.royalBlue),
                  borderRadius: BorderRadius.circular(100.0)),
              child: Padding(
                padding: EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    SvgPicture.asset(AppImages.checkCircle,
                        height: 24.0, width: 24.0),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      "PASSED DUE",
                      style: TextStyle(
                          fontFamily: "poppins",
                          fontWeight: FontWeight.w600,
                          color: AppColors.royalBlue,
                          fontSize: 12),
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20.0),
          Container(
              height: 1.0, width: double.infinity, color: AppColors.royalBlue),
          Container(
            height: 10,
          ),
          singleHeaderInformativeItem(
              icon: AppImages.document, text: "VIN: ${session.vin}"),
        ]));
  }

  Widget singleHeaderInformativeItem({var text, var icon}) {
    return Container(
      height: 40,
      child: Row(
        children: [
          SizedBox(
            width: 16.0,
          ),
          SvgPicture.asset(
            icon,
            width: 16.0,
            height: 16.0,
            color: AppColors.wildSand,
          ),
          SizedBox(
            width: 24.0,
          ),
          MarqueeWidget(
            child: Text(
              text,
              style: TextStyle(
                  fontFamily: "poppins",
                  fontWeight: FontWeight.bold,
                  color: AppColors.lavendarGrey,
                  fontSize: 14.0),
            ),
          )
        ],
      ),
    );
  }

  Widget singleItem({var icon, var text, var isWidget}) {
    isWidget = isWidget ?? false;
    return Align(
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              height: 20.0,
              width: 20.0,
            ),
            SizedBox(
              width: 24.0,
            ),
            isWidget
                ? text
                : Text(
                    text,
                    style: TextStyle(
                        fontFamily: "poppins",
                        color: AppColors.emperor,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600),
                  )
          ],
        ));
  }

  Widget bodyPart() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          SizedBox(
            height: 16.0,
          ),
          singleItem(
              text: DateFormat('MMM dd,yyyy').format(session.scheduledDate),
              icon: AppImages.calendar),
          SizedBox(
            height: 16.0,
          ),
          singleItem(
            isWidget: true,
            icon: AppImages.clock,
            text: TimeLeftWidget(session.scheduledDate, session.sessionStatus,
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.emperor,
                    fontWeight: FontWeight.w600)),
          ),
          SizedBox(
            height: 16.0,
          ),
          GestureDetector(
              onTap: () => MapsLauncher.launchQuery(session.source.toString()),
              child: singleItem(
                  text: "Pickup:" + session.source.toStringShort(),
                  icon: AppImages.location)),
          SizedBox(
            height: 16.0,
          ),
          GestureDetector(
              onTap: () =>
                  MapsLauncher.launchQuery(session.destination.toString()),
              child: singleItem(
                  text: "Drop: " + session.destination.toStringShort(),
                  icon: AppImages.location)),
          SizedBox(
            height: 16.0,
          ),
          GestureDetector(
              onTap: () => launchURL(session.customerPhone, scheme: "tel"),
              child: singleItem(
                  text: session.customerPhone ?? "NA",
                  icon: AppImages.phoneMsg)),
          SizedBox(
            height: 24.0,
          ),
          Text(
            "Prior to starting this session:",
            style: TextStyle(
                fontFamily: "poppins",
                color: AppColors.emperor,
                fontWeight: FontWeight.w800),
          ),
          SizedBox(
            height: 8.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Make sure that the vehicle being picked up completely matches the description above."
              "\n\nTo call your buyer or customer at any time click on the “ i ” icon",
              style: TextStyle(
                  fontFamily: "poppins",
                  fontSize: 12.0,
                  color: AppColors.emperor,
                  fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            height: 24.0,
          ),
          GestureDetector(
              onTap: () {
                setState(() {
                  _hasAgreedConditions = !_hasAgreedConditions;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _hasAgreedConditions
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: AppColors.pictonBlue,
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  RichText(
                    text: TextSpan(
                        text: "I agree to",
                        style: TextStyle(
                            fontFamily: "poppins",
                            color: AppColors.silverChalice,
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0),
                        children: <TextSpan>[
                          TextSpan(
                              text: " Terms & Conditions",
                              style: TextStyle(
                                  fontFamily: "poppins",
                                  color: AppColors.pictonBlue,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.0))
                        ]),
                  ),
                ],
              )),
          SizedBox(
            height: 20.0,
          ),
          RectangularButton(
              text: "Start Session",
              backgroundColor: AppColors.alizarinCrimson,
              textColor: Colors.white,
              onTap: () {
                if (_hasAgreedConditions) {
                  currentSession.updateStatus(SessionStatus.Started);
                  Modular.to.popAndPushNamed('/driver/service/report',
                      arguments: ReportCategories.PickupPictures);
                } else {
                  final snackBar = SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(
                          "Please accept our terms and conditions to start."));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              }),
          SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }

  FutureOr onGoBack(Object value) {
    setState(() {
      print(value as String);
    });
  }
}
