import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TransportInterface {
  var dio = new Dio();
  String baseUrl = env['API_TRANSPORT_APP_REQUEST'];

  Future<void> sendTransferRequest(Map data) async {
    var response =
        await dio.put(baseUrl + "/new-order", data: json.encode(data));
    if (response.statusCode != 200) {
      throw ("Error status code not successful: ${response.statusCode}");
    }
    print("Success sending transfer");
    return response;
  }
}
