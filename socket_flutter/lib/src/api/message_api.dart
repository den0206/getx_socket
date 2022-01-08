import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:socket_flutter/src/model/response_api.dart';

import 'package:socket_flutter/src/utils/enviremont.dart';

class MessageAPI {
  final String _host = Enviroment.host;
  final String _endpoint = "/api/v1/messages";
  final Map<String, String> headers = {"Content-type": "application/json"};

  Future<ResponseAPI> sendMessage(
      {required Map<String, dynamic> message}) async {
    try {
      final Uri uri = Uri.http(_host, "$_endpoint/");
      final String bodyParams = json.encode(message);

      final res = await http.post(uri, headers: headers, body: bodyParams);
      final data = json.decode(res.body);

      return ResponseAPI.fromMap(data);
    } catch (e) {
      print(e.toString());
      return invalidError;
    }
  }
}
