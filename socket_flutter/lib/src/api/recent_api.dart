import 'package:socket_flutter/src/api/api_base.dart';
import 'package:socket_flutter/src/model/recent.dart';
import 'package:socket_flutter/src/model/response_api.dart';

class RecentAPI extends APIBase {
  RecentAPI() : super(EndPoint.recent);

  Future<ResponseAPI> createChatRecent(Map<String, dynamic> recent) async {
    try {
      final Uri uri = setUri("/");
      return await postRequest(uri: uri, body: recent);
    } catch (e) {
      throw e;
    }
  }

  Future<ResponseAPI> updateRecent(
      Recent recent, Map<String, dynamic> value) async {
    final Map<String, dynamic> q = {"id": recent.id};
    try {
      final Uri uri = setUri("/update", q);
      return await putRequest(uri: uri, body: value, useToken: true);
    } catch (e) {
      throw e;
    }
  }

  Future<ResponseAPI> findOneByRoomIdAndUserId(String chatRoomId) async {
    final Map<String, dynamic> q = {"chatRoomId": chatRoomId};
    try {
      final Uri uri = setUri("/one", q);
      return await getRequest(uri: uri, useToken: true);
    } catch (e) {
      throw e;
    }
  }

  Future<ResponseAPI> getByRoomID(String chatRoomId,
      {bool includeUserParams = true}) async {
    /// 使う 0 (規定値)
    /// 使わない 1
    final Map<String, dynamic> query = {
      "userParams": includeUserParams ? "0" : "1",
      "chatRoomId": chatRoomId
    };
    try {
      final Uri uri = setUri("/roomid", query);
      return await getRequest(uri: uri, useToken: true);
    } catch (e) {
      throw e;
    }
  }

  Future<ResponseAPI> getRecents({int? limit, String? nextCursor}) async {
    final Map<String, dynamic> query = {
      "limit": limit.toString(),
      "cursor": nextCursor,
    };

    try {
      final Uri uri = setUri("/userid", query);
      return await getRequest(uri: uri, useToken: true);
    } catch (e) {
      throw e;
    }
  }

  Future<ResponseAPI> deleteRecent({required String recentId}) async {
    try {
      final Uri uri = setUri("/$recentId");
      return await deleteRequest(uri: uri, useToken: true);
    } catch (e) {
      throw e;
    }
  }
}
