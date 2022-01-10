import 'package:socket_flutter/src/api/recent_api.dart';
import 'package:socket_flutter/src/model/recent.dart';
import 'package:socket_flutter/src/model/user.dart';
import 'package:socket_flutter/src/service/auth_service.dart';

class RecentExtention {
  final RecentAPI _recentAPI = RecentAPI();

  Future<String?> createChatRoom(
      String currentUID, String withUserID, List<User> users) async {
    var chatRoomId;

    final value = currentUID.compareTo(withUserID);
    if (value < 0) {
      chatRoomId = currentUID + withUserID;
    } else {
      chatRoomId = withUserID + currentUID;
    }

    final userIds = [currentUID, withUserID];
    var tempMembers = userIds;

    final res = await _recentAPI.getByRoomID(chatRoomId);

    if (!res.status) {
      return null;
    }

    final recents = [...res.data];

    if (recents.isNotEmpty) {
      for (Map<String, dynamic> recent in recents) {
        final currentRecent = recent;

        final String current = currentRecent["userId"];
        if (userIds.contains(current)) {
          tempMembers.remove(current);
        }
      }
    }

    await Future.forEach(tempMembers, (String id) async {
      await _createRecentAPI(id, currentUID, users, chatRoomId);
    });
    print(tempMembers.length);

    return chatRoomId;
  }

  Future<void> _createRecentAPI(
      String id, String currentUID, List<User> users, String chatRoomId) async {
    final withUser = id == currentUID ? users.last : users.first;

    final Map<String, dynamic> recent = {
      "userId": id,
      "chatRoomId": chatRoomId,
      "withUserId": withUser.id,
    };

    await _recentAPI.createPrivateChat(recent);
  }

  Future<List<Recent>> findByChatRoomId(String chatRoomId) async {
    final res = await _recentAPI.getByRoomID(chatRoomId);

    if (!res.status) {
      return [];
    }

    final recents = (res.data as List).map((r) => Recent.fromMap(r)).toList();

    return recents;
  }

  void updateRecentItem(Recent recent, String lastMessage) {
    final date = DateTime.now();
    final uid = recent.user.id;
    final currentUid = AuthService.to.currentUser.value!.id;
    var counter = recent.counter;

    if (currentUid != uid) {
      ++counter;
    }

    final value = {
      "lastMessage": lastMessage,
      "conter": counter,
      "date": date,
    };

    print(value);
  }
}
