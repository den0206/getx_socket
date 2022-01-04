import 'package:socket_flutter/src/api/recent_api.dart';
import 'package:socket_flutter/src/model/user.dart';

class CreateRecent {
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
}
