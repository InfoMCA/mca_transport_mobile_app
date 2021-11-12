import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:transportation_mobile_app/models/entities/globals.dart';
import 'package:transportation_mobile_app/models/entities/session.dart';
import 'package:transportation_mobile_app/utils/app_colors.dart';
import 'package:transportation_mobile_app/utils/app_images.dart';
import 'package:transportation_mobile_app/utils/app_strings.dart';
import 'package:transportation_mobile_app/widgets/home/session_card.dart';

class SessionPage extends StatefulWidget {
  @override
  _SessionPageState createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {
  bool isActive = true;

  @override
  Widget build(BuildContext context) {
    List<SessionObject> sessions = [];
    List<String> sessionTitle = [];

    for (SessionStatus sessionStatus in SessionStatus.values) {
      List<SessionObject> sessionObjects =
      currentStaff?.getUserSessions(sessionStatus: sessionStatus);
      if (sessionObjects != null && sessionObjects.isNotEmpty) {
        sessions.add(null);
        sessionTitle.add(sessionStatus.getName());
        for (SessionObject sessionObject in sessionObjects) {
          sessions.add(sessionObject);
          sessionTitle.add("");
        }
      }
    }

    return Column(
      children: [
        tabBar(),
        Container(
          height: MediaQuery.of(context).size.height * 0.815,
          child: ListView.builder(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.only(bottom: 50),
            scrollDirection: Axis.vertical,
            itemBuilder: (_, int index) {
              if (sessions[index] != null) {
                if (isActive) {
                  if (sessions[index].sessionStatus == SessionStatus.COMPLETED) {
                    return Container(
                      height: 0.0,
                      width: 0.0,
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SessionCard(sessionTitle[index], sessions[index]),
                    );
                  }
                } else {
                  if (sessions[index].sessionStatus == SessionStatus.DROPPED ||
                      sessions[index].sessionStatus == SessionStatus.TRANSFERRING ||
                      sessions[index].sessionStatus == SessionStatus.STARTED ||
                      sessions[index].sessionStatus == SessionStatus.DISPATCHED) {
                    return Container(
                      height: 0.0,
                      width: 0.0,
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SessionCard(sessionTitle[index], sessions[index]),
                    );
                  }
                }
              } else {
                return Container(
                  height: 0.0,
                  width: 0.0,
                );
              }
            },
            itemCount: sessions.length,
          ),
        ),
      ],
    );
  }

  Widget searchHeader(context) {
    double mainContainerHeight = 100.0;
    double searchBarHeight = 50.0;
    return Container(
      width: double.infinity,
      height: mainContainerHeight,
      child: Stack(
        children: [
          Container(
            child: Column(
              children: [
                Container(
                  height: mainContainerHeight / 2,
                  width: double.infinity,
                  color: AppColors.portGore,
                ),
                Container(
                  height: mainContainerHeight / 2,
                  width: double.infinity,
                  color: AppColors.concrete.withOpacity(0.2),
                  // color: Colors.white,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: searchBarHeight - (mainContainerHeight / 4),
                left: MediaQuery.of(context).size.width * 0.1),
            child: Container(
              height: searchBarHeight,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 5.0,
                    spreadRadius: 2.0,
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    flex: 4,
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: AppStrings.searchHint,
                      ),
                      style: TextStyle(color: Colors.black, fontSize: 12.0),
                      cursorColor: AppColors.portGore,
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: SvgPicture.asset(
                        AppImages.search,
                        height: 20.0,
                        width: 20.0,
                      )),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget tabBar() {
    return Container(
      height: 60.0,
      decoration: BoxDecoration(color: AppColors.portGore),
      child: Row(
        children: [
          singleTab(isActive, "Active", onTap: () {
            isActive = true;
            setState(() {});
          }),
          singleTab(
            !isActive,
            "Inactive",
            onTap: () {
              isActive = false;
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget singleTab(var isHighlight, var text, {VoidCallback onTap}) {
    var tabBottomColor =
    isHighlight ? AppColors.alizarinCrimson : AppColors.portGore;
    var textColor =
    isHighlight ? AppColors.alizarinCrimson : AppColors.kimberley;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(width: 3.0, color: tabBottomColor))),
          height: 60.0,
          child: Center(
              child: Text(
                text,
                style: TextStyle(fontFamily: 'poppins', color: textColor),
              )),
        ),
      ),
    );
  }
}