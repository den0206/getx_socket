import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:socket_flutter/src/api/user_api.dart';
import 'package:socket_flutter/src/model/user.dart';
import 'package:socket_flutter/src/screen/widget/common_dialog.dart';
import 'package:socket_flutter/src/service/auth_service.dart';

class BlockListController extends GetxController {
  final List<User> blocks = [];
  final currentUser = AuthService.to.currentUser.value!;
  final UserAPI _userAPI = UserAPI();

  @override
  void onInit() async {
    super.onInit();
    await fetchBlocks();
  }

  Future<void> fetchBlocks() async {
    try {
      final res = await _userAPI.fetchBlocks();
      if (!res.status) return;
      final items = res.data.cast<Map<String, dynamic>>();
      final temp = List<User>.from(items.map((m) => User.fromMap(m)));

      blocks.addAll(temp);
      update();
    } catch (e) {
      showError(e.toString());
    }
  }

  Future<void> tryUnblock(BuildContext context, User user) async {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          title: "UnBlock",
          descripon: "continue?",
          icon: Icons.message,
          mainColor: Colors.yellow,
          onPress: () {
            blockUser(user);
          },
        );
      },
    );
  }

  Future<void> blockUser(User user) async {
    if (user.isCurrent) return;
    if (currentUser.checkBlocked(user)) {
      currentUser.blockedUsers.remove(user.id);
      blocks.removeWhere((element) => element.id == user.id);
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
    update();
  }
}
