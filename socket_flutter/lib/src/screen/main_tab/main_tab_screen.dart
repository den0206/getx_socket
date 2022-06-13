import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import 'package:socket_flutter/src/screen/main_tab/main_tab_controller.dart';
import 'package:socket_flutter/src/screen/main_tab/qr_code/qr_tab_screen.dart';
import 'package:socket_flutter/src/screen/main_tab/recents/recents_screen.dart';
import 'package:socket_flutter/src/screen/main_tab/users/user_detail/user_detail_screen.dart';
import 'package:socket_flutter/src/screen/main_tab/users/users_screen.dart';
import 'package:socket_flutter/src/screen/widget/detect_lifecycle_widget.dart';
import 'package:socket_flutter/src/service/auth_service.dart';
import 'package:socket_flutter/src/service/notification_service.dart';
import 'package:socket_flutter/src/utils/consts_color.dart';
import 'package:sizer/sizer.dart';
import 'package:socket_flutter/src/utils/neumorpic_style.dart';

class MainTabScreen extends StatelessWidget {
  const MainTabScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<IconData> bottomIcons = [
      Icons.message,
      Icons.group,
      Icons.qr_code,
      Icons.person
    ];

    final List<Widget> pages = [
      RecentsScreen(),
      UsersScreen(),
      QrTabScreen(),
      UserDetailScreen(AuthService.to.currentUser.value!),

      /// current only log outbutton
    ];
    return GetBuilder<MainTabController>(
      init: MainTabController(),
      autoRemove: false,
      builder: (controller) {
        return DetectLifeCycleWidget(
          onChangeState: (state) {
            switch (state) {
              case AppLifecycleState.inactive:
                print('非アクティブになったときの処理');
                NotificationService.to.updateBadges();
                break;
              case AppLifecycleState.paused:
                print("Paused");
                break;
              case AppLifecycleState.resumed:
                print("ForeGround");
                break;
              case AppLifecycleState.detached:
                print('破棄されたときの処理');
                break;
            }
          },
          child: Scaffold(
            body: pages[controller.currentIndex],
            bottomNavigationBar: Container(
              margin: EdgeInsets.only(bottom: 20),
              height: kBottomNavigationBarHeight,
              decoration: BoxDecoration(color: ConstsColor.mainBackgroundColor),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: bottomIcons
                      .asMap()
                      .entries
                      .map(
                        (entry) => NeumorphicRadio(
                          style: commonRatioStyle(),
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            entry.value,
                            size: 30.sp,
                          ),
                          value: entry.key,
                          groupValue: controller.currentIndex,
                          onChanged: (int? index) {
                            if (index == null) return;
                            controller.setIndex(index);
                          },
                        ),
                      )
                      .toList()),
            ),
          ),
        );
      },
    );
  }
}

       //  BottomNavigationBar(
            //   backgroundColor: Colors.grey,
            //   selectedItemColor: Colors.black,
            //   elevation: 0,
            //   onTap: controller.setIndex,
            //   type: BottomNavigationBarType.fixed,
            //   currentIndex: controller.currentIndex,
            //   items: bottomItems,
            // ),