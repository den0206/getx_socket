import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:socket_flutter/src/model/user.dart';
import 'package:socket_flutter/src/screen/main_tab/settings/settings_screen.dart';
import 'package:socket_flutter/src/screen/main_tab/users/user_detail/user_detail_controller.dart';
import 'package:sizer/sizer.dart';
import 'package:socket_flutter/src/screen/widget/custom_button.dart';
import 'package:socket_flutter/src/screen/widget/neumorphic/buttons.dart';
import 'package:socket_flutter/src/screen/widget/user_country_widget.dart';

import '../../../../utils/consts_color.dart';

class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen(this.user, {Key? key}) : super(key: key);

  static const routeName = '/UserDetail';
  final User user;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserDetailController>(
      init: UserDetailController(user),
      initState: (_) {},
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text(controller.user.name),
          ),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                UserCountryWidget(
                  user: user,
                  size: 40.w,
                  useNeumorphic: true,
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  controller.user.name,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40.0,
                      color: Colors.black),
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: controller.user.isCurrent
                      ? [
                          NeumorphicIconButton(
                            iconData: Icons.group,
                            size: 35.sp,
                            onPressed: () {
                              controller.openGroups();
                            },
                          ),
                          NeumorphicIconButton(
                            iconData: Icons.edit,
                            size: 35.sp,
                            onPressed: () {
                              controller.showEdit();
                            },
                          ),
                          NeumorphicIconButton(
                            iconData: Icons.settings,
                            size: 35.sp,
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor:
                                    ConstsColor.mainBackgroundColor,
                                builder: (context) {
                                  return SettingsScreen();
                                },
                              );
                            },
                          ),
                        ]
                      : [
                          NeumorphicIconButton(
                            iconData: Icons.message,
                            size: 40.sp,
                            onPressed: () {
                              controller.startPrivateChat();
                            },
                          ),
                          NeumorphicIconButton(
                            iconData: Icons.block,
                            size: 40.sp,
                            depth: controller.isBlocked ? -2 : 1,
                            onPressed: () {
                              controller.blockUser();
                            },
                          ),
                        ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ProfileButtonsArea extends StatelessWidget {
  const ProfileButtonsArea({
    Key? key,
    required this.buttons,
  }) : super(key: key);
  final List<CustomCircleButton> buttons;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(10),
      shrinkWrap: true,
      mainAxisSpacing: 21,
      // crossAxisSpacing: 21,
      childAspectRatio: 2.2,
      crossAxisCount: buttons.length > 2 ? buttons.length ~/ 2 : buttons.length,
      children: buttons,
    );
  }
}
