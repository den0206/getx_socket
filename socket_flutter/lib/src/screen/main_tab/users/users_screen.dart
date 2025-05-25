import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:socket_flutter/src/model/user.dart';
import 'package:socket_flutter/src/screen/main_tab/users/users_controller.dart';
import 'package:socket_flutter/src/screen/widget/common_dialog.dart';
import 'package:socket_flutter/src/screen/widget/user_country_widget.dart';

import '../../../utils/neumorpic_style.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  static const routeName = '/UsersScreen';

  @override
  Widget build(BuildContext context) {
    return GetX<UsersController>(
      init: UsersController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: controller.isPrivate ? Text('Users'.tr) : Text("Group".tr),
          ),
          body: ListView.builder(
            itemCount: controller.users.length,
            itemBuilder: (context, index) {
              final User user = controller.users[index];

              if (index == controller.users.length - 1) {
                controller.loadUsers();
              }

              return Obx(
                () => UserCell(
                  user: user,
                  selected: controller.checkSelected(user),
                  onTap: () => controller.onTap(user),
                ),
              );
            },
          ),
          floatingActionButton: !controller.isPrivate
              ? FloatingActionButton(
                  backgroundColor: Colors.green,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return CustomDialog(
                          title: "Group".tr,
                          descripon: "Create Group?".tr,
                          icon: Icons.group_add,
                          mainColor: Colors.green,
                          onPress: () {
                            controller.createGroup();
                          },
                        );
                      },
                    );
                  },
                  child: const Icon(Icons.add),
                )
              : null,
        );
      },
    );
  }
}

class UserCell extends StatelessWidget {
  const UserCell({
    super.key,
    required this.user,
    this.selected = false,
    this.onTap,
  });

  final User user;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Neumorphic(
        style: commonNeumorphic(depth: selected ? -1.5 : 0.6),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Row(
          children: [
            UserCountryWidget(user: user, size: 35),
            const SizedBox(width: 20),
            Text(user.name),
          ],
        ),
      ),
    );
  }
}
