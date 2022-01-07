import 'dart:convert';

import 'package:socket_flutter/src/model/response_api.dart';
import 'package:socket_flutter/src/service/auth_service.dart';
import 'package:socket_flutter/src/utils/enviremont.dart';
import 'package:http/http.dart' as http;

class RecentAPI {
  final String _host = Enviroment.host;
  final String _endpoint = "/api/v1/recents";
  final Map<String, String> headers = {"Content-type": "application/json"};

  String? get token {
    final user = AuthService.to.currentUser.value;
    if (user == null || user.sessionToken == null) {
      return null;
    }

    return "JWT ${user.sessionToken}";
  }

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

  Future<ResponseAPI> getRecents({int? limit, String? nextCursor}) async {
    final Map<String, dynamic> query = {
      "limit": limit.toString(),
      "cursor": nextCursor,
    };

    try {
      final currentUser = AuthService.to.currentUser.value!;
      final Uri uri = Uri.http(
        _host,
        "$_endpoint/userid/${currentUser.id}",
        query,
      );

      final res = await http.get(uri, headers: headers);
      final decode = json.decode((res.body));

      return ResponseAPI.fromMap(decode);
    } catch (e) {
      print(e.toString());
      return invalidError;
    }
  }

  Future<ResponseAPI> deleteRecent({required String recentId}) async {
    if (token == null) {
      return ResponseAPI(status: false, message: "No Token", data: null);
    }

    headers["Authorization"] = token!;

    /// 401 token invalid
    /// 403 no token

    try {
      final Uri uri = Uri.http(_host, "$_endpoint/$recentId");
      final res = await http.delete(uri, headers: headers);
      print(res.statusCode);
      final data = json.decode(res.body);

      return ResponseAPI.fromMap(data);
    } catch (e) {
      print(e.toString());
      return invalidError;
    }
  }
}
