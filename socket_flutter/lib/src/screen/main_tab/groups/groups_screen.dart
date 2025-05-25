import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get/utils.dart';
import 'package:socket_flutter/src/model/group.dart';
import 'package:socket_flutter/src/screen/main_tab/groups/groups_controller.dart';
import 'package:socket_flutter/src/screen/main_tab/users/users_screen.dart';
import 'package:socket_flutter/src/screen/widget/animated_widget.dart';
import 'package:socket_flutter/src/screen/widget/overlap_avatars.dart';

import '../../../utils/neumorpic_style.dart';

class GroupsScreen extends StatelessWidget {
  const GroupsScreen({super.key});
  static const routeName = '/GroupScreen';

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GroupsController>(
      init: GroupsController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Groups'),
            actions: [
              IconButton(
                icon: const Icon(Icons.person_add),
                onPressed: () {
                  Get.toNamed(UsersScreen.routeName, arguments: false);
                },
              ),
            ],
          ),
          body: controller.isCompEmpty
              ? const EmptyScreen(
                  title: "No Group",
                  path: "assets/lotties/no_group.json",
                )
              : ListView.separated(
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: controller.groups.length,
                  itemBuilder: (context, index) {
                    final group = controller.groups[index];
                    return GroupCell(group: group);
                  },
                ),
        );
      },
    );
  }
}

class GroupCell extends GetView<GroupsController> {
  const GroupCell({super.key, required this.group});

  final Group group;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        controller.pushGroupScreen(group);
      },
      child: Neumorphic(
        style: commonNeumorphic(depth: 0.6),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Row(
          children: [
            OverlapAvatars(users: group.members),
            const SizedBox(width: 20),
            Text(group.title != null ? group.title! : "Anonymous".tr),
          ],
        ),
      ),
    );
  }
}
