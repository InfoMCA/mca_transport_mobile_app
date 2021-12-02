import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:transportation_mobile_app/models/entities/globals.dart';
import 'package:transportation_mobile_app/models/entities/session.dart';

enum AppReqCmd {
  Login,
  UpdateStatus,
  GetStatus,
  GetDownloadURL,
  GetUploadURL,
  GetSessions,
  RegisterFCMToken,
  UpdateLocation
}

class AppReq {
  final AppReqCmd cmd;
  final String sessionId;
  final SessionStatus sessionStatus;
  final String objectName;
  String username;
  String password;
  String fcmToken;

  AppReq(
      {this.cmd,
      this.sessionId,
      this.sessionStatus,
      this.objectName,
      this.username,
      this.password,
      this.fcmToken});

  Map<String, dynamic> toJson() {
    return {
      'cmd': EnumToString.convertToString(cmd),
      'sessionId': sessionId,
      'sessionStatus': sessionStatus == null
          ? null
          : EnumToString.convertToString(sessionStatus),
      'objectName': objectName,
      'username': username,
      'password': password,
      'fcmToken': fcmToken,
    };
  }
}

class AppResp {
  int statusCode;
  String message;
  String status;
  String preSignedUrl;
  List<SessionObject> sessionsList;

  AppResp(
      {this.message,
      this.status,
      this.preSignedUrl,
      this.sessionsList,
      this.statusCode});

  factory AppResp.fromJson(Map<String, dynamic> parsedJson) {
    List<SessionObject> sessions = [];
    if (parsedJson['sessionsList'] != null) {
      var sessionsObjJson = parsedJson['sessionsList'] as List;
      sessions = new List<SessionObject>.from(sessionsObjJson
          .map((sessionsJson) => SessionObject.fromJson(sessionsJson))
          .toList());
    }
    return AppResp(
        message: parsedJson['message'],
        status: parsedJson['status'],
        statusCode: parsedJson['statusCode'],
        preSignedUrl: parsedJson['preSignedUrl'],
        sessionsList: sessions);
  }
}

class AdminInterface {
  final String endpoint = env['API_ADMIN_APP_REQUEST'];
  String status;
  String message;
  var dio = Dio();

  Future<String> getPreSignedUri(String sessionId, SessionStatus status,
      String objectName, bool upload) async {
    try {
      var data = json.encode(AppReq(
          cmd: upload ? AppReqCmd.GetUploadURL : AppReqCmd.GetDownloadURL,
          sessionId: sessionId,
          sessionStatus: status,
          objectName: objectName));
      print("Send get url request to " +
          endpoint +
          "session " +
          sessionId.toString() +
          " for " +
          objectName);
      Response response = await dio.post(endpoint, data: data);
      print(response.data);
      AppResp appResp = AppResp.fromJson(response.data);
      print(appResp);

      if (response.statusCode == HttpStatus.ok) {
        return appResp.preSignedUrl;
      }
    } catch (e) {
      print('Get Url Error:' + e.toString());
      throw ('Error getting url');
    }
    return "";
  }

  Future<void> sendUpdateStatus(String sessionId, SessionStatus status) async {
    try {
      AppReq appReq = AppReq(
          cmd: AppReqCmd.UpdateStatus,
          sessionId: sessionId,
          sessionStatus: status,
          username: currentStaff.username);
      print("Send Update Status: " + endpoint);
      print("data: " + json.encode(appReq));
      Response response = await dio.post(endpoint, data: json.encode(appReq));
      AppResp appResp = AppResp.fromJson(response.data);
      print(appResp);

      if (response.statusCode == HttpStatus.ok) {
        return appResp.preSignedUrl;
      }
    } catch (e) {
      print('Update Status:' + e.toString());
      throw ('Error getting url');
    }
    return "";
  }

  Future<AppResp> checkLoginCredentials(
      String username, String password) async {
    AppResp authResponse;
    try {
      AppReq appReq = AppReq(
          cmd: AppReqCmd.Login,
          sessionStatus: SessionStatus.NONE,
          username: username,
          password: password);
      print("Send Login Request: " + endpoint);
      Response response = await dio.post(endpoint, data: json.encode(appReq));
      print(response.statusCode);
      print(response.data);

      if (response.statusCode == HttpStatus.ok) {
        authResponse = AppResp.fromJson(response.data);
      }
      authResponse.statusCode = response.statusCode;
      return authResponse;
    } catch (e) {
      print(e);
      authResponse = new AppResp();
      authResponse.statusCode = HttpStatus.clientClosedRequest;
      return authResponse;
    }
  }

  Future<AppResp> getUpdatedStatus(
      String sessionId, SessionStatus sessionStatus) async {
    try {
      AppReq appReq = AppReq(
          cmd: AppReqCmd.GetStatus,
          sessionId: sessionId,
          sessionStatus: sessionStatus);
      print("Send Get Status: " + endpoint);
      Response response = await dio.post(endpoint, data: json.encode(appReq));
      AppResp appResp = AppResp.fromJson(response.data);
      print(appResp.message);

      if (response.statusCode == HttpStatus.ok) {
        return appResp;
      }
    } catch (e) {
      print('Get Status:' + e.toString());
      throw ('Error getting url');
    }
    return null;
  }

  Future<AppResp> getSessions(String username, {String sessionId}) async {
    try {
      AppReq appReq = AppReq(
          cmd: AppReqCmd.GetSessions, username: username, sessionId: sessionId);
      Response response = await dio.post(endpoint, data: json.encode(appReq));
      AppResp appResp = AppResp.fromJson(response.data);
      print(appResp.message);
      return appResp;
    } catch (e) {
      print('Error:' + e.toString());
      throw ('Error getting sessions');
    }
  }

  Future<AppResp> registerUserFCM(String username, String fcmToken) async {
    try {
      print("Registering FCM token on server: $fcmToken");
      AppReq appReq = AppReq(
          cmd: AppReqCmd.RegisterFCMToken,
          username: username,
          fcmToken: fcmToken);
      Response response = await dio.post(endpoint, data: json.encode(appReq));
      AppResp appResp = AppResp.fromJson(response.data);
      print(appResp.message);
      return appResp;
    } catch (e) {
      print("Error sending FCM token");
      print(e);
      return null;
    }
  }

  Future<AppResp> updateLocation(
      {String username, String latitude, String longitude}) async {
    try {
      String object =
          "$latitude:$longitude:${DateTime.now().millisecondsSinceEpoch}";
      AppReq appReq = AppReq(
          cmd: AppReqCmd.UpdateLocation,
          username: username,
          objectName: object);
      Response response = await dio.post(endpoint, data: json.encode(appReq));
      if (response.statusCode == HttpStatus.ok) {
        print("location updated successfully");
        AppResp appResp = AppResp.fromJson(response.data);
        print(appResp.message);
        return appResp;
      } else {
        throw ("Response status code is not successful. Code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error updating location");
      print(e);
      return null;
    }
  }
}
