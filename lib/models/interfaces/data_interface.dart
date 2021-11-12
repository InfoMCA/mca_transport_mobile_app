import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class DataInterface {
  bool success;
  String message;
  bool isUploaded;
  var dio = new Dio();

  Future<void> uploadText(String url, String data) async {
    isUploaded = false;
    try {
      var response = await dio.put(url, data: data);
      if (response.statusCode == 200) {
        isUploaded = true;
      }
      print("Upload is successful:" + url);
    } catch (e) {
      print("Upload Error:" + e.toString());
      throw ('Error uploading text');
    }
  }

  Future<dynamic> downloadText(String url) async {
    isUploaded = false;
    try {
      var response = await dio.get(url);
      if (response.statusCode == 200) {
        isUploaded = true;
        return response.data;
      }
    } catch (e) {
      print("Download Error:" + e.toString());
      throw ('Error downloading text');
    }
    return "";
  }

  Future<void> uploadMedia(String url, Uint8List data, String type) async {
    try {
      isUploaded = false;
      var response = await http.put(
          Uri.parse(url),
          body: data,
          headers: { "Content-Type": type});

      if (response.statusCode == HttpStatus.ok) {
        isUploaded = true;
        print("Upload media " + url);
      }
    } catch (e) {
      print("Upload Error:" + e.toString());
      throw ('Error uploading photo');
    }
  }

  Future<Uint8List> downloadMedia(String url, String type) async {
    print("Download Media");
    try {
      var response = await http.get(
          Uri.parse(url),
          headers: { "Content-Type": type});

      if (response.statusCode == HttpStatus.ok) {
        isUploaded = true;
        return response.bodyBytes;
      } else {
        print (response.statusCode);
      }
    } catch (e) {
      print("Download Error:" + e.toString());
      throw ('Error Downloading Media');
    }
    return null;
  }
}