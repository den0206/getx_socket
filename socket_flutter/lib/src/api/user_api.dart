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
}
