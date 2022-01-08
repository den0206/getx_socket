import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:socket_flutter/src/model/chat.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

class ChatController extends GetxController {
  final TextEditingController textController = TextEditingController();
  late IO.Socket socket;

  final String chatRoomId = "sample";

  final messages = RxList<Chat>();

  @override
  void onInit() {
    super.onInit();
    _initSocket();
  }

  _initSocket() {
    socket = IO.io(
      'http://localhost:3000',
      OptionBuilder()
          .setTransports(['websocket']) //
          .setQuery({"chatID": chatRoomId})
          .disableAutoConnect() // disable auto-connection
          .build(),
    );
    setupSocketListner();

    socket.connect();
  }

  void setupSocketListner() {
    socket.on("message-receive", (data) {
      final newMewssage = Chat.fromMap(data);
      print(newMewssage);
      messages.add(newMewssage);
    });
  }

  void sendMessage() {
    if (socket.id == null) return;
    final message = Chat(chatRoomId, textController.text);

    socket.emit(
      "message",
      message.toMap(),
    );

    // messages.add(message);
    textController.text = "";
  }
}
