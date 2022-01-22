import 'package:socket_flutter/src/api/recent_api.dart';
import 'package:socket_flutter/src/model/group.dart';
import 'package:socket_flutter/src/model/recent.dart';
import 'package:socket_flutter/src/service/auth_service.dart';
import 'package:socket_flutter/src/utils/enviremont.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

// TODO ----RecentIOの処理を纏める

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

  void deleteGroupRecents({required Group group}) {
    final memberIds = group.members.map((u) => u.id).toList();
    final chatRoomId = group.id;

    final data = {"userIds": memberIds, "chatRoomId": chatRoomId};

    socket.emit("deleteGroup", data);
  }

  void listenRecentDelete(Function(Recent deleted) listner) {
    socket.on("delete", (data) {
      final chatRoomId = data["chatRoomId"];
      print("----DELETE $chatRoomId");
    });
  }
}
