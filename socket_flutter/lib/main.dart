import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/route_manager.dart';
import 'package:sizer/sizer.dart';
import 'package:socket_flutter/src/app_root.dart';
import 'package:socket_flutter/src/languages/locale_lang.dart';
import 'package:socket_flutter/src/service/storage_service.dart';
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

  _currentLocale = getLocale(await StorageKey.locale.loadString()).locale;

  const flavor = String.fromEnvironment('FLAVOR');
  print(flavor);
  // runApp(DevicePreview(enabled: false, builder: (context) => const MyApp()));
  runApp(const MyApp());
}

const bool useMain = true;
Locale? _currentLocale;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          title: 'InvenTalk',
          debugShowCheckedModeBanner: kDebugMode,
          translations: LocaleLang(),
          locale: _currentLocale ?? Get.deviceLocale,
          fallbackLocale: const Locale("en", "US"),
          theme: ThemeData(
            appBarTheme: AppBarTheme(
              titleTextStyle: TextStyle(
                color: Colors.black54,
                fontSize: 17.sp,
                fontWeight: FontWeight.bold,
              ),
              iconTheme: const IconThemeData(color: Colors.black54),
              actionsIconTheme: const IconThemeData(color: Colors.black54),
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
          // ignore: unrelated_type_equality_checks
          (X509Certificate cert, host, port) => host == true;
  }
}
