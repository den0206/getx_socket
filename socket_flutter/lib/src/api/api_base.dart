import 'dart:convert';
import 'dart:io';

import 'package:mime/mime.dart';
import 'package:socket_flutter/src/model/custom_exception.dart';
import 'package:socket_flutter/src/model/response_api.dart';
import 'package:socket_flutter/src/service/auth_service.dart';
import 'package:socket_flutter/src/service/image_extention.dart';
import 'package:socket_flutter/src/utils/enviremont.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

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

  void _setToken(bool useToken) {
    if (useToken) {
      if (token == null) {
        throw UnauthorisedException("No Token");
      } else {
        headers["Authorization"] = token!;
      }
    }
  }

  // CRUD
  ResponseAPI _filterResponse(http.Response response) {
    final resJson = json.decode(response.body);
    final responseAPI = ResponseAPI.fromMap(resJson);

    return _checkStatusCode(response.statusCode, responseAPI);
  }

  // MultipartRequest
  Future<ResponseAPI> _filterStream(http.StreamedResponse response) async {
    final resStr = await response.stream.bytesToString();
    final resJson = json.decode(resStr);
    final responseAPI = ResponseAPI.fromMap(resJson);

    return _checkStatusCode(response.statusCode, responseAPI);
  }

  ResponseAPI _checkStatusCode(int statusCode, ResponseAPI responseAPI) {
    switch (statusCode) {
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

/// MARK CRUD 処理の纏め
extension APIBaseExtention on APIBase {
  // GET
  Future<ResponseAPI> getRequest({required Uri uri, useToken = false}) async {
    try {
      _setToken(useToken);

      final res = await http.get(uri, headers: headers);
      return _filterResponse(res);
    } on UnauthorisedException catch (unauth) {
      await AuthService.to.logout();
      throw unauth;
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
      _setToken(useToken);

      final String bodyParams = json.encode(body);
      final res = await http.post(uri, headers: headers, body: bodyParams);
      return _filterResponse(res);
    } on UnauthorisedException catch (unauth) {
      await AuthService.to.logout();
      throw unauth;
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
      _setToken(useToken);

      final String bodyParams = json.encode(body);
      final res = await http.put(uri, headers: headers, body: bodyParams);
      return _filterResponse(res);
    } on UnauthorisedException catch (unauth) {
      await AuthService.to.logout();
      throw unauth;
    } on SocketException {
      throw Exception("No Internet");
    }
  }

  // DELETE
  Future<ResponseAPI> deleteRequest(
      {required Uri uri, useToken = false}) async {
    try {
      _setToken(useToken);

      final res = await http.delete(uri, headers: headers);
      return _filterResponse(res);
    } on UnauthorisedException catch (unauth) {
      await AuthService.to.logout();
      throw unauth;
    } on SocketException {
      throw Exception("No Internet");
    }
  }

  // MultipartRequest
  Future<ResponseAPI> updateSingleFile({
    required Uri uri,
    required Map<String, String> body,
    required File file,
  }) async {
    try {
      final contentType = lookupMimeType(file.path);
      if (contentType == null) throw Exception("NO Content Type");
      final List<File> inputs = [];

      var fileType = contentType.split('/');
      switch (fileType[0]) {
        case "image":
          inputs.add(file);
          break;
        case "video":
          final _imageExtention = ImageExtention();
          final thumbnail = await _imageExtention.getThumbnail(file);
          inputs.addAll([file, thumbnail]);
          break;

        default:
          throw Exception("NO Fit Type");
      }
      final List<http.MultipartFile> multipartFiles = [];

      await Future.forEach(
        inputs,
        (File temp) async {
          final tempContent = lookupMimeType(temp.path);
          if (tempContent == null) throw Exception("NO Temp Content Type");
          final multipart = await http.MultipartFile.fromPath(
            fileType[0],
            temp.path,
            contentType: MediaType.parse(tempContent),
          );
          multipartFiles.add(multipart);
        },
      );

      final request = http.MultipartRequest("POST", uri);
      request.headers.addAll(headers);
      request.fields.addAll(body);
      request.files.addAll(multipartFiles);

      final res = await request.send();
      return _filterStream(res);
    } on UnauthorisedException catch (unauth) {
      await AuthService.to.logout();
      throw unauth;
    } on SocketException {
      throw Exception("No Internet");
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
