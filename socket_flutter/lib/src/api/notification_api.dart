import 'package:socket_flutter/src/api/api_base.dart';
import 'package:socket_flutter/src/model/custom_exception.dart';
import 'package:socket_flutter/src/model/response_api.dart';

class NotificationAPI extends APIBase {
  NotificationAPI() : super(EndPoint.notification);

  Future<ResponseAPI> messageNotification(
    Map<String, dynamic> notificationData,
  ) async {
    try {
      final Uri uri = setUri("/");
      return await postRequest(uri: uri, body: notificationData);
    } on BadRequestException catch (_) {
      // Push 通知失敗時
      return ResponseAPI(status: false, data: null);
    } catch (e) {
      rethrow;
    }
  }

  Future<ResponseAPI> getBadgesCount() async {
    try {
      final Uri uri = setUri("/getBadgeCount");
      return await getRequest(uri: uri, useToken: true);
    } catch (e) {
      rethrow;
    }
  }
}
