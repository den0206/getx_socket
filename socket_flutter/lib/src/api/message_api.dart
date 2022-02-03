import 'dart:io';

import 'package:socket_flutter/src/model/response_api.dart';
import 'api_base.dart';

class MessageAPI extends APIBase {
  MessageAPI() : super(EndPoint.message);

  Future<ResponseAPI> sendMessage(
      {required Map<String, dynamic> message}) async {
    try {
      final Uri uri = setUri("$endpoint/");

      return await postRequest(uri: uri, body: message);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }

  Future<ResponseAPI> sendImageMessage(
      {required Map<String, dynamic> message, required File file}) async {
    try {
      final Uri uri = setUri("$endpoint/image");
      return await updateSingleFile(uri: uri, body: message, file: file);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }

  Future<ResponseAPI> sendVideoMessage(
      {required Map<String, dynamic> message, required File videoFile}) async {
    try {
      final Uri uri = setUri("$endpoint/video");
      return await updateSingleFile(uri: uri, body: message, file: videoFile);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }

  Future<ResponseAPI> loadMessage(
      {required String chatRoomId, int? limit, String? nextCursor}) async {
    final Map<String, dynamic> query = {
      "limit": limit.toString(),
      "cursor": nextCursor,
    };
    try {
      final Uri uri = setUri("$endpoint/$chatRoomId", query);

      return await getRequest(uri: uri);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }

  Future<ResponseAPI> updateReadStatus(
      String messageId, Map<String, dynamic> readBody) async {
    try {
      final Uri uri = setUri("$endpoint/updateRead/$messageId");
      return await putRequest(uri: uri, body: readBody);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }

  Future<ResponseAPI> deleteMessage(String messageId) async {
    try {
      final Uri uri = setUri("$endpoint/$messageId");
      return await deleteRequest(uri: uri, useToken: true);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }
}
