import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:socket_flutter/src/api/recent_api.dart';
import 'package:socket_flutter/src/model/page_feed.dart';
import 'package:socket_flutter/src/model/recent.dart';
import 'package:socket_flutter/src/model/user.dart';
import 'package:socket_flutter/src/screen/main_tab/message/message_extention.dart';
import 'package:socket_flutter/src/screen/main_tab/message/message_screen.dart';
import 'package:socket_flutter/src/service/auth_service.dart';
import 'package:socket_flutter/src/utils/enviremont.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

class RecentsController extends GetxController {
  static RecentsController get to => Get.find();

  final List<Recent> recents = [];
  final RecentAPI _recentApi = RecentAPI();
  final int limit = 5;

  String? nextCursor;
  bool reachLast = false;
  late IO.Socket socket;

  @override
  void onInit() async {
    super.onInit();

    await loadRecents();

    _initSocket();
    listenRrecent();
  }

  Future<void> reLoad() async {
    print("Refres");
    reachLast = false;
    nextCursor = null;
    recents.clear();

    await loadRecents();
  }

  Future<void> loadRecents() async {
    if (reachLast) {
      return;
    }

    final res =
        await _recentApi.getRecents(limit: limit, nextCursor: nextCursor);

    if (!res.status) {
      return;
    }

    final Pages<Recent> pages = Pages.fromMap(res.data, Recent.fromJsonModel);

    // set;
    reachLast = !pages.pageInfo.hasNextPage;
    nextCursor = pages.pageInfo.nextPageCursor;
    // print("next cursor is ${nextCursor}");

    final temp = pages.pageFeeds;
    recents.addAll(temp);
    recents.sort((a, b) => b.date.compareTo(a.date));

    update();
  }

  Future<void> deleteRecent(Recent recent) async {
    final recentId = recent.id;
    await _recentApi.deleteRecent(recentId: recentId);
  }

  Future<void> pushMessageScreen(Recent recent) async {
    List<User> argumentUser = [];
    switch (recent.type) {
      case RecentType.private:
        argumentUser.add(recent.withUser!);
        break;
      case RecentType.group:
        return;
    }

    final MessageExtention extention = MessageExtention(
      chatRoomId: recent.chatRoomId,
      withUsers: argumentUser,
    );

    final _ = await Get.toNamed(MessageScreen.routeName, arguments: extention);
  }

  void _initSocket() {
    final currentUser = AuthService.to.currentUser.value!;
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
  }

  void listenRrecent() {
    final currentUser = AuthService.to.currentUser.value!;
    socket.on("update", (data) async {
      final chatRoomId = data["chatRoomId"];
      print("UPDATE $chatRoomId");

      final res =
          await _recentApi.findOneByRoomIdAndUserId(currentUser.id, chatRoomId);
      if (res.status) {
        final newRecent = Recent.fromMap(res.data);
        if (!recents.map((r) => r.id).contains(newRecent.id)) {
          /// not Load Recents yet.
          recents.insert(0, newRecent);
        } else {
          print("Replace");
          int index = recents.indexWhere((recent) => recent.id == newRecent.id);
          recents[index] = newRecent;
          recents.sort((a, b) => b.date.compareTo(a.date));
        }

        update();
      }
    });
  }
}
