import 'package:socket_flutter/src/api/api_base.dart';
import 'package:socket_flutter/src/model/recent.dart';
import 'package:socket_flutter/src/model/response_api.dart';
import 'package:socket_flutter/src/service/auth_service.dart';

class RecentAPI extends APIBase {
  RecentAPI() : super(EndPoint.recent);

  Future<ResponseAPI> createChatRecent(Map<String, dynamic> recent) async {
    try {
      final Uri uri = Uri.http(host, "$endpoint/");
      final String bodyParams = json.encode(recent);

      final res = await client.post(uri, headers: headers, body: bodyParams);
      final data = json.decode(res.body);

      return ResponseAPI.fromMap(data);
    } catch (e) {
      print(e.toString());
      return invalidError;
    }
  }

  Future<ResponseAPI> updateRecent(
      Recent recent, Map<String, dynamic> value) async {
    if (!checkToken())
      return ResponseAPI(status: false, data: null, message: "No Token");

    final recentId = recent.id;
    try {
      final Uri uri = Uri.http(host, "$endpoint/$recentId");

      final String bodyParams = json.encode(value);

      final res = await client.put(uri, body: bodyParams, headers: headers);
      final data = json.decode(res.body);

      return ResponseAPI.fromMap(data);
    } catch (e) {
      print(e.toString());
      return invalidError;
    }
  }

  Future<ResponseAPI> findOneByRoomIdAndUserId(
      String userId, String chatRoomId) async {
    try {
      final Uri uri = Uri.http(host, "$endpoint/$userId/$chatRoomId");
      final res = await client.get(uri, headers: headers);
      final data = json.decode(res.body);

      return ResponseAPI.fromMap(data);
    } catch (e) {
      print(e.toString());
      return invalidError;
    }
  }

  Future<ResponseAPI> getByRoomID(String chatRoomId,
      {bool includeUserParams = true}) async {
    /// 使う 0 (規定値)
    /// 使わない 1
    final Map<String, dynamic> query = {
      "userParams": includeUserParams ? "0" : "1",
    };
    try {
      final Uri uri = Uri.http(host, "$endpoint/roomid/$chatRoomId", query);
      final res = await client.get(
        uri,
        headers: headers,
      );
      final data = json.decode(res.body);

      return ResponseAPI.fromMap(data);
    } catch (e) {
      print(e.toString());
      return invalidError;
    }
  }

  Future<ResponseAPI> getRecents({int? limit, String? nextCursor}) async {
    final Map<String, dynamic> query = {
      "limit": limit.toString(),
      "cursor": nextCursor,
    };

    try {
      final currentUser = AuthService.to.currentUser.value!;
      final Uri uri = Uri.http(
        host,
        "$endpoint/userid/${currentUser.id}",
        query,
      );

      final res = await client.get(uri, headers: headers);
      final decode = json.decode(res.body);

      return ResponseAPI.fromMap(decode);
    } catch (e) {
      print(e.toString());
      return invalidError;
    }
  }

  Future<ResponseAPI> deleteRecent({required String recentId}) async {
    if (!checkToken())
      return ResponseAPI(status: false, data: null, message: "No Token");

    /// 401 token invalid
    /// 403 no token

    try {
      final Uri uri = Uri.http(host, "$endpoint/$recentId");
      final res = await client.delete(uri, headers: headers);
      print(res.statusCode);
      final data = json.decode(res.body);

      return ResponseAPI.fromMap(data);
    } catch (e) {
      print(e.toString());
      return invalidError;
    }
  }
}
