import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:socket_flutter/src/screen/main_tab/users/user_detail/user_detail_controller.dart';
import 'package:socket_flutter/src/screen/widget/custom_button.dart';

class UserDetailScreen extends GetView<UserDetailController> {
  const UserDetailScreen({Key? key}) : super(key: key);

  static const routeName = '/UserDetail';

  @override
  Widget build(BuildContext context) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: controller.user.isCurrent
                  ? []
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
  }
}
