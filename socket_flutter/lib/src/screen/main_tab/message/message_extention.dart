import 'package:socket_flutter/src/api/message_api.dart';
import 'package:socket_flutter/src/model/message.dart';
import 'package:socket_flutter/src/model/page_feed.dart';
import 'package:socket_flutter/src/model/recent.dart';
import 'package:socket_flutter/src/model/user.dart';
import 'package:socket_flutter/src/service/auth_service.dart';
import 'package:socket_flutter/src/service/recent_extention.dart';
import 'package:socket_flutter/src/utils/enviremont.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

class MessageExtention {
  final String chatRoomId;
  final List<User> withUsers;

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
    final unreads =
        pages.pageFeeds.where((message) => message.isRead == false).toList();

    if (unreads.isNotEmpty) await updateReadLists(unreads);

    reachLast = !pages.pageInfo.hasNextPage;
    nextCursor = pages.pageInfo.nextPageCursor;

    print(reachLast);

    final temp = pages.pageFeeds;

    return temp;
  }

  void addNerChatListner(Function(Message message) listner) {
    socket.on("message-receive", (data) {
      // print(data);
      final newMessage = Message.fromMap(data);

      listner(newMessage);
    });
  }

  Future<void> sendMessage({required String text}) async {
    final User currentUser = AuthService.to.currentUser.value!;
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

  /// MARK Recent Status

  Future<List<String>> updateRecent(
      {required String chatRoomId, required String lastMessage}) async {
    final recents = await re.findByChatRoomId(chatRoomId);

    if (recents.isNotEmpty) {
      await Future.forEach(recents, (Recent recent) async {
        await re.updateRecentItem(recent, lastMessage);
      });
    }

    return recents.map((r) => r.user.id).toList();
  }

  /// MARK Read Status

  Future<void> updateReadLists(List<Message> unreads) async {
    print("-----Update READ!!");

    /// userId && unreads socket

    Future.forEach(unreads, (Message message) async {
      if (!message.isRead) {
        await updateRead(message);
      }
    });
  }

  Future<void> updateRead(Message message) async {
    final User currentUser = AuthService.to.currentUser.value!;

    /// unique array
    final uniqueRead = [currentUser.id, ...message.readBy].toSet().toList();

    final readBody = {"readBy": uniqueRead};

    final res = await _messageAPI.updateReadStatus(message.id, readBody);

    if (res.status) {
      print("update Read ${message.id}");

      /// use socket
    }
  }
}
