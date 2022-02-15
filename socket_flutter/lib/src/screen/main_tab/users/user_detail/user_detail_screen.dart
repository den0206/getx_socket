import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:socket_flutter/src/model/user.dart';
import 'package:socket_flutter/src/screen/main_tab/users/user_detail/user_detail_controller.dart';
import 'package:sizer/sizer.dart';
import 'package:socket_flutter/src/screen/widget/custom_button.dart';
import 'package:socket_flutter/src/screen/widget/user_country_widget.dart';

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
                  addShadow: true,
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
                Text(controller.user.email),
                SizedBox(
                  height: 40,
                ),
                ProfileButtonsArea(
                  buttons: controller.user.isCurrent
                      ? [
                          CustomCircleButton(
                            title: "Group",
                            icon: Icons.group,
                            backColor: Colors.orange,
                            onPress: () {
                              controller.openGroups();
                            },
                          ),
                          CustomCircleButton(
                            title: "Edit",
                            icon: Icons.edit,
                            backColor: Colors.green,
                            onPress: () {
                              controller.showEdit();
                            },
                          ),
                          CustomCircleButton(
                            title: "BlockList",
                            icon: Icons.block,
                            backColor: Colors.yellow,
                            mainColor: Colors.black,
                            onPress: () {
                              controller.showBlockList();
                            },
                          ),
                          CustomCircleButton(
                            title: "Logout",
                            icon: Icons.logout,
                            backColor: Colors.red,
                            onPress: () {
                              controller.tryLogout(context);
                            },
                          ),
                        ]
                      : [
                          CustomCircleButton(
                            title: "Message",
                            icon: Icons.message,
                            backColor: Colors.green,
                            onPress: () {
                              controller.startPrivateChat();
                            },
                          ),
                          CustomCircleButton(
                            title: controller.isBlocked ? "UnBlock" : "Block",
                            icon: Icons.block,
                            backColor: controller.isBlocked
                                ? Colors.yellow
                                : Colors.purple,
                            mainColor: controller.isBlocked
                                ? Colors.black
                                : Colors.white,
                            onPress: () {
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
      crossAxisSpacing: 21,
      childAspectRatio: 1.8,
      crossAxisCount: buttons.length > 2 ? buttons.length ~/ 2 : buttons.length,
      children: buttons,
    );
  }
}

class CountryFlagWidget extends StatelessWidget {
  const CountryFlagWidget({
    Key? key,
    required this.country,
    this.size = 30,
  }) : super(key: key);

  final CountryCode country;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size - 5,
      width: size,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: getCountryFlag(country),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
