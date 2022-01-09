import 'package:socket_flutter/src/api/api_base.dart';
import 'package:socket_flutter/src/model/response_api.dart';

class UserAPI extends APIBase {
  UserAPI() : super(EndPoint.user);

  Future<ResponseAPI> signUp(Map<String, dynamic> user) async {
    try {
      final Uri uri = Uri.http(host, "$endpoint/signup");
      final String bodyParams = json.encode(user);

      final res = await client.post(uri, headers: headers, body: bodyParams);
      final data = json.decode(res.body);

      return ResponseAPI.fromMap(data);
    } catch (e) {
      print(e.toString());
      return invalidError;
    }
  }

  Future<ResponseAPI> login(Map<String, dynamic> credential) async {
    try {
      final Uri uri = Uri.http(host, "$endpoint/login");
      final String bodyParams = json.encode(credential);

      final res = await client.post(uri, headers: headers, body: bodyParams);
      final data = json.decode(res.body);

      final ResponseAPI responseAPI = ResponseAPI.fromMap(data);
      return responseAPI;
    } catch (e) {
      return invalidError;
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

      final res = await client.get(uri, headers: headers);
      final decode = json.decode(res.body);

      final ResponseAPI responseAPI = ResponseAPI.fromMap(decode);
      return responseAPI;
    } catch (e) {
      print(e);
      return invalidError;
    }
  }
}
