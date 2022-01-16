import 'package:socket_flutter/src/api/api_base.dart';
import 'package:socket_flutter/src/model/response_api.dart';
import 'package:socket_flutter/src/service/auth_service.dart';

class GropuAPI extends APIBase {
  GropuAPI() : super(EndPoint.group);

  Future<ResponseAPI> createGroup(Map<String, dynamic> group) async {
    try {
      final Uri uri = Uri.http(host, "$endpoint/");
      final String bodyParams = json.encode(group);

      final res = await client.post(uri, headers: headers, body: bodyParams);
      final data = json.decode(res.body);

      return ResponseAPI.fromMap(data);
    } catch (e) {
      print(e.toString());
      return invalidError;
    }
  }

  Future<ResponseAPI> findByUserId(String userId) async {
    if (!checkToken())
      return ResponseAPI(status: false, data: null, message: "No Token");

    try {
      final Uri uri = Uri.http(host, "$endpoint/$userId");

      final res = await client.get(uri, headers: headers);
      final data = json.decode(res.body);

      return ResponseAPI.fromMap(data);
    } catch (e) {
      print(e.toString());
      return invalidError;
    }
  }

  Future<ResponseAPI> deleteById(String groupId) async {
    if (!checkToken())
      return ResponseAPI(status: false, data: null, message: "No Token");

    try {
      final currentUser = AuthService.to.currentUser.value!;
      final Uri uri = Uri.http(host, "$endpoint/$groupId/${currentUser.id}");

      final res = await client.delete(uri, headers: headers);
      final data = json.decode(res.body);

      return ResponseAPI.fromMap(data);
    } catch (e) {
      print(e.toString());
      return invalidError;
    }
  }
}
