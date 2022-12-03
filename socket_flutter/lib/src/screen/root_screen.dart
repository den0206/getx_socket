import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:socket_flutter/src/screen/auth/login/login_sceen.dart';
import 'package:socket_flutter/src/screen/main_tab/main_tab_screen.dart';
import 'package:socket_flutter/src/service/auth_service.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({Key? key}) : super(key: key);
  static const routeName = '/Root';

  @override
  Widget build(BuildContext context) {
    return GetX<AuthService>(
      init: AuthService(),
      builder: (service) {
        if (service.currentUser.value != null) {
          return const MainTabScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
