import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:socket_flutter/src/api/recent_api.dart';
import 'package:socket_flutter/src/model/page_feed.dart';
import 'package:socket_flutter/src/model/recent.dart';

class RecentsController extends GetxController {
  final List<Recent> recents = [];
  final RecentAPI _recentApi = RecentAPI();
  final int limit = 5;

  String? nextCursor;
  bool reachLast = false;

  @override
  void onInit() async {
    super.onInit();

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
    print("next cursor is ${nextCursor}");

    final temp = pages.pageFeeds;
    recents.addAll(temp);

    update();
  }

  Future<void> deleteRecent(Recent recent) async {
    final recentId = recent.id;
    await _recentApi.deleteRecent(recentId: recentId);
  }
}
