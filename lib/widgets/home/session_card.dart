import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:transportation_mobile_app/models/entities/globals.dart';
import 'package:transportation_mobile_app/models/entities/session.dart';
import 'package:transportation_mobile_app/utils/app_colors.dart';
import 'package:transportation_mobile_app/utils/app_images.dart';
import 'package:transportation_mobile_app/utils/hex_color.dart';

class SessionCard extends StatefulWidget {
  final String title;
  final SessionObject session;

  SessionCard(this.title, this.session);

  @override
  State<SessionCard> createState() => _SessionCardState();
}

class _SessionCardState extends State<SessionCard> {
  String followupScreen = "/service/agreement";
  Color cardBackgroundColor = Colors.white;
  Color iconColor = Colors.black;
  String statusIcon = AppImages.ongoingSession;
  Color stepperColor = AppColors.athenesGrey;

  @override
  Widget build(BuildContext context) {
    getCardBackgroundColor();
    if (widget.session == null) {
      return Container(
        height: 0.0,
      );
    }

    if (widget.session.sessionStatus == SessionStatus.DISPATCHED) {
      followupScreen = "/service/agreement";
    } else {
      followupScreen = "/service/report";
    }

    return GestureDetector(
      onTap: () async {
        SessionObject session = null;//await SessionObject.getFromLocalStorage(widget.session.id);
        if (session == null) {
          session = widget.session;
        }
        setCurrentSession(session);
        Modular.to.pushNamed(followupScreen);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          cardLeftSide(),
          SizedBox(
            width: 4.0,
          ),
          cardRightSide(MediaQuery.of(context).size.width),
        ],
      ),
    );
  }

  Widget cardLeftSide() {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 24.0,
            width: 24.0,
            decoration: BoxDecoration(
              color: stepperColor,
              borderRadius: BorderRadius.circular(100.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: SvgPicture.asset(
                statusIcon,
                color: iconColor,
                height: 10.0,
                width: 10.0,
              ),
            ),
          ),
          Container(
            height: 165.0,
            child: Column(
              children: [
                Expanded(
                    flex: 12,
                    child: Container(
                      width: 2.0,
                      color: stepperColor,
                    )),
                SizedBox(
                  height: 4.0,
                ),
                Expanded(
                    flex: 1,
                    child: Container(
                      width: 2.0,
                      color: stepperColor,
                    )),
                SizedBox(
                  height: 4.0,
                ),
                Expanded(
                    flex: 1,
                    child: Container(
                      width: 2.0,
                      color: stepperColor,
                    )),
                SizedBox(
                  height: 4.0,
                ),
                Expanded(
                    flex: 1,
                    child: Container(
                      width: 2.0,
                      color: stepperColor,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget cardHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 0),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4),
                  Text(
                      widget.session.sessionStatus.getName() + ": " + widget.session.title.toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14.0,
                      color: HexColor('#282828'),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: Colors.black,
                        size: 16.0,
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Text(
                          DateFormat('MMM dd , yyyy – kk')
                              .format(widget.session.scheduledDate),
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              color: AppColors.emperor,
                              fontWeight: FontWeight.w500)),
                    ],
                  ), 
                ],
              )),
          Expanded(
              flex: 1,
              child: Container(
                child: Center(
                  child: Image.asset(
                    AppImages.carPic,
                    height: 100.0,
                    width: 100.0,
                  ),
                ),
              ))
        ],
      ),
    );
  }

  Widget cardDateAndCity(width) {
    return Container(
      child: Column(
        children: [
          Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.grey.withOpacity(0.5)),
          Container(
              width: double.infinity,
              height: 40,
            child: TextButton(
              onPressed: () => MapsLauncher.launchQuery(widget.session.source.toString()),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 8),
                  Icon(
                    Icons.location_city_sharp,
                    color: Colors.black,
                    size: 16.0,
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Text("From: ${widget.session.source.toString()}",
                      style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          color: AppColors.emperor,
                          fontWeight: FontWeight.w500)),
                  SizedBox(
                    width: 8.0,
                  ),
                ],
              ),
            ),
          ),
          Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.grey.withOpacity(0.5)),
          Container(
            width: double.infinity,
            height: 40,
            child: TextButton(
              onPressed: () => MapsLauncher.launchQuery(widget.session.destination.toString()),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 8),
                  Icon(
                    Icons.location_city_sharp,
                    color: Colors.black,
                    size: 16.0,
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Text("To: ${widget.session.destination.toString()}",
                      style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          color: AppColors.emperor,
                          fontWeight: FontWeight.w500)),
                  SizedBox(
                    width: 8.0,
                  ),
                ],
              ),
            ),
          ),
          Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.grey.withOpacity(0.5)),
        ],
      ),
    );
  }

  getCardBackgroundColor() {
    if (widget.session.sessionStatus == SessionStatus.DISPATCHED) {
      cardBackgroundColor = AppColors.lightBlue;
      iconColor = AppColors.cadetBlue;
      statusIcon = AppImages.ongoingSession;
      stepperColor = AppColors.lightBlue;
    } else if (widget.session.sessionStatus == SessionStatus.STARTED) {
      cardBackgroundColor = AppColors.lightRed;
      iconColor = Colors.white;
      statusIcon = AppImages.ongoingSession;
      stepperColor = AppColors.darkRed;
    } else if (widget.session.sessionStatus == SessionStatus.PICKUP) {
      cardBackgroundColor = AppColors.lightYellow;
      iconColor = Colors.white;
      statusIcon = AppImages.upcomingSession;
      stepperColor = AppColors.darkYellow;
    } else if (widget.session.sessionStatus == SessionStatus.TRANSFERRING) {
      cardBackgroundColor = AppColors.stillUploadingSession;
      iconColor = AppColors.cadetBlue;
      statusIcon = AppImages.uploadingSession;
      stepperColor = AppColors.athenesGrey;
    } else if (widget.session.sessionStatus == SessionStatus.DROPPED) {
      cardBackgroundColor = AppColors.pendingApprovalSession;
      iconColor = AppColors.cadetBlue;
      statusIcon = AppImages.pendingApprovedSession;
      stepperColor = AppColors.athenesGrey;
    } else if (widget.session.sessionStatus == SessionStatus.COMPLETED) {
      cardBackgroundColor = AppColors.approvedSession;
      iconColor = Colors.white;
      statusIcon = AppImages.pendingApprovedSession;
      stepperColor = Colors.green;
    } else {
      cardBackgroundColor = AppColors.chablis;
      iconColor = AppColors.cadetBlue;
      statusIcon = AppImages.ongoingSession;
      stepperColor = Colors.green;
    }
  }

  Widget cardRightSide(width) {
    return Container(
      width: 320,
      child: Card(
        color: Colors.transparent,
        elevation: 8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(

              decoration: BoxDecoration(
                  color: cardBackgroundColor,
                  borderRadius: BorderRadius.circular(8.0)),
              child: Column(
                children: [
                  cardHeader(),
                  cardDateAndCity(width),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}