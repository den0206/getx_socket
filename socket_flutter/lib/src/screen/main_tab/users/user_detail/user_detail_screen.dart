import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:socket_flutter/src/model/user.dart';
import 'package:socket_flutter/src/screen/main_tab/users/user_detail/user_detail_controller.dart';
import 'package:socket_flutter/src/screen/widget/custom_button.dart';

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
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: controller.user.isCurrent
                      ? [
                          CustomButton(
                            title: "Groups",
                            background: Colors.orange,
                            onPressed: () {
                              controller.openGroups();
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          CustomButton(
                            title: "Edit",
                            background: Colors.green,
                            onPressed: () {
                              controller.showEdit();
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          CustomButton(
                            title: "Logout",
                            background: Colors.red,
                            onPressed: () {
                              controller.tryLogout(context);
                            },
                          ),
                        ]
                      : [
                          CustomButton(
                            title: "Message",
                            background: Colors.green,
                            titleColor: Colors.white,
                            onPressed: () {
                              controller.startPrivateChat();
                            },
                          ),
                        ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
