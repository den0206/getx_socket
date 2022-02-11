import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import 'package:socket_flutter/src/screen/main_tab/main_tab_controller.dart';
import 'package:socket_flutter/src/screen/main_tab/recents/recents_screen.dart';
import 'package:socket_flutter/src/screen/main_tab/users/user_detail/user_detail_screen.dart';
import 'package:socket_flutter/src/screen/main_tab/users/users_screen.dart';
import 'package:socket_flutter/src/screen/widget/detect_lifecycle_widget.dart';
import 'package:socket_flutter/src/service/auth_service.dart';
import 'package:socket_flutter/src/service/notification_service.dart';

class MainTabScreen extends StatelessWidget {
  const MainTabScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bottomItems = [
      BottomNavigationBarItem(
        label: "Chats",
        icon: Icon(Icons.message),
      ),
      BottomNavigationBarItem(
        label: "Users",
        icon: Icon(
          Icons.group,
        ),
      ),
      BottomNavigationBarItem(
        label: "Profile",
        icon: Icon(
          Icons.person,
        ),
      ),
    ];

    final List<Widget> pages = [
      RecentsScreen(),
      UsersScreen(),
      UserDetailScreen(AuthService.to.currentUser.value!)

      /// current only log outbutton
    ];
    return GetBuilder<MainTabController>(
      init: MainTabController(),
      builder: (controller) {
        return DetectLifeCycleWidget(
          onChangeState: (state) {
            switch (state) {
              case AppLifecycleState.inactive:
                print('非アクティブになったときの処理');
                break;
              case AppLifecycleState.paused:
                NotificationService.to.updateBadges();
                break;
              case AppLifecycleState.resumed:
                NotificationService.to.resetBadge();
                break;
              case AppLifecycleState.detached:
                print('破棄されたときの処理');
                break;
            }
          },
          child: Scaffold(
            body: pages[controller.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.grey,
              selectedItemColor: Colors.black,
              elevation: 0,
              onTap: controller.setIndex,
              type: BottomNavigationBarType.fixed,
              currentIndex: controller.currentIndex,
              items: bottomItems,
            ),
          ),
        );
      },
    );
  }
}
