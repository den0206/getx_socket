import 'dart:io';

import 'package:socket_flutter/src/model/response_api.dart';

import 'api_base.dart';

class MessageAPI extends APIBase {
  MessageAPI() : super(EndPoint.message);

  Future<ResponseAPI> sendMessage(
      {required Map<String, dynamic> message}) async {
    try {
      final Uri uri = setUri("/");

      return await postRequest(uri: uri, body: message, useToken: true);
    } catch (e) {
      throw e;
    }
  }

  Future<ResponseAPI> sendImageMessage(
      {required Map<String, dynamic> message, required File file}) async {
    try {
      final Uri uri = setUri("/image");
      return await updateSingleFile(
          uri: uri, body: message, file: file, useToken: true);
    } catch (e) {
      throw e;
    }
  }

  Future<ResponseAPI> sendVideoMessage(
      {required Map<String, dynamic> message, required File videoFile}) async {
    try {
      final Uri uri = setUri("/video");
      return await updateSingleFile(
          uri: uri, body: message, file: videoFile, useToken: true);
    } catch (e) {
      throw e;
    }
  }

  Future<ResponseAPI> loadMessage(
      {required String chatRoomId, int? limit, String? nextCursor}) async {
    final Map<String, dynamic> query = {
      "chatRoomId": chatRoomId,
      "limit": limit.toString(),
      "cursor": nextCursor,
    };
    try {
      final Uri uri = setUri("/load", query);

      return await getRequest(uri: uri, useToken: true);
    } catch (e) {
      throw e;
    }
  }

  Future<ResponseAPI> updateMessage(Map<String, dynamic> value) async {
    try {
      final Uri uri = setUri("/update");
      return await putRequest(uri: uri, body: value, useToken: true);
    } catch (e) {
      throw e;
    }
  }

  Future<ResponseAPI> deleteMessage(String messageId) async {
    final q = {"messageId": messageId};
    try {
      final Uri uri = setUri("/delete", q);
      return await deleteRequest(uri: uri, useToken: true);
    } catch (e) {
      throw e;
    }
  }
}
