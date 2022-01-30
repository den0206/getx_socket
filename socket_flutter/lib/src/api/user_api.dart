import 'dart:io';

import 'package:socket_flutter/src/api/api_base.dart';
import 'package:socket_flutter/src/model/response_api.dart';

class UserAPI extends APIBase {
  UserAPI() : super(EndPoint.user);

  Future<ResponseAPI> signUp(Map<String, dynamic> user) async {
    try {
      final Uri uri = Uri.http(host, "$endpoint/signup");
      return await postRequest(uri: uri, body: user);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }

  Future<ResponseAPI> login(Map<String, dynamic> credential) async {
    try {
      final Uri uri = Uri.http(host, "$endpoint/login");
      return await postRequest(uri: uri, body: credential);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }

  Future<ResponseAPI> getUsers({int? limit, String? nextCursor}) async {
    final Map<String, dynamic> query = {
      "limit": limit.toString(),
      "cursor": nextCursor,
    };

    try {
      final Uri uri = Uri.http(
        host,
        "$endpoint/",
        query,
      );
      return await getRequest(uri: uri);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }

  Future<ResponseAPI> editUser(
      {required Map<String, dynamic> userData, File? avatarFile}) async {
    try {
      final Uri uri = Uri.http(
        host,
        "$endpoint/edit",
      );

      if (avatarFile == null) {
        return await putRequest(uri: uri, body: userData, useToken: true);
      } else {
        return await updateSingleFile(
            uri: uri,
            body: userData,
            file: avatarFile,
            type: "PUT",
            useToken: true);
      }
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }
}
