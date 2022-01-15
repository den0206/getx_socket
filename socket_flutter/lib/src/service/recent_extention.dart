import 'package:socket_flutter/src/api/group_api.dart';
import 'package:socket_flutter/src/api/recent_api.dart';
import 'package:socket_flutter/src/model/group.dart';
import 'package:socket_flutter/src/model/recent.dart';
import 'package:socket_flutter/src/model/user.dart';
import 'package:socket_flutter/src/service/auth_service.dart';

class RecentExtention {
  final RecentAPI _recentAPI = RecentAPI();
  final GropuAPI _groupAPI = GropuAPI();

  User get currentUser => AuthService.to.currentUser.value!;

  // MARK Private
  Future<String?> createPrivateChatRoom(
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

    final res = await _recentAPI.getByRoomID(
      chatRoomId,
      includeUserParams: false,
    );

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
      await createRecentAPI(id, currentUID, users, chatRoomId);
    });
    print(tempMembers.length);

    return chatRoomId;
  }

  /// MARK Group
  Future<Group?> createGroup(List<User> members) async {
    final owner = currentUser;
    members.insert(0, owner);

    /// unique
    final ids = Set();
    members.retainWhere((x) => ids.add(x.id));
    final memberIds = members.map((m) => m.id).toList();

    final Map<String, dynamic> body = {
      "ownerId": owner.id,
      "members": memberIds
    };

    final res = await _groupAPI.createGroup(body);
    if (!res.status) {
      return null;
    }

    final group = Group.fromMapWithMembers(res.data, members);
    return group;
  }

  Future<void> createGroupRecent(Group group) async {
    await Future.forEach(group.members, (User user) async {
      final Map<String, dynamic> recent = {
        "userId": user.id,
        "chatRoomId": group.id,
        "group": group.id,
      };

      print(recent);

      await _recentAPI.createChatRecent(recent);
    });

    print("Update All Recents!!");
  }

  Future<void> createRecentAPI(
      String id, String currentUID, List<User> users, String chatRoomId) async {
    final withUser = id == currentUID ? users.last : users.first;

    final Map<String, dynamic> recent = {
      "userId": id,
      "chatRoomId": chatRoomId,
      "withUserId": withUser.id,
    };

    await _recentAPI.createChatRecent(recent);
  }

  Future<List<Recent>> findByChatRoomId(String chatRoomId) async {
    final res = await _recentAPI.getByRoomID(chatRoomId);

    if (!res.status) {
      return [];
    }

    final recents = (res.data as List).map((r) => Recent.fromMap(r)).toList();

    return recents;
  }

  Future<void> updateRecentItem(Recent recent, String lastMessage) async {
    final uid = recent.user.id;
    var counter = recent.counter;

    if (currentUser.id != uid) {
      counter++;
    }

    final value = {
      "lastMessage": lastMessage,
      "counter": counter,
    };

    await _recentAPI.updateRecent(recent, value);
  }

  Future<List<Recent>> updateRecentWithLastMessage(
      {required String chatRoomId,
      String? lastMessage,
      bool isDelete = false}) async {
    final recents = await findByChatRoomId(chatRoomId);

    String last;

    if (lastMessage != null) {
      last = lastMessage;
    } else {
      last = "Deleted";
    }

    if (recents.isNotEmpty) {
      await Future.forEach(recents, (Recent recent) async {
        await updateRecentItem(recent, last);
      });
    }
    return recents;
  }
}
