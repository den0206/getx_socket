import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:socket_flutter/src/model/user.dart';
import 'package:socket_flutter/src/screen/main_tab/report/report_screen.dart';
import 'package:socket_flutter/src/screen/main_tab/settings/settings_screen.dart';
import 'package:socket_flutter/src/screen/main_tab/users/user_detail/user_detail_controller.dart';
import 'package:socket_flutter/src/screen/widget/custom_button.dart';
import 'package:socket_flutter/src/screen/widget/neumorphic/buttons.dart';
import 'package:socket_flutter/src/screen/widget/user_country_widget.dart';

import '../../../../utils/consts_color.dart';
import '../../report/report_controller.dart';

class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen(this.user, {Key? key}) : super(key: key);

  static const routeName = '/UserDetail';
  final User user;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserDetailController>(
      init: UserDetailController(user),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text(controller.user.name),
            actions: !user.isCurrent
                ? [
                    Builder(builder: (context) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: NeumorphicIconButton(
                          icon: Icon(
                            Icons.emergency_share,
                            color: Colors.red[400],
                          ),
                          onPressed: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                              builder: (context) {
                                return ReportScreen(user, null);
                              },
                              fullscreenDialog: true,
                            ))
                                .then(
                              (value) async {
                                if (Get.isRegistered<ReportController>()) {
                                  await Get.delete<ReportController>();
                                }
                              },
                            );
                          },
                        ),
                      );
                    }),
                  ]
                : null,
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
                const SizedBox(
                  height: 20,
                ),
                if (user.isCurrent) ...[Text(user.email)],
                const SizedBox(
                  height: 20,
                ),
                Text(
                  controller.user.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40.0,
                      color: Colors.black),
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: controller.user.isCurrent
                      ? [
                          NeumorphicIconButton(
                            icon: Icon(
                              Icons.group,
                              size: 35.sp,
                            ),
                            onPressed: () {
                              controller.openGroups();
                            },
                          ),
                          NeumorphicIconButton(
                            icon: Icon(
                              Icons.edit,
                              size: 35.sp,
                            ),
                            onPressed: () {
                              controller.showEdit();
                            },
                          ),
                          NeumorphicIconButton(
                            icon: Icon(
                              Icons.settings,
                              size: 35.sp,
                            ),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor:
                                    ConstsColor.mainBackgroundColor,
                                builder: (context) {
                                  return const SettingsScreen();
                                },
                              );
                            },
                          ),
                        ]
                      : [
                          NeumorphicIconButton(
                            icon: Icon(
                              Icons.message,
                              size: 40.sp,
                            ),
                            onPressed: () {
                              controller.startPrivateChat();
                            },
                          ),
                          NeumorphicIconButton(
                            icon: Icon(
                              Icons.block,
                              color: controller.isBlocked
                                  ? Colors.black
                                  : Colors.red,
                              size: 40.sp,
                            ),
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
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(10),
      shrinkWrap: true,
      mainAxisSpacing: 21,
      // crossAxisSpacing: 21,
      childAspectRatio: 2.2,
      crossAxisCount: buttons.length > 2 ? buttons.length ~/ 2 : buttons.length,
      children: buttons,
    );
  }
}
