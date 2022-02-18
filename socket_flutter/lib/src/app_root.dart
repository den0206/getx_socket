import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:socket_flutter/src/screen/auth/login/login_contoller.dart';
import 'package:socket_flutter/src/screen/auth/login/login_sceen.dart';
import 'package:socket_flutter/src/screen/auth/reset_password/reset_password_screen.dart';
import 'package:socket_flutter/src/screen/auth/signup/signup_screen.dart';
import 'package:socket_flutter/src/screen/main_tab/blocks/block_list_screen.dart';
import 'package:socket_flutter/src/screen/main_tab/groups/groups_screen.dart';
import 'package:socket_flutter/src/screen/main_tab/message/message_controller.dart';
import 'package:socket_flutter/src/screen/main_tab/message/message_screen.dart';
import 'package:socket_flutter/src/screen/main_tab/qr_code/qr_tab_screen.dart';
import 'package:socket_flutter/src/screen/main_tab/users/user_edit/email/edit_email_screen.dart';
import 'package:socket_flutter/src/screen/main_tab/users/user_edit/user_edit_controller.dart';
import 'package:socket_flutter/src/screen/main_tab/users/user_edit/user_edit_screen.dart';
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
    // binding: BindingsBuilder(
    //   () => Get.lazyPut(() => SignUpController()),
    // ),
  ),
  GetPage(
    name: ResetPasswordScreen.routeName,
    page: () => ResetPasswordScreen(),
  )
];

final List<GetPage> _mainPages = [
  GetPage(
    name: UsersScreen.routeName,
    page: () => UsersScreen(),
  ),
  GetPage(
    name: UserEditScreen.routeName,
    page: () => UserEditScreen(),
    binding: BindingsBuilder(
      () => Get.lazyPut(
        () => UserEditController(),
      ),
    ),
  ),
  GetPage(
    name: BlockListScreen.routeName,
    page: () => BlockListScreen(),
    fullscreenDialog: true,
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
  ),
  GetPage(
    name: QrTabScreen.routeName,
    page: () => QrTabScreen(),
    fullscreenDialog: true,
  ),
  GetPage(
    name: EditEmailScreen.routeName,
    page: () => EditEmailScreen(),
    fullscreenDialog: true,
  )
];
