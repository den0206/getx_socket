import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:socket_flutter/src/screen/main_tab/main_tab_controller.dart';
import 'package:socket_flutter/src/screen/main_tab/recents/recents_screen.dart';
import 'package:socket_flutter/src/screen/main_tab/users/users_screen.dart';
import 'package:socket_flutter/src/screen/widget/custom_button.dart';
import 'package:socket_flutter/src/service/auth_service.dart';

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

      /// current only log outbutton
      Center(
        child: CustomButton(
          title: "Logout",
          onPressed: () {
            AuthService.to.logout();
          },
        ),
      )
    ];
    return GetBuilder<MainTabController>(
      init: MainTabController(),
      builder: (controller) {
        return Scaffold(
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
        );
      },
    );
  }
}
