import 'package:get/get.dart';

import 'package:socket_flutter/src/api/user_api.dart';
import 'package:socket_flutter/src/model/page_feed.dart';
import 'package:socket_flutter/src/model/user.dart';
import 'package:socket_flutter/src/screen/main_tab/qr_code/qr_tab_screen.dart';
import 'package:socket_flutter/src/screen/main_tab/recents/recents_controller.dart';
import 'package:socket_flutter/src/screen/main_tab/users/user_detail/user_detail_screen.dart';
import 'package:socket_flutter/src/service/auth_service.dart';
import 'package:socket_flutter/src/service/recent_extention.dart';

class UsersController extends GetxController {
  final UserAPI _userApi = UserAPI();
  final RxList<User> users = <User>[].obs;
  final RxList<User> selectedUsers = <User>[].obs;

  final bool isPrivate = Get.arguments ?? true;

  final int limit = 5;
  String? nextCursor;
  bool reachLast = false;

  @override
  void onInit() async {
    super.onInit();
    await loadUsers();
  }

  Future<void> loadUsers() async {
    if (reachLast) {
      return;
    }

    final res = await _userApi.getUsers(limit: limit, nextCursor: nextCursor);

    if (res.message != null) {
      print(res.message);
      return;
    }

    /// use Generic User Model
    final Pages<User> pages = Pages.fromMap(res.data, User.fromJsonModel);

    // set;
    reachLast = !pages.pageInfo.hasNextPage;
    nextCursor = pages.pageInfo.nextPageCursor;
    print("next cursor is ${nextCursor}");

    final temp = pages.pageFeeds
        .where((u) => u.id != AuthService.to.currentUser.value?.id)
        .toList();

    users.addAll(temp);
  }

  void onTap(User user) {
    if (isPrivate) {
      Get.to(
        UserDetailScreen(user),
      );
    } else {
      if (!checkSelected(user)) {
        selectedUsers.add(user);
      } else {
        selectedUsers.remove(user);
      }
    }
  }

  Future<void> createGroup() async {
    if (selectedUsers.length <= 1) {
      print("Too small...");
      return;
    } else if (selectedUsers.length >= 5) {
      print("Too many ....");
      return;
    }

    final re = RecentExtention();

    final group = await re.createGroup(selectedUsers);

    if (group == null) {
      print("グループが作れません");
      return;
    }

    await re.createGroupRecent(group);

    /// MARK Recentソケット

    RecentsController.to.recentIO.sendUpdateRecent(
      userIds: group.members.map((e) => e.id).toList(),
      chatRoomId: group.id,
    );

    selectedUsers.clear();
    Get.until((route) => route.isFirst);
  }

  bool checkSelected(User user) {
    return selectedUsers.contains(user);
  }

  Future<void> showQrScreen() async {
    final findUser = await Get.toNamed(QrTabScreen.routeName);
    if (findUser == User) {
      onTap(findUser);
    }
  }
}
