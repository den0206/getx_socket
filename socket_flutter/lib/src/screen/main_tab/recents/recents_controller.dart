import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:socket_flutter/src/api/recent_api.dart';
import 'package:socket_flutter/src/model/page_feed.dart';
import 'package:socket_flutter/src/model/recent.dart';
import 'package:socket_flutter/src/model/user.dart';
import 'package:socket_flutter/src/screen/main_tab/message/message_extention.dart';
import 'package:socket_flutter/src/screen/main_tab/message/message_screen.dart';
import 'package:socket_flutter/src/screen/widget/common_dialog.dart';
import 'package:socket_flutter/src/socket/recent_io.dart';

class RecentsController extends GetxController {
  static RecentsController get to => Get.find();

  final List<Recent> recents = [];
  final RecentAPI _recentApi = RecentAPI();
  final int limit = 10;

  String? nextCursor;
  bool reachLast = false;
  bool isLoading = false;

  bool get isCompEmpty {
    return recents.isEmpty && !isLoading;
  }

  final sc = ScrollController();
  final RecentIO recentIO = RecentIO();

  @override
  void onInit() async {
    super.onInit();

    await loadRecents();
    addSCListner();
    recentIO.initSocket();
    listenRecent();
    listenRecentDelete();
  }

  @override
  void onClose() {
    super.onClose();

    sc.removeListener(() {});
    sc.dispose();

    print("Destroy RECENT");
    recentIO.destroySocket();
  }

  Future<void> reLoad() async {
    reachLast = false;
    nextCursor = null;
    isLoading = false;
    recents.clear();
    update();

    await Future.delayed(const Duration(milliseconds: 500));
    await loadRecents();
  }

  void addSCListner() {
    sc.addListener(() {
      if (sc.position.pixels >= sc.position.maxScrollExtent * 0.95) {
        loadRecents();
      }
    });
  }

  Future<void> loadRecents() async {
    if (reachLast || isLoading) return;
    isLoading = true;

    try {
      final res =
          await _recentApi.getRecents(limit: limit, nextCursor: nextCursor);

      if (!res.status) return;

      final Pages<Recent> pages = Pages.fromMap(res.data, Recent.fromJsonModel);

      // set;
      reachLast = !pages.pageInfo.hasNextPage;
      nextCursor = pages.pageInfo.nextPageCursor;

      final temp = pages.pageFeeds;
      recents.addAll(temp);
      recents.sort((a, b) => b.date.compareTo(a.date));

      update();
    } catch (e) {
      showError(e.toString());
    } finally {
      isLoading = false;
    }
  }

  Future<void> deleteRecent(Recent recent) async {
    final recentId = recent.id;

    try {
      final res = await _recentApi.deleteRecent(recentId: recentId);
      if (!res.status) return;
      recents.remove(recent);
      update();
    } catch (e) {
      showError(e.toString());
    }
  }

  Future<void> pushMessageScreen(Recent recent) async {
    List<User> argumentUser = [];
    switch (recent.type) {
      case RecentType.private:
        argumentUser.add(recent.withUser!);
        break;
      case RecentType.group:
        argumentUser.addAll(recent.group!.members);
      // return;
    }

    final MessageExtention extention = MessageExtention(
      chatRoomId: recent.chatRoomId,
      withUsers: argumentUser,
    );

    final _ = await Get.toNamed(MessageScreen.routeName, arguments: extention);

    await resetCounter(recent);

    update();
  }

  void listenRecent() {
    recentIO.listenRecentUpdate((newRecent) {
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
    });
  }

  Future<void> resetCounter(Recent tempRecent) async {
    int index = recents.indexWhere((recent) => recent.id == tempRecent.id);
    final isUpdate = recents[index].counter != 0;
    if (isUpdate) {
      recents[index].counter = 0;
      final value = {"counter": 0};

      await _recentApi.updateRecent(tempRecent, value);
    }
  }

  void listenRecentDelete() {
    recentIO.listenRecentDelete((chatRoomid) {
      print("deleted $chatRoomid");
      if (recents.map((r) => r.chatRoomId).contains(chatRoomid)) {
        recents.removeWhere((r) => r.chatRoomId == chatRoomid);
        update();
      }
    });
  }
}
