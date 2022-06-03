import 'package:socket_flutter/src/api/api_base.dart';
import 'package:socket_flutter/src/model/response_api.dart';

class NotificationAPI extends APIBase {
  NotificationAPI() : super(EndPoint.notification);

  Future<ResponseAPI> messageNotification(
      Map<String, dynamic> notificationData) async {
    try {
      final Uri uri = setUri("/");
      return await postRequest(uri: uri, body: notificationData);
    } catch (e) {
      throw e;
    }
  }

  Future<ResponseAPI> getBadgesCount() async {
    try {
      final Uri uri = setUri("/getBadgeCount");
      return await getRequest(uri: uri, useToken: true);
    } catch (e) {
      throw e;
    }
  }
}
