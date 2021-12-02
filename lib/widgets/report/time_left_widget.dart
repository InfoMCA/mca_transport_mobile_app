import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transportation_mobile_app/models/entities/session.dart';
import 'package:transportation_mobile_app/utils/app_colors.dart';

class TimeLeftWidget extends StatefulWidget {
  final DateTime dateTimeScheduled;
  final SessionStatus sessionStatus;
  final bool showBorder;
  TextStyle style;

  TimeLeftWidget(this.dateTimeScheduled, this.sessionStatus,
      {this.showBorder: false, this.style});

  @override
  _TimeLeftWidgetState createState() =>
      _TimeLeftWidgetState(dateTimeScheduled, sessionStatus);
}

class _TimeLeftWidgetState extends State<TimeLeftWidget> {
  int hours = 0;
  int minutes = 0;
  int differenceMinutes = 0;
  DateTime dateTimeScheduled;
  SessionStatus sessionStatus;
  Timer periodicTimer;

  _TimeLeftWidgetState(
      DateTime dateTimeScheduled, SessionStatus sessionStatus) {
    this.dateTimeScheduled = dateTimeScheduled;
    this.sessionStatus = sessionStatus;
    updateDifference();
    periodicTimer = new Timer.periodic(
        Duration(minutes: 1), (Timer t) => setState(() => updateDifference()));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.style == null) {
      if (!widget.showBorder) {
        widget.style = GoogleFonts.poppins(
          fontSize: 12,
          color: AppColors.emperor,
        );
      } else {
        widget.style = GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        );
      }
    }

    if (!widget.showBorder) {
      return Text(getMessage(differenceMinutes), style: widget.style);
    }

    return Container(
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: (differenceMinutes > 0 ? Color(0xffe9486d) : Colors.green)
                  .withOpacity(0.35),
              blurRadius: 15.0,
              // has the effect of softening the shadow
              spreadRadius: 0.5,
              // has the effect of extending the shadow
              offset: Offset(
                0.0, // horizontal, move right 10
                5.0, // vertical, move down 10
              ),
            ),
          ],
          border: Border.all(
              color:
                  (differenceMinutes > 0 ? Color(0xffe9486d) : Colors.green)),
          borderRadius: BorderRadius.circular(15)),
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(getMessage(differenceMinutes), style: widget.style)),
    );
  }

  String getMessage(int differenceMinutes) {
    if (differenceMinutes < 0) {
      return "Hasn't started yet";
    } else if (sessionStatus == SessionStatus.DISPATCHED &&
        differenceMinutes > 0) {
      return "Passed due!";
    } else if (sessionStatus == SessionStatus.TRANSFERRING && hours < 12) {
      return "$hours hour $minutes minutes";
    } else if (sessionStatus == SessionStatus.TRANSFERRING && hours >= 12) {
      return "More than 12 hrs";
    } else {
      return "$sessionStatus";
    }
  }

  void updateDifference() {
    differenceMinutes =
        DateTime.now().difference(this.dateTimeScheduled).inMinutes;
    hours = (differenceMinutes / 60).floor();
    minutes = differenceMinutes % 60;
  }

  @override
  void dispose() {
    super.dispose();
    if (periodicTimer.isActive) {
      periodicTimer.cancel();
    }
  }
}