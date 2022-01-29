import 'dart:io';

import 'package:mime/mime.dart';
import 'package:socket_flutter/src/model/response_api.dart';
import 'package:socket_flutter/src/service/image_extention.dart';
import 'api_base.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class MessageAPI extends APIBase {
  MessageAPI() : super(EndPoint.message);

  Future<ResponseAPI> sendMessage(
      {required Map<String, dynamic> message}) async {
    try {
      final Uri uri = Uri.http(host, "$endpoint/");

      return await postRequest(uri: uri, body: message);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }

  Future<ResponseAPI> sendImageMessage(
      {required Map<String, String> message, required File file}) async {
    try {
      final Uri uri = Uri.http(host, "$endpoint/image");

      final request = http.MultipartRequest("POST", uri);
      request.headers.addAll(headers);
      request.fields.addAll(message);

      final contentType = lookupMimeType(file.path);
      if (contentType == null) {
        return invalidError;
      }
      final encoded = await http.MultipartFile.fromPath(
        "image",
        file.path,
        contentType: MediaType.parse(contentType),
      );
      print(encoded.contentType);
      request.files.add(encoded);

      final response = await request.send();
      final resStr = await response.stream.bytesToString();
      final data = json.decode(resStr);
      return ResponseAPI.fromMap(data);
    } catch (e) {
      print(e.toString());
      return invalidError;
    }
  }

  Future<ResponseAPI> sendVideoMessage(
      {required Map<String, String> message, required File videoFile}) async {
    final _imageExtention = ImageExtention();

    try {
      final thumbnail = await _imageExtention.getThumbnail(videoFile);
      final Uri uri = Uri.http(host, "$endpoint/video");
      final request = http.MultipartRequest("POST", uri);
      request.headers.addAll(headers);
      request.fields.addAll(message);

      final List<http.MultipartFile> files = [];

      await Future.forEach(
        [videoFile, thumbnail],
        (File file) async {
          final contentType = lookupMimeType(file.path);
          if (contentType == null) throw ("NO content Type");
          final temp = await http.MultipartFile.fromPath(
            "video",
            file.path,
            contentType: MediaType.parse(contentType),
          );
          files.add(temp);
        },
      );
      request.files.addAll(files);

      final response = await request.send();
      final resStr = await response.stream.bytesToString();
      print(resStr);
      final data = json.decode(resStr);
      return ResponseAPI.fromMap(data);
    } catch (e) {
      print(e.toString());
      return invalidError;
    }
  }

  Future<ResponseAPI> loadMessage(
      {required String chatRoomId, int? limit, String? nextCursor}) async {
    final Map<String, dynamic> query = {
      "limit": limit.toString(),
      "cursor": nextCursor,
    };
    try {
      final Uri uri = Uri.http(
        host,
        "$endpoint/$chatRoomId",
        query,
      );

      return await getRequest(uri: uri);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }

  Future<ResponseAPI> updateReadStatus(
      String messageId, Map<String, dynamic> readBody) async {
    try {
      final Uri uri = Uri.http(host, "$endpoint/updateRead/$messageId");
      return await putRequest(uri: uri, body: readBody);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }

  Future<ResponseAPI> deleteMessage(String messageId) async {
    try {
      final Uri uri = Uri.http(host, "$endpoint/$messageId");
      return await deleteRequest(uri: uri, useToken: true);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }
}

String getFileExtension(String fileName) {
  return "." + fileName.split('.').last;
}
