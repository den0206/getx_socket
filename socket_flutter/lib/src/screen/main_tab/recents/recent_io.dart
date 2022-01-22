import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:socket_flutter/src/api/recent_api.dart';
import 'package:socket_flutter/src/model/group.dart';
import 'package:socket_flutter/src/model/recent.dart';
import 'package:socket_flutter/src/screen/main_tab/recents/recents_controller.dart';
import 'package:socket_flutter/src/service/auth_service.dart';
import 'package:socket_flutter/src/utils/enviremont.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

class RecentIO {
  late IO.Socket socket;
  final RecentAPI _recentApi = RecentAPI();
  final currentUser = AuthService.to.currentUser.value!;

  RecentIO() {
    _initSocket();
  }

  _initSocket() {
    socket = IO.io(
      "${Enviroment.main}/recents",
      OptionBuilder()
          .setTransports(['websocket'])
          .setQuery({"userId": currentUser.id})
          .enableForceNew()
          .disableAutoConnect()
          .build(),
    );

    socket.connect();
    print("Init");
  }

  void destroySocket() {
    socket.dispose();
    socket.destroy();
    print("RecentIO DESTROY");
  }

  /// MARK  送信
  ///
  void sendUpdateRecent(
      {required dynamic userIds, required String chatRoomId}) {
    if (Get.isRegistered<RecentsController>()) {
      final Map<String, dynamic> data = {
        "userIds": userIds,
        "chatRoomId": chatRoomId,
      };

      socket.emit("updateRecent", data);
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
      print("----UPDATE $chatRoomId");

      final res =
          await _recentApi.findOneByRoomIdAndUserId(currentUser.id, chatRoomId);
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
