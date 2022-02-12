import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:socket_flutter/src/model/user.dart';
import 'package:socket_flutter/src/screen/main_tab/users/user_detail/user_detail_controller.dart';
import 'package:sizer/sizer.dart';
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
                          ProfileButton(
                            title: "Group",
                            icon: Icons.group,
                            backColor: Colors.orange,
                            onPress: () {
                              controller.openGroups();
                            },
                          ),
                          ProfileButton(
                            title: "Edit",
                            icon: Icons.edit,
                            backColor: Colors.green,
                            onPress: () {
                              controller.showEdit();
                            },
                          ),
                          ProfileButton(
                            title: "BlockList",
                            icon: Icons.block,
                            backColor: Colors.yellow,
                            mainColor: Colors.black,
                            onPress: () {
                              controller.showBlockList();
                            },
                          ),
                          ProfileButton(
                            title: "Logout",
                            icon: Icons.logout,
                            backColor: Colors.red,
                            onPress: () {
                              controller.tryLogout(context);
                            },
                          ),
                        ]
                      : [
                          ProfileButton(
                            title: "Message",
                            icon: Icons.message,
                            backColor: Colors.green,
                            onPress: () {
                              controller.startPrivateChat();
                            },
                          ),
                          ProfileButton(
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
  final List<ProfileButton> buttons;

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

class ProfileButton extends StatelessWidget {
  const ProfileButton({
    Key? key,
    required this.title,
    required this.icon,
    required this.backColor,
    required this.onPress,
    this.mainColor = Colors.white,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final Color backColor;
  final Color mainColor;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        decoration: BoxDecoration(
          color: backColor,
          border: Border.all(color: Colors.green, width: 2),
          shape: BoxShape.circle,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: mainColor,
            ),
            Text(
              title,
              style: TextStyle(color: mainColor),
            )
          ],
        ),
      ),
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
