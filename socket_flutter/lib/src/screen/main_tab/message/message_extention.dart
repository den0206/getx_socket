import 'package:socket_flutter/src/api/message_api.dart';
import 'package:socket_flutter/src/model/message.dart';
import 'package:socket_flutter/src/model/page_feed.dart';
import 'package:socket_flutter/src/model/user.dart';
import 'package:socket_flutter/src/service/auth_service.dart';
import 'package:socket_flutter/src/service/recent_extention.dart';
import 'package:socket_flutter/src/utils/enviremont.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

/// MARK  Message関連のAPI処理等を纏める

class MessageExtention {
  final String chatRoomId;
  final List<User> withUsers;

  final User currentUser = AuthService.to.currentUser.value!;
  final MessageAPI _messageAPI = MessageAPI();
  final RecentExtention re = RecentExtention();
  late IO.Socket socket;

  final int limit = 10;

  bool reachLast = false;
  String? nextCursor;

  MessageExtention({
    required this.chatRoomId,
    required this.withUsers,
  }) {
    _initSocket();
  }

  _initSocket() {
    print(chatRoomId);
    socket = IO.io(
      "${Enviroment.main}/messages",
      OptionBuilder()
          .setTransports(['websocket'])
          .setQuery({"chatID": chatRoomId})
          .enableForceNew()
          .disableAutoConnect()
          .build(),
    );

    socket.connect();
  }

  void stopService() {
    print("Destroy");
    socket.dispose();
    socket.destroy();
  }

  Future<List<Message>> loadMessage() async {
    final res = await _messageAPI.loadMessage(
        chatRoomId: chatRoomId, limit: limit, nextCursor: nextCursor);

    if (!res.status) {
      print("Can not read Messages");
      return [];
    }

    final Pages<Message> pages = Pages.fromMap(res.data, Message.fromJsonModel);

    /// unread を絞り出す
    final unreads = pages.pageFeeds
        .where((message) => !message.isRead && !message.isCurrent)
        .toList();

    if (unreads.isNotEmpty) await updateReadLists(unreads);

    reachLast = !pages.pageInfo.hasNextPage;
    nextCursor = pages.pageInfo.nextPageCursor;

    final temp = pages.pageFeeds;

    return temp;
  }

  void addNerChatListner(Function(Message message) listner) {
    socket.on("message-receive", (data) {
      final newMessage = Message.fromMap(data);

      if (!newMessage.isCurrent) {
        updateRead(message: newMessage, useSocket: true);
      }

      listner(newMessage);
    });
  }

  void addReadListner(Function(Map<String, dynamic> readListner) readListner) {
    socket.on("read-receive", (data) {
      readListner(data);
    });
  }

  Future<void> sendMessage({required String text}) async {
    final Map<String, dynamic> messageData = {
      "chatRoomId": chatRoomId,
      "text": text,
      "userId": currentUser.id,
    };

    final res = await _messageAPI.sendMessage(message: messageData);

    if (!res.status) {
      print("Can not send Message");
      return;
    }

    final message = Message.fromMapWithUser(res.data, currentUser);
    if (socket.id == null) return;

    socket.emit(
      "message",
      message.toMap(),
    );
    final userIds = [currentUser.id, ...withUsers.map((u) => u.id).toList()];

    final existUsers =
        await updateRecent(chatRoomId: chatRoomId, lastMessage: text);

    /// Recent が消されているユーザーを求める
    final deleteUsers = userIds.toSet().difference(existUsers.toSet()).toList();
    if (deleteUsers.isNotEmpty) {
      print("RECREATE Recents $deleteUsers!");

      /// ReCreate New Recent
      final allUsers = [currentUser, ...withUsers];
      await Future.forEach(deleteUsers, (String id) async {
        await re.createRecentAPI(id, currentUser.id, allUsers, chatRoomId);
      });
    }

    final Map<String, dynamic> data = {
      "userIds": userIds,
      "chatRoomId": chatRoomId,
    };
    socket.emit("update", data);
  }

  /// MARK Delete Message
  Future<bool> delete(String id) async {
    final res = await _messageAPI.deleteMessage(id);

    if (res.message != null) {
      print("Delete Fail!!!, ${res.message}");
    }

    return res.status;
  }

  /// MARK Recent Status

  Future<List<String>> updateRecent(
      {required String chatRoomId, required String lastMessage}) async {
    final updated = await re.updateRecentWithLastMessage(
        chatRoomId: chatRoomId, lastMessage: lastMessage);

    return updated.map((r) => r.user.id).toList();
  }

  /// MARK Read Status

  Future<void> updateReadLists(List<Message> unreads) async {
    print("-----Update READ!!");

    Future.forEach(unreads, (Message message) async {
      if (!message.isRead) {
        await updateRead(message: message);
      }
    });

    final uid = currentUser.id;
    final uds = unreads.map((u) => u.id).toList();
    print("Multiple Update");
    final value = {
      "uid": uid,
      "ids": uds,
    };
    socket.emit("read", value);
  }

  Future<void> updateRead(
      {required Message message, bool useSocket = false}) async {
    /// unique array
    final uniqueRead = [currentUser.id, ...message.readBy].toSet().toList();

    final readBody = {"readBy": uniqueRead};

    final res = await _messageAPI.updateReadStatus(message.id, readBody);

    if (res.status) {
      print("update Read ${message.id}");

      /// use socket  only single update
      if (useSocket) {
        print("Single Update");
        final value = {
          "uid": currentUser.id,
          "ids": message.id,
        };
        socket.emit("read", value);
      }
    }
  }
}
