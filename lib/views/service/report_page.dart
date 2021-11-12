import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:transportation_mobile_app/models/entities/globals.dart';
import 'package:transportation_mobile_app/models/entities/report_enums.dart';
import 'package:transportation_mobile_app/models/entities/session.dart';
import 'package:transportation_mobile_app/models/entities/calling_options.dart';
import 'package:transportation_mobile_app/utils/app_colors.dart';
import 'package:transportation_mobile_app/utils/app_images.dart';
import 'package:transportation_mobile_app/utils/tab_icon_constants.dart';
import 'package:transportation_mobile_app/views/service/tabs/pictures_grid.dart';
import 'package:transportation_mobile_app/views/service/tabs/signature.dart';
import 'package:transportation_mobile_app/widgets/service/call_bottom_sheet.dart';
import 'package:transportation_mobile_app/widgets/service/call_msg_button.dart';
import 'package:transportation_mobile_app/widgets/service/marquee_widget.dart';

class InspectionMainPage extends StatefulWidget {
  @override
  _InspectionMainPageState createState() => _InspectionMainPageState();
}

class _InspectionMainPageState extends State<InspectionMainPage>
    with SingleTickerProviderStateMixin {
  ReportCategories selectedTab;

  SessionObject session = getCurrentSession();
  bool isEditSession = true;

  final iconMap = {
    "Call Customer": Icons.phone,
    "Call Support": Icons.phone_android
  };

  final pageTitle = [
    "Picking up Pictures",
    "Picking up Signature",
    "Dropping Off Pictures",
    "Dropping Off Signature",
  ];

  getTabBody(ReportCategories reportTabName) {
    switch (reportTabName) {
      case ReportCategories.PICKUP_PICTURES:
      case ReportCategories.DROP_OFF_PICTURES:
        return new GridPicturePage(
            key: Key(reportTabName.getName()),
            reportTabName: reportTabName,
            gridItems: session.categoryItems[reportTabName.getName()],
            isEditable: reportTabName.canUserEditTab(session.sessionStatus));
      case ReportCategories.PICKUP_SIGNATURE:
        return new SignatureTabPage(
          key: Key(reportTabName.getName()),
          reportTabName: reportTabName,
          reportingCategories: [
            ReportCategories.PICKUP_PICTURES,
            ReportCategories.PICKUP_SIGNATURE
          ],
        );
      case ReportCategories.DROP_OFF_SIGNATURE:
        return new SignatureTabPage(
            key: Key(reportTabName.getName()),
            reportTabName: reportTabName,
            reportingCategories: [
              ReportCategories.DROP_OFF_PICTURES,
              ReportCategories.DROP_OFF_SIGNATURE
            ]);
    }
  }

  changeTab({var reportTabName}) {
    setState(() {
      selectedTab = reportTabName;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedTab = currentSession.getCurrentReportTab();
    });
  }
  final List<CallingOptions> calls = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.portGore,
      appBar: AppBar(
        title: Container(
            width: double.infinity,
            child: Column(
              children: [
                MarqueeWidget(
                    child: Text(
                  session.title,
                  style: TextStyle(fontSize: 16.0),
                )),
                SizedBox(height: 4.0),
                Text(session.vin, style: TextStyle(fontSize: 14.0))
              ],
            )),
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.chevron_left,
            color: AppColors.alizarinCrimson,
            size: 32.0,
          ),
        ),
        backgroundColor: AppColors.portGore,
        elevation: 0.0,
        actions: [
          CallMsgButton(
            onTap: () {
              CallBottomSheet().showBottomSheet(
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
                    name: session.srcName ?? "Pickup Location",
                    phoneNumber: session.srcAddress.phone ??
                        "Phone number is not available",
                  ),
                  CallingOptions(
                    name: session.dstName ?? "Drop off Location",
                    phoneNumber: session.dstAddress.phone ??
                        "Phone number is not available",
                  )
                ],
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          tabBar(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          screenPage(),
        ],
      ),
    );
  }

  Widget screenPage() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Container(
            height: 16,
          ),
          Container(
            height: 40,
            child: Text(
              pageTitle[selectedTab.index],
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  fontSize: 20.0),
            ),
          ),
          selectedTab.canUserEditTab(session.sessionStatus)
              ? Container()
              : Text("View mode only"),
          SingleChildScrollView(
              child: Container(
            height: MediaQuery.of(context).size.height,
            child: getTabBody(selectedTab),
          )),
        ],
      ),
    );
  }

  Widget tabBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(left: 100),
        child: Stack(
          children: [
            normalTab(
              reportTabName: ReportCategories.PICKUP_PICTURES,
              iconPath: TabIcons.pictures,
              iconPrefix: "P",
              onTap: () =>
                  changeTab(reportTabName: ReportCategories.PICKUP_PICTURES),
            ),
            normalTab(
              reportTabName: ReportCategories.PICKUP_SIGNATURE,
              iconPath: TabIcons.signatures,
              iconPrefix: "P",
              onTap: () =>
                  changeTab(reportTabName: ReportCategories.PICKUP_SIGNATURE),
            ),
            normalTab(
                reportTabName: ReportCategories.DROP_OFF_PICTURES,
                iconPath: TabIcons.pictures,
                iconPrefix: "D",
                onTap: () => changeTab(
                    reportTabName: ReportCategories.DROP_OFF_PICTURES)),
            normalTab(
                reportTabName: ReportCategories.DROP_OFF_SIGNATURE,
                iconPath: TabIcons.signatures,
                iconPrefix: "D",
                onTap: () => changeTab(
                    reportTabName: ReportCategories.DROP_OFF_SIGNATURE))
          ],
        ),
      ),
    );
  }

  Widget normalTab(
      {@required ReportCategories reportTabName,
      @required String iconPath,
      @required VoidCallback onTap,
      @required iconPrefix,
      String backgroundImagePath}) {
    Color backgroundColor;
    Color iconColor;

    bool tabIsFilled = reportTabName.isTabFilled(session.sessionStatus);
    backgroundColor = selectedTab == reportTabName
        ? AppColors.kimberley
        : AppColors.portGoreDark;
    iconColor =
        selectedTab == reportTabName ? AppColors.portGore : AppColors.kimberley;
    if (!tabIsFilled) {
      backgroundImagePath = AppImages.normalTab;
    } else {
      backgroundImagePath = AppImages.normalTabRed;
      iconColor = Colors.green;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
          margin: EdgeInsets.only(left: reportTabName.index * 48.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                child: SvgPicture.asset(
                  backgroundImagePath,
                  height: 40.0,
                  width: 50.0,
                  color: backgroundColor,
                ),
              ),
              Row(
                children: [
                  Text(
                    iconPrefix,
                    style: TextStyle(color: iconColor),
                  ),
                  VerticalDivider(
                    width: 2,
                  ),
                  SvgPicture.asset(
                    iconPath,
                    height: 16.0,
                    width: 16.0,
                    color: iconColor,
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
