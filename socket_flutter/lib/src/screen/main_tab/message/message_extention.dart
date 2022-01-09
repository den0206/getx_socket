import 'package:socket_flutter/src/api/message_api.dart';
import 'package:socket_flutter/src/model/message.dart';
import 'package:socket_flutter/src/model/page_feed.dart';
import 'package:socket_flutter/src/model/user.dart';
import 'package:socket_flutter/src/service/auth_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

class MessageExtention {
  final String chatRoomId;
  final List<User> withUsers;

  final MessageAPI _messageAPI = MessageAPI();
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
      'http://localhost:3000',
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

    reachLast = !pages.pageInfo.hasNextPage;
    nextCursor = pages.pageInfo.nextPageCursor;

    print(reachLast);

    final temp = pages.pageFeeds.reversed.toList();

    return temp;
  }

  void addNerChatListner(Function(Message message) listner) {
    socket.on("message-receive", (data) {
      print(data);
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
  }
}
