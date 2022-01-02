import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:socket_flutter/src/screen/auth/login/login_contoller.dart';
import 'package:socket_flutter/src/screen/auth/login/login_sceen.dart';
import 'package:socket_flutter/src/screen/auth/signup/signup_controller.dart';
import 'package:socket_flutter/src/screen/auth/signup/signup_screen.dart';
import 'package:socket_flutter/src/screen/chat/chat_controller.dart';
import 'package:socket_flutter/src/screen/chat/chat_screen.dart';
import 'package:socket_flutter/src/screen/root_screen.dart';

class AppRoot {
  static List<GetPage> pages = [
    ..._authPages,
  ];
}

final List<GetPage> _authPages = [
  GetPage(
    name: RootScreen.routeName,
    page: () => RootScreen(),
  ),
  GetPage(
    name: LoginScreen.routeName,
    page: () => LoginScreen(),
    binding: BindingsBuilder(
      () => Get.lazyPut(() => LoginController()),
    ),
  ),
  GetPage(
    name: SignUpScreen.routeName,
    page: () => SignUpScreen(),
    binding: BindingsBuilder(
      () => Get.lazyPut(() => SignUpController()),
    ),
  ),
  GetPage(
    name: ChatScreen.routeName,
    page: () => ChatScreen(),
    binding: BindingsBuilder(() => Get.lazyPut(() => ChatController())),
  )
];
