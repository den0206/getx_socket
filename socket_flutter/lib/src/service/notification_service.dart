import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:socket_flutter/src/api/notification_api.dart';
import 'package:socket_flutter/src/screen/widget/common_dialog.dart';

// 登録時の共通化
Future<void> registerNotification() async {
  if (!Get.isRegistered<NotificationService>()) {
    await Get.put(NotificationService()).initService();
  }
}

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

  Future<void> requestPermission() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
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
          AndroidFlutterLocalNotificationsPlugin
        >()
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
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("FOREGROUND Notifications");
      showNotification(message);
    });
  }

  void showNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    print("Call");

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
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: const DarwinNotificationDetails(
            // badgeNumber: 10,
          ),
        ),
      );
    }
  }

  /// MARK Send

  Future<void> pushNotification({
    required List<String> tokens,
    required String lastMessage,
    String title = "New Message",
  }) async {
    print("Tokens $tokens");
    final Map<String, dynamic> data = {
      "registration_ids": tokens,
      "notification": {
        "title": title,
        "body": lastMessage,
        "content_available": true,
        "priority": "high",
        // "badge": 10,
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
      },
      "data": {
        "priority": "high",
        "sound": "app_sound.wav",
        "content_available": true,
        "bodyText": lastMessage,
      },
    };

    _notificationApi.messageNotification(data);
  }

  // Badges

  Future<int> getBadges() async {
    if (!canBadge) return 0;
    final res = await _notificationApi.getBadgesCount();
    if (!res.status) {
      print("バッジの獲得不可");
      return 0;
    }

    int badgeCount = res.data;
    return badgeCount;
  }

  Future<void> updateBadges() async {
    print('Background');

    try {
      int badgeCount = await getBadges();
      if (badgeCount > 0) {
        if (badgeCount > 99) {
          badgeCount = 99;
        }
        FlutterAppBadger.updateBadgeCount(badgeCount);
      } else {
        FlutterAppBadger.removeBadge();
      }
    } catch (e) {
      showError(e.toString());
    }
  }

  void resetBadge() {
    if (!canBadge) return;
    FlutterAppBadger.removeBadge();
  }
}
