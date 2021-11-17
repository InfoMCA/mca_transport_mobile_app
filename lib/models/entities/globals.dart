import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:transportation_mobile_app/models/entities/auth_user.dart';
import 'package:transportation_mobile_app/models/entities/session.dart';
import 'package:transportation_mobile_app/models/interfaces/admin_interface.dart';
import 'package:url_launcher/url_launcher.dart';

String inspectionConfigStr;
SessionObject currentSession;
Map<SessionStatus, Set<SessionObject>> userSessions;
AuthUserModel _staff;

AuthUserModel get currentStaff {
  return _staff;
}

set currentStaff(AuthUserModel newStaff) {
  _staff = newStaff;
}

Map<String, dynamic> getInspectionConfig() {
  return jsonDecode(inspectionConfigStr);
}

void setInspectionConfig(String str) {
  inspectionConfigStr = str;
}

SessionObject getCurrentSession() {
  return currentSession;
}

void setCurrentSession(SessionObject session) {
  currentSession = session;
}

T enumFromString<T>(Iterable<T> values, String value) {
  return values.firstWhere((type) => type.toString().split(".").last == value,
      orElse: () => null);
}

Future<void> refreshSessions({String sessionId}) async {
  print("refresh Sessions");
  AppResp response = await AdminInterface()
      .getSessions(currentStaff.username, sessionId: sessionId);
  if (response.statusCode != HttpStatus.ok) {
    return;
  }
  List<SessionObject> globalSessions = currentStaff.getUserSessions();
  globalSessions.clear();
  globalSessions.addAll(response.sessionsList);
}
void showSnackBar(
    {BuildContext context, String text, Color backgroundColor = Colors.red}) {
  SnackBar snackbar =
      SnackBar(backgroundColor: backgroundColor, content: Text(text));
  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}

void launchURL(String url,
    {String scheme = "http",
    String path,
    Map<String, dynamic> queryParameters}) async {
  final Uri _launchUri =
      Uri(scheme: scheme, path: url, queryParameters: queryParameters);
  await launch(_launchUri.toString());
}

enum DATA_STATUS { PENDING, SUCCESS, FAILED }

var isPaintMeterCompleted = false;

Map successMap = {
  0: DATA_STATUS.PENDING,
  1: DATA_STATUS.PENDING,
  2: DATA_STATUS.PENDING,
  3: DATA_STATUS.PENDING,
  4: DATA_STATUS.PENDING,
  5: DATA_STATUS.PENDING,
  6: DATA_STATUS.PENDING,
  7: DATA_STATUS.PENDING,
};

String findOrientation(String name) {
  switch (name) {
    case 'Left':
    case 'Right':
    case 'Odometer':
    case 'Trunk':
    case 'Dashboard':
    case 'Steering':
    case 'Steering':
    case 'Driver License':
    case 'Registration':
      return 'picture/portrait';
      // return 'picture/landscape';
    default:
      return 'picture/portrait';
  }
}
