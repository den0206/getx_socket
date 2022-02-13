import 'package:get/get.dart';

import 'package:socket_flutter/src/api/group_api.dart';
import 'package:socket_flutter/src/model/group.dart';
import 'package:socket_flutter/src/screen/main_tab/groups/group_detail/group_detail_controller.dart';
import 'package:socket_flutter/src/screen/main_tab/groups/group_detail/group_detail_screen.dart';
import 'package:socket_flutter/src/service/auth_service.dart';

class GroupsController extends GetxController {
  final GropuAPI _gropuAPI = GropuAPI();

  final List<Group> groups = [];

  @override
  void onInit() async {
    super.onInit();
    await loadGroups();
  }

  Future<void> loadGroups() async {
    final currentUser = AuthService.to.currentUser.value!;

    final res = await _gropuAPI.findByUserId(currentUser.id);

    if (!res.status) {
      print("cant get groups");
      return;
    }

    final items = res.data.cast<Map<String, dynamic>>();
    final List<Group> temp =
        List<Group>.from(items.map((m) => Group.fromMap(m)));

    groups.addAll(temp);

    update();
  }

  Future<void> pushGroupScreen(Group group) async {
    final deletedId = await Get.to(
      () => GroupDetailScreen(),
      binding: BindingsBuilder(
        () => Get.lazyPut(() => GroupDetailController(group)),
      ),
    );

    if (deletedId is String) {
      final currentIds = groups.map((g) => g.id);
      if (currentIds.contains(deletedId)) {
        groups.removeWhere((g) => g.id == deletedId);
        update();
      }
    }
  }
}
