import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:socket_flutter/src/screen/auth/login/login_contoller.dart';
import 'package:socket_flutter/src/screen/auth/login/login_sceen.dart';
import 'package:socket_flutter/src/screen/auth/signup/signup_controller.dart';
import 'package:socket_flutter/src/screen/auth/signup/signup_screen.dart';
import 'package:socket_flutter/src/screen/main_tab/groups/groups_controller.dart';
import 'package:socket_flutter/src/screen/main_tab/groups/groups_screen.dart';
import 'package:socket_flutter/src/screen/main_tab/message/message_controller.dart';
import 'package:socket_flutter/src/screen/main_tab/message/message_screen.dart';
import 'package:socket_flutter/src/screen/main_tab/users/users_screen.dart';
import 'package:socket_flutter/src/screen/root_screen.dart';

class AppRoot {
  static List<GetPage> pages = [
    ..._authPages,
    ..._mainPages,
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
];

final List<GetPage> _mainPages = [
  GetPage(
    name: UsersScreen.routeName,
    page: () => UsersScreen(),
  ),
  GetPage(
    name: MessageScreen.routeName,
    page: () => MessageScreen(),
    binding: BindingsBuilder(
      () => Get.lazyPut(() => MessageController()),
    ),
  ),
  GetPage(
    name: GroupsScreen.routeName,
    page: () => GroupsScreen(),
    fullscreenDialog: true,
  )
];
