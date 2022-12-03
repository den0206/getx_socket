import 'dart:io';

import 'package:socket_flutter/src/api/api_base.dart';
import 'package:socket_flutter/src/model/response_api.dart';
import 'package:socket_flutter/src/service/auth_service.dart';

class UserAPI extends APIBase {
  UserAPI() : super(EndPoint.user);

  Future<ResponseAPI> signUp(
      {required Map<String, dynamic> userData, File? avatarFile}) async {
    try {
      final Uri uri = setUri("/signup");

      if (avatarFile == null) {
        return await postRequest(uri: uri, body: userData);
      } else {
        return await updateSingleFile(
          uri: uri,
          body: userData,
          file: avatarFile,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<ResponseAPI> login(Map<String, dynamic> credential) async {
    try {
      final Uri uri = setUri("/login");
      return await postRequest(uri: uri, body: credential);
    } catch (e) {
      rethrow;
    }
  }

  Future<ResponseAPI> getUsers({int? limit, String? nextCursor}) async {
    final Map<String, dynamic> query = {
      "limit": limit.toString(),
      "cursor": nextCursor,
    };

    final excludeIds = AuthService.to.currentUser.value!.excludeIds;
    final Map<String, dynamic> blocks = {"blockUsers": excludeIds};

    try {
      final Uri uri = setUri("/", query);
      return await postRequest(uri: uri, body: blocks, useToken: true);
    } catch (e) {
      rethrow;
    }
  }

  Future<ResponseAPI> editUser(
      {required Map<String, dynamic> userData, File? avatarFile}) async {
    try {
      final Uri uri = setUri("/edit");

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
      rethrow;
    }
  }

  Future<ResponseAPI> updateBlock({
    required Map<String, dynamic> userData,
  }) async {
    try {
      final Uri uri = setUri("/updateBlock");
      return await putRequest(uri: uri, body: userData, useToken: true);
    } catch (e) {
      rethrow;
    }
  }

  Future<ResponseAPI> fetchBlocks() async {
    try {
      final Uri uri = setUri("/blocks");
      return await getRequest(uri: uri, useToken: true);
    } catch (e) {
      rethrow;
    }
  }

  Future<ResponseAPI> getById({required String id}) async {
    final Map<String, dynamic> query = {"id": id};
    try {
      final Uri uri = setUri("/search", query);
      return await getRequest(uri: uri, useToken: true);
    } catch (e) {
      rethrow;
    }
  }

  Future<ResponseAPI> deleteUser() async {
    try {
      final Uri uri = setUri("/delete");
      return await deleteRequest(uri: uri, useToken: true);
    } catch (e) {
      rethrow;
    }
  }
}
