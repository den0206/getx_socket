import 'dart:convert';

import 'package:socket_flutter/src/model/response_api.dart';
import 'package:socket_flutter/src/utils/enviremont.dart';
import 'package:http/http.dart' as http;

class RecentAPI {
  final String _host = Enviroment.host;
  final String _endpoint = "/api/v1/recents";
  final Map<String, String> headers = {"Content-type": "application/json"};

  Future<ResponseAPI> createPrivateChat(Map<String, dynamic> recent) async {
    try {
      final Uri uri = Uri.http(_host, "$_endpoint/");
      final String bodyParams = json.encode(recent);

      final res = await http.post(uri, headers: headers, body: bodyParams);
      final data = json.decode(res.body);

      return ResponseAPI.fromMap(data);
    } catch (e) {
      print(e.toString());
      return invalidError;
    }
  }

  Future<ResponseAPI> getByRoomID(String chatRoomId) async {
    try {
      final Uri uri = Uri.http(_host, "$_endpoint/roomid/$chatRoomId");
      final res = await http.get(uri, headers: headers);
      final data = json.decode(res.body);

      return ResponseAPI.fromMap(data);
    } catch (e) {
      print(e.toString());
      return invalidError;
    }
  }
}
