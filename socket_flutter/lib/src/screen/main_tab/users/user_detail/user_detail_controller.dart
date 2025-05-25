import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:package_info_plus/package_info_plus.dart';
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

import '../../../widget/loading_widget.dart';
import '../../settings/contacts/contact_screen.dart';

class UserDetailController extends LoadingGetController {
  UserDetailController(this.user);

  User user;
  final currentUser = AuthService.to.currentUser.value!;
  final UserAPI _userAPI = UserAPI();
  bool isBlocked = false;

  String? currentVersion;

  @override
  void onInit() async {
    super.onInit();

    isBlocked = currentUser.checkBlock(user);
    await getInfo();
    update();
  }

  Future<void> getInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    currentVersion = packageInfo.version;
  }

  Future<void> startPrivateChat() async {
    try {
      if (user.isCurrent || user.checkBlock(currentUser)) {
        throw Exception("Can't Send Message");
      }

      final cr = RecentExtention();

      final chatRoomId = await cr.createPrivateChatRoom(
        currentUser.id,
        user.id,
        [currentUser, user],
      );

      if (chatRoomId == null) {
        print("Not Generate ChatID");
        return;
      }

      Get.until((route) => route.isFirst);

      final MessageExtention extention = MessageExtention(
        chatRoomId: chatRoomId,
        withUsers: [user],
      );

      Get.toNamed(MessageScreen.routeName, arguments: extention);
    } catch (e) {
      showError(e.toString());
    }
  }

  Future<void> openGroups() async {
    final _ = await Get.toNamed(GroupsScreen.routeName);
  }

  Future<void> showEdit() async {
    final editedUser = await Get.toNamed(UserEditScreen.routeName);

    if (editedUser is User) {
      user = editedUser;
      update();
    }
  }

  Future<void> showBlockList() async {
    final _ = await Get.toNamed(BlockListScreen.routeName);
  }

  Future<void> showSettings() async {
    final _ = await Get.toNamed(ContactScreen.routeName);
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

    if (currentUser.checkBlock(user)) {
      currentUser.blockedUsers.remove(user.id);
    } else {
      currentUser.blockedUsers.add(user.id);
    }

    final Map<String, dynamic> data = {
      "blocked": currentUser.blockedUsers.toSet().toList(),
    };

    final res = await _userAPI.updateBlock(userData: data);
    if (!res.status) return;

    final newUser = User.fromMap(res.data);
    await AuthService.to.updateUser(newUser);

    isBlocked = !isBlocked;
    update();
  }
}
