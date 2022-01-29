import 'dart:convert';
import 'dart:io';

import 'package:socket_flutter/src/model/custom_exception.dart';
import 'package:socket_flutter/src/model/response_api.dart';
import 'package:socket_flutter/src/service/auth_service.dart';
import 'package:socket_flutter/src/utils/enviremont.dart';
import 'package:http/http.dart' as http;

abstract class APIBase {
  final String host = Enviroment.host;
  final http.Client client = http.Client();
  final JsonCodec json = JsonCodec();
  final Map<String, String> headers = {"Content-type": "application/json"};

  final EndPoint endPointType;
  APIBase(this.endPointType);

  String get endpoint {
    return endPointType.name;
  }

  String? get token {
    final user = AuthService.to.currentUser.value;
    if (user == null || user.sessionToken == null) {
      return null;
    }

    return "JWT ${user.sessionToken}";
  }

  // GET
  Future<ResponseAPI> getRequest({required Uri uri, useToken = false}) async {
    try {
      if (useToken) {
        if (token == null) {
          throw UnauthorisedException("No Token");
        } else {
          headers["Authorization"] = token!;
        }
      }
      final res = await http.get(uri, headers: headers);
      return _filterResponse(res);
    } on SocketException {
      throw Exception("No Internet");
    }
  }

  // POST
  Future<ResponseAPI> postRequest(
      {required Uri uri,
      required Map<String, dynamic> body,
      useToken = false}) async {
    try {
      if (useToken) {
        if (token == null) {
          throw UnauthorisedException("No Token");
        } else {
          headers["Authorization"] = token!;
        }
      }

      final String bodyParams = json.encode(body);
      final res = await http.post(uri, headers: headers, body: bodyParams);
      return _filterResponse(res);
    } on SocketException {
      throw Exception("No Internet");
    }
  }

  // PUT
  Future<ResponseAPI> putRequest(
      {required Uri uri,
      required Map<String, dynamic> body,
      useToken = false}) async {
    try {
      if (useToken) {
        if (token == null) {
          throw UnauthorisedException("No Token");
        } else {
          headers["Authorization"] = token!;
        }
      }

      final String bodyParams = json.encode(body);
      final res = await http.put(uri, headers: headers, body: bodyParams);
      return _filterResponse(res);
    } on SocketException {
      throw Exception("No Internet");
    }
  }

  // DELETE
  Future<ResponseAPI> deleteRequest(
      {required Uri uri, useToken = false}) async {
    try {
      if (useToken) {
        if (token == null) {
          throw UnauthorisedException("No Token");
        } else {
          headers["Authorization"] = token!;
        }
      }

      final res = await http.delete(uri, headers: headers);
      return _filterResponse(res);
    } on SocketException {
      throw Exception("No Internet");
    }
  }

  ResponseAPI _filterResponse(http.Response response) {
    final resJson = json.decode(response.body);
    final responseAPI = ResponseAPI.fromMap(resJson);

    switch (response.statusCode) {
      case 200:
        return responseAPI;
      case 400:
        throw FetchDataException(responseAPI.message);
      case 401:
      case 403:
        throw UnauthorisedException(responseAPI.message);
      case 500:
      default:
        throw BadRequestException(responseAPI.message);
    }
  }
}

enum EndPoint { user, recent, message, group }

extension EndPointEXT on EndPoint {
  String get name {
    final String APIVer = "/api/v1";

    switch (this) {
      case EndPoint.user:
        return "$APIVer/users";
      case EndPoint.recent:
        return "$APIVer/recents";
      case EndPoint.message:
        return "$APIVer/messages";
      case EndPoint.group:
        return "$APIVer/groups";
    }
  }
}
