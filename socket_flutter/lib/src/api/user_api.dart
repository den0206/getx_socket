import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:socket_flutter/src/model/response_api.dart';
import 'package:socket_flutter/src/utils/enviremont.dart';

class UserAPI {
  final String _host = Enviroment.host;
  final String _endpoint = "/api/v1/users";

  Future<ResponseAPI> signUp(Map<String, dynamic> user) async {
    try {
      final Uri uri = Uri.http(_host, "$_endpoint/signup");
      final String bodyParams = json.encode(user);
      final Map<String, String> headers = {"Content-type": "application/json"};

      final res = await http.post(uri, headers: headers, body: bodyParams);
      final data = json.decode(res.body);

      return ResponseAPI.fromMap(data);
    } catch (e) {
      print(e.toString());
      return invalidError;
    }
  }

  Future<ResponseAPI> login(Map<String, dynamic> credential) async {
    try {
      final Uri uri = Uri.http(_host, "$_endpoint/login");
      final String bodyParams = json.encode(credential);
      final Map<String, String> headers = {"Content-type": "application/json"};

      final res = await http.post(uri, headers: headers, body: bodyParams);
      final data = json.decode(res.body);

      final ResponseAPI responseAPI = ResponseAPI.fromMap(data);
      return responseAPI;
    } catch (e) {
      return invalidError;
    }
  }
}
