import 'dart:convert';

import 'package:socket_flutter/src/service/auth_service.dart';
import 'package:socket_flutter/src/utils/enviremont.dart';
import 'package:http/http.dart' as http;

abstract class APIBase {
  final String host = Enviroment.host;
  final http.Client client = http.Client();
  final JsonCodec json = JsonCodec();
  final Map<String, String> headers = {"Content-type": "application/json"};

  final EndPoint endPointType;

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

  APIBase(this.endPointType);
}

enum EndPoint { user, recent, message }

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
    }
  }
}
