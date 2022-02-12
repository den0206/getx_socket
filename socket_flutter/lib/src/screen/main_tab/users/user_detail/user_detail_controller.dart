import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:socket_flutter/src/api/user_api.dart';
import 'package:socket_flutter/src/model/user.dart';
import 'package:socket_flutter/src/screen/main_tab/blocks/block_list_screen.dart';
import 'package:socket_flutter/src/screen/main_tab/groups/groups_screen.dart';
import 'package:socket_flutter/src/screen/main_tab/message/message_extention.dart';
import 'package:socket_flutter/src/screen/main_tab/message/message_screen.dart';
import 'package:socket_flutter/src/screen/main_tab/users/user_edit/user_edit_screen.dart';
import 'package:socket_flutter/src/screen/widget/common_dialog.dart';
import 'package:socket_flutter/src/service/auth_service.dart';
import 'package:socket_flutter/src/service/recent_extention.dart';

class UserDetailController extends GetxController {
  UserDetailController(this.user);

  final User user;
  final currentUser = AuthService.to.currentUser.value!;
  final UserAPI _userAPI = UserAPI();
  bool isBlocked = false;

  @override
  void onInit() {
    super.onInit();

    isBlocked = currentUser.checkBlocked(user);
    update();
  }

  Future<void> startPrivateChat() async {
    if (user.isCurrent) return;

    final cr = RecentExtention();

    final chatRoomId = await cr
        .createPrivateChatRoom(currentUser.id, user.id, [currentUser, user]);

    if (chatRoomId == null) {
      print("Not Generate ChatID");
      return;
    }

    Get.until((route) => route.isFirst);

    final MessageExtention extention =
        MessageExtention(chatRoomId: chatRoomId, withUsers: [user]);

    Get.toNamed(MessageScreen.routeName, arguments: extention);
  }

  Future<void> openGroups() async {
    final _ = await Get.toNamed(GroupsScreen.routeName);
  }

  Future<void> showEdit() async {
    final _ = await Get.toNamed(UserEditScreen.routeName);
  }

  Future<void> showBlockList() async {
    final _ = await Get.toNamed(BlockListScreen.routeName);
  }

  Future<void> tryLogout(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          title: "Logout",
          descripon: "continue?",
          icon: Icons.logout,
          mainColor: Colors.red,
          onPress: () {
            AuthService.to.logout();
          },
        );
      },
    );
  }

  Future<void> blockUser() async {
    if (user.isCurrent) return;

    if (currentUser.checkBlocked(user)) {
      currentUser.blockedUsers.remove(user.id);
    } else {
      currentUser.blockedUsers.add(user.id);
    }

    final Map<String, dynamic> data = {
      "blocked": currentUser.blockedUsers.toSet().toList()
    };

    final res = await _userAPI.editUser(userData: data);
    if (!res.status) return;

    final newUser = User.fromMap(res.data);
    await AuthService.to.updateUser(newUser);

    isBlocked = !isBlocked;
    update();
  }
}
