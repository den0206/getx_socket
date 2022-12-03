import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/utils.dart';
import 'package:sizer/sizer.dart';
import 'package:socket_flutter/src/screen/main_tab/groups/group_detail/group_detail_controller.dart';
import 'package:socket_flutter/src/screen/widget/overlap_avatars.dart';

import '../../../widget/neumorphic/buttons.dart';

class GroupDetailScreen extends GetView<GroupDetailController> {
  const GroupDetailScreen({Key? key}) : super(key: key);

  static const routeName = '/GroupDetail';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: controller.group.title != null
              ? Text(controller.group.title!)
              : null,
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
                height: 20.h,
              ),
              if (controller.group.isOwner) ...[
                NeumorphicCustomButtton(
                  title: "Delete Group".tr,
                  background: Colors.red,
                  titleColor: Colors.white,
                  onPressed: () {
                    controller.tryDeleteGroup(context);
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
              NeumorphicCustomButtton(
                title: "Message".tr,
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
