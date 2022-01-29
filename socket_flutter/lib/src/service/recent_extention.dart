import 'package:socket_flutter/src/api/group_api.dart';
import 'package:socket_flutter/src/api/recent_api.dart';
import 'package:socket_flutter/src/model/group.dart';
import 'package:socket_flutter/src/model/recent.dart';
import 'package:socket_flutter/src/model/user.dart';
import 'package:socket_flutter/src/screen/main_tab/recents/recents_controller.dart';
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
      _useSingleSocket(userId: id, chatRoomId: chatRoomId);
    });
    print(tempMembers.length);

    return chatRoomId;
  }

  void _useSingleSocket({required String userId, required String chatRoomId}) {
    /// MARK Recentソケット
    RecentsController.to.recentIO
        .sendUpdateRecent(userIds: userId, chatRoomId: chatRoomId);
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

      await _recentAPI.createChatRecent(recent);
    });
  }

  Future<void> createRecentAPI(
      String id, String currentUID, List<User> users, String chatRoomId) async {
    Map<String, dynamic> recent;

    if (users.length > 2) {
      recent = {
        "userId": id,
        "chatRoomId": chatRoomId,
        "group": chatRoomId,
      };
    } else {
      /// private
      final withUser = id == currentUID ? users.last : users.first;

      recent = {
        "userId": id,
        "chatRoomId": chatRoomId,
        "withUserId": withUser.id,
      };
    }
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

  Future<void> updateRecentItem(
      Recent recent, String lastMessage, bool isDelete) async {
    final uid = recent.user.id;
    var counter = recent.counter;

    if (currentUser.id != uid) {
      if (!isDelete) {
        counter++;
      } else {
        --counter;
      }
      if (counter < 0) {
        counter = 0;
      }
    }

    final value = {
      "lastMessage": lastMessage,
      "counter": counter,
    };

    await _recentAPI.updateRecent(recent, value);
  }

  Future<List<Recent>> updateRecentWithLastMessage(
      {required String chatRoomId, String? lastMessage}) async {
    final recents = await findByChatRoomId(chatRoomId);

    String last;

    if (lastMessage != null) {
      last = lastMessage;
    } else {
      last = "Deleted";
    }

    if (recents.isNotEmpty) {
      await Future.forEach(recents, (Recent recent) async {
        await updateRecentItem(recent, last, lastMessage == null);
      });
    }
    return recents;
  }
}
