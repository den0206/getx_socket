import 'package:socket_flutter/src/api/api_base.dart';
import 'package:socket_flutter/src/model/response_api.dart';

class TempTokenAPI extends APIBase {
  TempTokenAPI() : super(EndPoint.temptoken);

  Future<ResponseAPI> requestNewEmail(String email) async {
    final body = {"email": email};
    try {
      final Uri uri = setUri("$endpoint/requestNewEmail");
      return await postRequest(uri: uri, body: body);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }

  Future<ResponseAPI> verifyEmail(Map<String, dynamic> data) async {
    try {
      final Uri uri = setUri("$endpoint/verifyEmail");
      return await postRequest(uri: uri, body: data);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }

  Future<ResponseAPI> requestPassword(String email) async {
    final body = {"email": email};
    try {
      final Uri uri = setUri("$endpoint/requestPassword");
      return await postRequest(uri: uri, body: body);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }

  Future<ResponseAPI> verifyPassword(Map<String, dynamic> data) async {
    try {
      final Uri uri = setUri("$endpoint/verifyPassword");
      return await postRequest(uri: uri, body: data);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }
}