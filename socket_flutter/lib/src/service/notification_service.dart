import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:socket_flutter/src/api/notification_api.dart';

class NotificationService extends GetxService {
  static NotificationService get to => Get.find();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  late AndroidNotificationChannel channel;
  final _notificationApi = NotificationAPI();
  late bool canBadge;

  @override
  void onInit() async {
    super.onInit();

    await requestPermission();
    listenForeground();
    canBadge = await FlutterAppBadger.isAppBadgeSupported();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> requestPermission() async {
    await _firebaseMessaging.requestPermission();
  }

  Future<void> initService() async {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<String?> getFCMToken() async {
    return await _firebaseMessaging.getToken();
  }

  void listenForeground() {
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        print("FOREGROUND");
        showNotification(message);
      },
    );
  }

  void showNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;

    if (notification != null) {
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: 'launch_background',
              ),
              iOS: IOSNotificationDetails()));
    }
  }

  /// MARK Send

  Future<void> pushNotification() async {
    final Map<String, dynamic> data = {
      "registration_ids": [
        "e5NsnugORtW73Y7AkAXQQC:APA91bE81q7uDTqT3P9lxVnQE3i1RCqgbmz5jyfryM0-64TdU7ltyAogyJ0UJxYagXHjkkxTcmi7ZWq8p93NAzXMrFelc0Qm3e7UQGdWLCimxBofGhtvoJIv5jf8oRoPuk0fgTiMxR1m"
      ],
      "notification": {
        "body": "New announcement assigned",
        "content_available": true,
        "priority": "high",
        "Title": "hello",
        "badge": 10,
      },
    };

    final response = await _notificationApi.messageNotification(data);
    print(response);
  }

  // Badges

  Future<void> updateBadges() async {
    print('Background');
    if (!canBadge) return;
    final res = await _notificationApi.getBadgesCount();
    if (!res.status) {
      print("バッジの獲得不可");
      return;
    }

    final int badgeCount = res.data;

    FlutterAppBadger.updateBadgeCount(badgeCount);
  }

  void resetBadge() {
    print('Foreground');
    if (!canBadge) return;
    FlutterAppBadger.removeBadge();
  }
}
