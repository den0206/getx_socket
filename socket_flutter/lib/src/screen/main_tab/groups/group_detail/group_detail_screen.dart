import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:socket_flutter/src/screen/main_tab/groups/group_detail/group_detail_controller.dart';
import 'package:socket_flutter/src/screen/widget/custom_button.dart';
import 'package:socket_flutter/src/screen/widget/overlap_avatars.dart';

class GroupDetailScreen extends GetView<GroupDetailController> {
  const GroupDetailScreen({Key? key}) : super(key: key);

  static const routeName = '/GroupDetail';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Title'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              OverlapAvatars(
                users: controller.group.members,
                size: 100,
              ),
              SizedBox(
                height: 20,
              ),
              if (controller.group.isOwner) ...[
                CustomButton(
                  title: "Delete Group",
                  background: Colors.red,
                  titleColor: Colors.white,
                  onPressed: () {
                    controller.tryDeleteGroup(context);
                  },
                ),
                SizedBox(
                  height: 20,
                ),
              ],
              CustomButton(
                title: "Message",
                background: Colors.green,
                titleColor: Colors.white,
                onPressed: () {
                  controller.pushMessagePage();
                },
              ),
            ],
          ),
        ));
  }
}
