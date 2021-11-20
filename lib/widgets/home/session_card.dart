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
        SessionObject session = await SessionObject.getFromLocalStorage(widget.session.id);
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
                  Text(
                    widget.session.title.toUpperCase(),
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
                Text("ID:" + widget.session.id.substring(0, 5))],
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
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => MapsLauncher.launchQuery(widget.session.srcAddress.toString()),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 16),
                          Icon(
                            Icons.location_city_sharp,
                            color: Colors.black,
                            size: 16.0,
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Text("From: ${widget.session.srcAddress.city} , ${widget.session.srcAddress.state}",
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
                ),
              ),
              Container(
                height: 40.0,
                color: Colors.grey.withOpacity(0.5),
                width: 1.0,
              ),
              Expanded(
                flex: 1,
                child: TextButton(
                  onPressed:() => MapsLauncher.launchQuery(widget.session.dstAddress.toString())
                  ,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 16),
                          Icon(
                            Icons.map_outlined,
                            color: Colors.black,
                            size: 16.0,
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Text("To: ${widget.session.dstAddress.city} , ${widget.session.dstAddress.state}",
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: HexColor('#525252'),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
      cardBackgroundColor = AppColors.blueHaze;
      iconColor = AppColors.cadetBlue;
      statusIcon = AppImages.ongoingSession;
      stepperColor = AppColors.athenesGrey;
    } else if (widget.session.sessionStatus == SessionStatus.PICKUP) {
      cardBackgroundColor = AppColors.upcomingSession;
      iconColor = AppColors.cadetBlue;
      statusIcon = AppImages.upcomingSession;
      stepperColor = AppColors.athenesGrey;
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
    return Expanded(
      flex: 11,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.session.sessionStatus.toString().substring(14),
            style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: HexColor('#1d1d1d')),
          ),
          SizedBox(
            height: 12.0,
          ),
          Container(
            decoration: BoxDecoration(
                color: cardBackgroundColor,
                borderRadius: BorderRadius.circular(8.0)),
            child: Column(
              children: [
                cardHeader(),
                cardDateAndCity(width),
                SizedBox(height: 24,)
              ],
            ),
          ),
        ],
      ),
    );
  }

}