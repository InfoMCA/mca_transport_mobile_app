import 'dart:async';
import 'dart:collection';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:transportation_mobile_app/app_driver/controllers/report/bill_of_lading.dart';
import 'package:transportation_mobile_app/app_driver/models/entities/calling_options.dart';
import 'package:transportation_mobile_app/app_driver/models/entities/globals.dart';
import 'package:transportation_mobile_app/app_driver/models/entities/inspection_item.dart';
import 'package:transportation_mobile_app/app_driver/models/entities/report_enums.dart';
import 'package:transportation_mobile_app/app_driver/models/entities/session.dart';
import 'package:transportation_mobile_app/app_common/utils/app_colors.dart';
import 'package:transportation_mobile_app/app_driver/utils/app_images.dart';
import 'package:transportation_mobile_app/app_driver/views/report/panels/pictures_grid.dart';
import 'package:transportation_mobile_app/app_driver/views/report/panels/signature.dart';
import 'package:transportation_mobile_app/app_driver/widgets/report/bottom_sheet.dart';
import 'package:transportation_mobile_app/app_driver/widgets/report/button_widget.dart';
import 'package:transportation_mobile_app/app_driver/widgets/report/call_msg_button.dart';
import 'package:transportation_mobile_app/app_driver/widgets/report/digital_input_menu.dart';
import 'package:transportation_mobile_app/app_driver/widgets/report/marquee_widget.dart';
import 'package:transportation_mobile_app/app_driver/widgets/report/rectangular_button.dart';

class InspectionMainPage extends StatefulWidget {
  @override
  _InspectionMainPageState createState() => _InspectionMainPageState();
}

class _InspectionMainPageState extends State<InspectionMainPage>
    with SingleTickerProviderStateMixin {
  ReportCategories selectedTab;

  SessionObject session = getCurrentSession();
  bool isEditSession = true;
  final List<CallingOptions> calls = [];
  Map<ReportCategories, bool> _panelExpanded = new HashMap();
  InspectionItem signatureImage;
  InspectionItem customerName;
  Timer uploadTimer;
  int uploadProgress = 0;

  final iconMap = {
    "Call Customer": Icons.phone,
    "Call Support": Icons.phone_android
  };

  Map<ReportTabs, List<ReportCategories>> tabCategories = {
    ReportTabs.PickUp: [
      ReportCategories.PickupPictures,
      ReportCategories.PickupSignature
    ],
    ReportTabs.DropOff: [
      ReportCategories.DropOffPictures,
      ReportCategories.DropOffSignature
    ],
  };

  Widget _getTabBody(ReportCategories reportTabName) {
    switch (reportTabName) {
      case ReportCategories.PickupPictures:
      case ReportCategories.DropOffPictures:
        return new GridPicturePage(
            key: Key(reportTabName.getName()),
            reportTabName: reportTabName,
            gridItems: session.categoryItems[reportTabName.getName()],
            isEditable: reportTabName.canUserEditTab(session.sessionStatus));

      case ReportCategories.PickupSignature:
      case ReportCategories.DropOffSignature:
        return new SignatureTabPage(
          key: Key(reportTabName.getName()),
          reportTabName: reportTabName,
          reportingCategories: tabCategories[reportTabName],
        );
    }
    return Container();
  }

  ReportCategories _getByPanelIndex(ReportTabs reportTab, int index) {
    if (reportTab == ReportTabs.PickUp && index == 0) {
      return ReportCategories.PickupPictures;
    }
    if (reportTab == ReportTabs.PickUp && index == 1) {
      return ReportCategories.PickupSignature;
    }
    if (reportTab == ReportTabs.DropOff && index == 0) {
      return ReportCategories.DropOffPictures;
    }
    if (reportTab == ReportTabs.DropOff && index == 1) {
      return ReportCategories.DropOffSignature;
    }
    return ReportCategories.PickupPictures;
  }

  @override
  void initState() {
    super.initState();
    ReportCategories.values.forEach((element) {
      _panelExpanded[element] = false;
    });
    setState(() {
      selectedTab = currentSession.getCurrentReportTab();
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (uploadTimer != null) {
      if (uploadTimer.isActive) {
        uploadTimer.cancel();
      }
    }
  }

  int _getInitialTab() {
    switch (currentSession.sessionStatus) {
      case SessionStatus.Dispatched:
      case SessionStatus.Started:
        return 0;
      case SessionStatus.Pickup:
      case SessionStatus.Transferring:
      case SessionStatus.Dropped:
      case SessionStatus.Completed:
        return 1;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: ReportTabs.values.length,
      initialIndex: _getInitialTab(),
      child: Scaffold(
        backgroundColor: AppColors.portGore,
        appBar: AppBar(
            title: Container(
                width: double.maxFinite,
                child: Column(
                  children: [
                    MarqueeWidget(
                        child: Text(
                      session.title,
                      style: TextStyle(
                          fontFamily: 'poppins',
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700),
                    )),
                  ],
                )),
            backgroundColor: AppColors.portGore,
            actions: [
              TextButton(
                  onPressed: () => showNotesBottomSheet(
                      context: context, notes: session.notes),
                  child: Container(
                    height: 30.0,
                    width: 30.0,
                    decoration: BoxDecoration(
                        color: AppColors.alizarinCrimson,
                        borderRadius: BorderRadius.circular(40.0)),
                    child: Icon(
                      Icons.comment,
                      size: 15,
                      color: Colors.black,
                    ),
                  )),
              CallMsgButton(
                onTap: () {
                  showCallOptionsBottomSheet(
                    context: context,
                    numbers: [
                      CallingOptions(
                        name: session.customer ?? "Customer",
                        phoneNumber: session.customerPhone,
                      ),
                      CallingOptions(
                        name: session.broker ?? "Broker",
                        phoneNumber: session.brokerPhone,
                      ),
                      CallingOptions(
                        name: session.source.firstName ?? "Pickup Location",
                        phoneNumber: session.source.phone,
                      ),
                      CallingOptions(
                        name: session.destination.firstName ??
                            "Drop off Location",
                        phoneNumber: session.destination.phone,
                      )
                    ],
                  );
                },
              ),
            ],
            bottom: new TabBar(
              tabs: [
                Tab(child: Text("Pick Up")),
                Tab(child: Text("Drop Off")),
              ],
            )),
        /*--------------- Build Tab body here -------------------*/
        body: Container(
          color: Colors.white,
          child: TabBarView(
              children: tabCategories.entries
                  .map((e) =>
                      SingleChildScrollView(child: tabPage(e.key, e.value)))
                  .toList()),
        ),
      ),
    );
  }

  Widget tabPage(ReportTabs tabIndex, List<ReportCategories> categories) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
          color: Colors.white,
        ),
        child: Column(children: [
          Container(
            height: 16,
          ),
          Container(
            height: 40,
            child: Text(
              tabIndex.getName(),
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  fontSize: 20.0),
            ),
          ),
          tabIndex.canUserEditTab(session.sessionStatus)
              ? Container()
              : Text(
                  "View mode only",
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      fontSize: 14.0),
                ),
          Container(
            height: MediaQuery.of(context).size.height,
            child: ListView(children: [
              Column(children: <Widget>[
                ExpansionPanelList(
                  expandedHeaderPadding: EdgeInsets.all(0),
                  expansionCallback: (int index, bool isExpanded) {
                    setState(() {
                      ReportCategories.values.forEach((element) {
                        _panelExpanded[element] = false;
                      });
                      _panelExpanded[_getByPanelIndex(tabIndex, index)] =
                          !isExpanded;
                    });
                  },
                  animationDuration: Duration(milliseconds: 500),
                  children: categories
                      .map((e) => ExpansionPanel(
                          canTapOnHeader: true,
                          headerBuilder:
                              (BuildContext context, bool isExpanded) {
                            return ListTile(
                                title: Text(
                              e.getTitle(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'poppins',
                                  fontWeight: FontWeight.w700),
                            ));
                          },
                          body: Container(
                            padding: EdgeInsets.only(bottom: 16),
                            child: Center(
                              child: _getTabBody(e),
                            ),
                          ),
                          isExpanded: _panelExpanded[e]))
                      .toList(),
                ),
                Container(
                  height: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          List<InspectionItem> allItems = [];
                          for (ReportCategories category in categories) {
                            allItems.addAll(getCurrentSession()
                                .reportItems
                                .where((element) =>
                                    element.category == category.getName()));
                          }
                          BillOfLading().generate(currentSession, allItems);
                        },
                        child: Row(
                          children: [
                            Icon(Icons.print),
                            VerticalDivider(),
                            Text(
                              "Bill of Lading",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      if (tabIndex
                          .canUserEditTab(getCurrentSession().sessionStatus))
                        Center(
                          child: TextButton(
                            onPressed: () async {
                              getCurrentSession().saveToLocalStorage();
                              _showWarningDialog(context, categories);
                            },
                            child: Container(
                              height: 40.0,
                              width: 100.0,
                              decoration: BoxDecoration(
                                  color: AppColors.portGore,
                                  borderRadius: BorderRadius.circular(16.0)),
                              child: Center(
                                child: Text(
                                  "Submit",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Container(height: 300),
              ])
            ]),
          ),
        ]));
  }

  void _showWarningDialog(context, List<ReportCategories> reportCategories) {
    List<String> missingPictures = _getMissingPicture(reportCategories);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: new SingleChildScrollView(
                  child: Container(
                      child: Column(children: <Widget>[
                SizedBox(
                  height: 10.0,
                ),
                Image.asset(
                  AppImages.missingError,
                  height: 50.0,
                  width: 70.0,
                ),
                Container(
                  height: 15.7,
                ),
                Container(
                    child: Text(
                  missingPictures.isEmpty
                      ? "You are about to submit your progress. You CANNOT UNDO this action."
                      : 'MISSING INFO IN THE FOLLOWING AREAS:',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                )),
                Container(
                  height: 20,
                ),
                Column(
                    children: missingPictures
                        .map((e) => DigitalInputErrorMenu(error: e))
                        .toList()),
              ]))),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(width: 8),
                    RectangularButton(
                        backgroundColor: AppColors.alizarinCrimson,
                        onTap: () {
                          for (ReportCategories category in reportCategories) {
                            getCurrentSession().uploadReport(category);
                          }
                          getCurrentSession().saveToLocalStorage();
                          Navigator.of(context).pop();
                          _showUploadDialog(context);
                        },
                        text: "PROCEED ANYWAY".padLeft(18).padRight(24),
                        textColor: Colors.white),
                    Container(width: 16),
                    RectangularButton(
                        backgroundColor: AppColors.portGore,
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        text: "BACK".padLeft(10).padRight(16),
                        textColor: Colors.white),
                    Container(width: 16),
                  ],
                )
              ]);
        });
  }

  void _showUploadDialog(context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            if (uploadTimer == null) {
              uploadTimer = new Timer.periodic(Duration(seconds: 1), (Timer t) {
                print('Timer Finished');
                setState(() {
                  print(uploadProgress);
                  uploadProgress = getCurrentSession().getUploadProgress();
                  if (uploadProgress == 100) {
                    uploadTimer.cancel();
                    Modular.to.popAndPushNamed('/driver/home');
                  }
                  uploadProgress = min(uploadProgress, 100);
                });
              });
            }
            return SingleChildScrollView(
                child: Container(
                    color: Colors.white,
                    child: Column(children: <Widget>[
                      Container(
                        height: 15.7,
                      ),
                      Container(
                          child: Text(
                        'Uploading Report',
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.portGore,
                        ),
                      )),
                      Container(
                        height: 20,
                      ),
                      new CircularPercentIndicator(
                        radius: 60.0,
                        lineWidth: 5.0,
                        percent: uploadProgress / 100,
                        center: new Text(
                          uploadProgress.toString() + "%",
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white70,
                          ),
                        ),
                        progressColor: Theme.of(context).colorScheme.secondary,
                      )
                    ])));
          }),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            ButtonWidget(
              buttonColor: ButtonColor.primary,
              color: Colors.white,
              width: 300,
              text: 'Continue Upload in Background',
              onTap: () {
                uploadTimer.cancel();
                Modular.to.popAndPushNamed('/driver/home');
              },
            ),
          ],
        );
      },
    );
  }

  List<String> _getMissingPicture(List<ReportCategories> reportCategories) {
    List<String> missingItems = [];
    ReportCategories signatureCategory = reportCategories
        .where((element) => element.getTitle() == 'Signature')
        .first;
    signatureImage = getCurrentSession()
        .categoryItems[signatureCategory.getName()]
        .firstWhere((InspectionItem element) =>
            element.name == ReportCategoryItems.SignatureImage.getName());
    customerName = getCurrentSession()
        .categoryItems[signatureCategory.getName()]
        .firstWhere((element) =>
            element.name == ReportCategoryItems.CustomerName.getName());
    if (signatureImage.signaturePoints == null ||
        signatureImage.signaturePoints.length < 20) {
      missingItems.add("Signature");
    }
    if (customerName.value == null || customerName.value.isEmpty) {
      missingItems.add("Customer Name");
    }
    return missingItems;
  }

  void _copyInspectionItemValues(
      {@required List<InspectionItem> src,
      @required List<InspectionItem> dst}) {
    for (InspectionItem item in src) {
      dst
          .firstWhere((element) => element.name == item.name,
              orElse: () => InspectionItem())
          .value = item.value;
    }
    dev.log("Copied inspection items");
  }
}
