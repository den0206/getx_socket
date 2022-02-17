import 'package:socket_flutter/src/api/api_base.dart';
import 'package:socket_flutter/src/model/response_api.dart';

class ResetPasswordAPI extends APIBase {
  ResetPasswordAPI() : super(EndPoint.resetpassword);

  Future<ResponseAPI> request(String email) async {
    final body = {"email": email};
    try {
      final Uri uri = setUri("$endpoint/request");
      return await postRequest(uri: uri, body: body);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }

  Future<ResponseAPI> verify(Map<String, dynamic> data) async {
    try {
      final Uri uri = setUri("$endpoint/verify");
      return await postRequest(uri: uri, body: data);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }
}
