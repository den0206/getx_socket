import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/route_manager.dart';
import 'package:socket_flutter/src/api/group_api.dart';
import 'package:socket_flutter/src/model/group.dart';
import 'package:socket_flutter/src/screen/main_tab/message/message_extention.dart';
import 'package:socket_flutter/src/screen/main_tab/message/message_screen.dart';
import 'package:socket_flutter/src/screen/main_tab/recents/recents_controller.dart';
import 'package:socket_flutter/src/screen/widget/common_dialog.dart';

class GroupDetailController extends GetxController {
  GroupDetailController(this.group);

  final Group group;
  final GropuAPI _gropuAPI = GropuAPI();

  Future<void> tryDeleteGroup(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          title: "Delete",
          descripon: "Remove all Relation!",
          icon: Icons.delete,
          mainColor: Colors.red,
          onPress: () async {
            await deleteGroup();
          },
        );
      },
    );
  }

  Future<void> deleteGroup() async {
    if (!group.isOwner) return;

    final res = await _gropuAPI.deleteById(group.id);

    if (!res.status) {
      print("Can't Delete Group");
      return;
    }

    final deletedId = group.id;

    if (Get.isRegistered<RecentsController>()) {
      RecentsController.to.recentIO.sendDeleteGroup(group: group);
    }

    Get.back(result: deletedId);
  }

  Future<void> pushMessagePage() async {
    Get.until((route) => route.isFirst);

    final MessageExtention extention =
        MessageExtention(chatRoomId: group.id, withUsers: group.members);
    Get.toNamed(MessageScreen.routeName, arguments: extention);
  }
}
