import 'dart:io';

import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:sizer/sizer.dart';
import 'package:socket_flutter/src/app_root.dart';
import 'package:socket_flutter/src/service/notification_service.dart';
import 'package:socket_flutter/src/utils/consts_color.dart';

import 'src/screen/root_screen.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("BackGround");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await dotenv.load(fileName: ".env");
  HttpOverrides.global = PermitInvalidCertification();
  await Get.put(NotificationService()).initService();

  runApp(DevicePreview(enabled: false, builder: (context) => MyApp()));
}

const bool useMain = false;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          title: 'Socket_Flutter',
          debugShowCheckedModeBanner: kDebugMode,
          theme: ThemeData(
            appBarTheme: AppBarTheme(
              titleTextStyle: TextStyle(
                color: Colors.black54,
                fontSize: 17.sp,
                fontWeight: FontWeight.bold,
              ),
              iconTheme: IconThemeData(color: Colors.black54),
              actionsIconTheme: IconThemeData(color: Colors.black54),
              elevation: 1,
              backgroundColor: ConstsColor.mainBackgroundColor,
            ),
            scaffoldBackgroundColor: ConstsColor.mainBackgroundColor,
          ),
          getPages: AppRoot.pages,
          initialRoute: RootScreen.routeName,
        );
      },
    );
  }
}

class PermitInvalidCertification extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, host, port) => host == true;
  }
}
