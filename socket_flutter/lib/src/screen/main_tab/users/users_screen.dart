import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_flutter/src/model/user.dart';
import 'package:socket_flutter/src/screen/main_tab/users/users_controller.dart';
import 'package:socket_flutter/src/screen/widget/common_dialog.dart';
import 'package:socket_flutter/src/screen/widget/custom_button.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({Key? key}) : super(key: key);

  static const routeName = '/UsersScreen';

  @override
  Widget build(BuildContext context) {
    return GetX<UsersController>(
      init: UsersController(),
      builder: (controller) {
        return Scaffold(
            appBar: AppBar(
              title: controller.isPrivate ? Text('Users') : Text("Group"),
            ),
            body: ListView.separated(
              separatorBuilder: (context, index) => Divider(
                color: Colors.black,
                height: 1,
              ),
              itemCount: controller.users.length,
              itemBuilder: (context, index) {
                final User user = controller.users[index];

                return UserCell(user: user);
              },
            ),
            floatingActionButton: !controller.isPrivate
                ? FloatingActionButton(
                    child: Icon(Icons.add),
                    backgroundColor: Colors.green,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CustomDialog(
                            title: "Group",
                            descripon: "create group?",
                            icon: Icons.group_add,
                            mainColor: Colors.green,
                            onPress: () {
                              controller.createGroup();
                            },
                          );
                        },
                      );
                    },
                  )
                : null);
      },
    );
  }
}

class UserCell extends GetView<UsersController> {
  const UserCell({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListTile(
          leading: CircleImageButton(
            imageProvider: getUserImage(user),
            size: 30,
            addShadow: false,
          ),
          selected: controller.checkSelected(user),
          selectedColor: Colors.black,
          selectedTileColor: Colors.grey.withOpacity(0.3),
          title: Text(user.name),
          onTap: () {
            controller.onTap(user);
          },
        ));
  }
}
