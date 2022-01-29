import 'package:socket_flutter/src/api/api_base.dart';
import 'package:socket_flutter/src/model/recent.dart';
import 'package:socket_flutter/src/model/response_api.dart';
import 'package:socket_flutter/src/service/auth_service.dart';

class RecentAPI extends APIBase {
  RecentAPI() : super(EndPoint.recent);

  Future<ResponseAPI> createChatRecent(Map<String, dynamic> recent) async {
    try {
      final Uri uri = Uri.http(host, "$endpoint/");
      return await postRequest(uri: uri, body: recent);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }

  Future<ResponseAPI> updateRecent(
      Recent recent, Map<String, dynamic> value) async {
    try {
      final Uri uri = Uri.http(host, "$endpoint/${recent.id}");
      return await putRequest(uri: uri, body: value, useToken: true);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }

  Future<ResponseAPI> findOneByRoomIdAndUserId(
      String userId, String chatRoomId) async {
    try {
      final Uri uri = Uri.http(host, "$endpoint/$userId/$chatRoomId");
      return await getRequest(uri: uri);
    } catch (e) {
      return catchAPIError(e.toString());
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
      return await getRequest(uri: uri);
    } catch (e) {
      return catchAPIError(e.toString());
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
      return await getRequest(uri: uri);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }

  Future<ResponseAPI> deleteRecent({required String recentId}) async {
    try {
      final Uri uri = Uri.http(host, "$endpoint/$recentId");
      return await deleteRequest(uri: uri, useToken: true);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }
}
