import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:socket_flutter/src/api/recent_api.dart';
import 'package:socket_flutter/src/model/group.dart';
import 'package:socket_flutter/src/model/recent.dart';
import 'package:socket_flutter/src/screen/main_tab/recents/recents_controller.dart';
import 'package:socket_flutter/src/service/auth_service.dart';
import 'package:socket_flutter/src/socket/socket_base.dart';

class RecentIO extends SocketBase {
  final RecentAPI _recentApi = RecentAPI();
  final currentUser = AuthService.to.currentUser.value!;

  @override
  NameSpace get nameSpace => NameSpace.recent;

  @override
  Map<String, dynamic> get query => {"userId": currentUser.id};

  /// MARK  送信

  void sendUpdateRecent({
    required dynamic userIds,
    required String chatRoomId,
  }) {
    if (Get.isRegistered<RecentsController>()) {
      final Map<String, dynamic> data = {
        "userIds": userIds,
        "chatRoomId": chatRoomId,
      };

      socket.emit("update", data);
    }
  }

  void sendDeleteGroup({required Group group}) {
    final memberIds = group.members.map((u) => u.id).toList();
    final chatRoomId = group.id;

    final data = {"userIds": memberIds, "chatRoomId": chatRoomId};
    socket.emit("deleteGroup", data);
  }

  /// MARK  受信

  void listenRecentUpdate(Function(Recent recent) listner) {
    socket.on("update", (data) async {
      final chatRoomId = data["chatRoomId"];

      final res = await _recentApi.findOneByRoomIdAndUserId(chatRoomId);
      if (res.status) {
        final newRecent = Recent.fromMap(res.data);

        listner(newRecent);
      }
    });
  }

  void listenRecentDelete(Function(String chatRoomid) listner) {
    socket.on("delete", (data) {
      final chatRoomId = data["chatRoomId"];
      listner(chatRoomId);
    });
  }
}
