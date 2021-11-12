import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static Future<void> saveObject(
      {@required ObjectType type,
      String objectId = "",
      @required dynamic object}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String objectName =
        objectId.isEmpty ? type.toString() : "${type.toString()}#$objectId";
    prefs.setString(objectName, json.encode(object));
    log("Saved object: $type#$objectId successfully");
  }

  static Future<void> deleteAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    log("Cleared all cached data");
  }

  static Future<String> getObject(ObjectType type,
      {String objectId = ""}) async {
    try {
      log("Retrieving object: $type#$objectId.");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String objectName =
          objectId.isEmpty ? type.toString() : "${type.toString()}#$objectId";
      return prefs.getString(objectName);
    } catch (e) {
      return null;
    }
  }

  static Future<String> _getLocalStoragePath() async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    return appDocumentsDirectory.path;
  }

  static Future<String> saveFile(
      String fileName, FileType fileType, Uint8List fileBytes) async {
    String fileLocation =
        await _getLocalStoragePath() + "/$fileName.${fileType.getExtension()}";
    File file = File(fileLocation);
    await file.writeAsBytes(fileBytes);
    return fileLocation;
  }
}

enum ObjectType { driver, globalSessions, sessionObject }

enum FileType { png, jpg, pdf }

extension FileExtension on FileType {
  String getExtension() {
    switch (this) {
      case FileType.png:
        return "png";
      case FileType.jpg:
        return "jpg";
      case FileType.pdf:
        return "pdf";
      default:
        return "unknown";
    }
  }
}
