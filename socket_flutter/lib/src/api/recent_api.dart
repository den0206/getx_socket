import 'package:socket_flutter/src/api/api_base.dart';
import 'package:socket_flutter/src/model/response_api.dart';
import 'package:socket_flutter/src/service/auth_service.dart';

class RecentAPI extends APIBase {
  RecentAPI() : super(EndPoint.recent);

  Future<ResponseAPI> createPrivateChat(Map<String, dynamic> recent) async {
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

  Future<ResponseAPI> getByRoomID(String chatRoomId) async {
    try {
      final Uri uri = Uri.http(host, "$endpoint/roomid/$chatRoomId");
      final res = await client.get(uri, headers: headers);
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
      final decode = json.decode((res.body));

      return ResponseAPI.fromMap(decode);
    } catch (e) {
      print(e.toString());
      return invalidError;
    }
  }

  Future<ResponseAPI> deleteRecent({required String recentId}) async {
    if (token == null) {
      return ResponseAPI(status: false, message: "No Token", data: null);
    }

    headers["Authorization"] = token!;

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
