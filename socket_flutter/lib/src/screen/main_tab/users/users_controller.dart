import 'package:get/get.dart';

import 'package:socket_flutter/src/api/user_api.dart';
import 'package:socket_flutter/src/model/page_feed.dart';
import 'package:socket_flutter/src/model/user.dart';
import 'package:socket_flutter/src/screen/main_tab/users/user_detail/user_detail_controller.dart';
import 'package:socket_flutter/src/screen/main_tab/users/user_detail/user_detail_screen.dart';
import 'package:socket_flutter/src/service/auth_service.dart';

class UsersController extends GetxController {
  final UserAPI _userApi = UserAPI();
  final RxList<User> users = <User>[].obs;

  final int limit = 5;
  String? nextCursor;
  bool reachLast = false;

  @override
  void onInit() async {
    super.onInit();
    await loadUsers();
  }

  void onTap(User user) {
    Get.to(
      UserDetailScreen(),
      binding: BindingsBuilder(
        () => Get.lazyPut(() => UserDetailController(user)),
      ),
    );
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
}
