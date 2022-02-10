import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:socket_flutter/src/service/storage_service.dart';

class NotificationService extends GetxService {
  static NotificationService get to => Get.find();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final StorageService storage = StorageService.to;

  @override
  void onInit() async {
    super.onInit();

    await requestPermission();
    listenForeground();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> requestPermission() async {
    await _firebaseMessaging.requestPermission();
  }

  Future<String?> getFCMToken() async {
    return await _firebaseMessaging.getToken();
  }

  void listenForeground() {
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        print("FOREGROUND");
        RemoteNotification? notification = message.notification;

        if (notification != null) {
          print(notification.body);
          // flutterLocalNotificationsPlugin.show(
          //     notification.hashCode,
          //     notification.title,
          //     notification.body,
          //     NotificationDetails(iOS: IOSNotificationDetails()));
        }
      },
    );
  }
}
