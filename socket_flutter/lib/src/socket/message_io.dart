import 'package:socket_flutter/src/model/message.dart';
import 'package:socket_flutter/src/socket/socket_base.dart';

import '../screen/main_tab/message/message_controller.dart';
import '../screen/main_tab/message/message_extention.dart';

class MessageIO extends SocketBase {
  @override
  NameSpace get nameSpace => NameSpace.message;
  @override
  Map<String, dynamic> get query => {"chatRoomId": chatRoomId};

  final MessageController controller;
  MessageIO(this.controller);

  MessageExtention get extention => controller.extention;
  String get chatRoomId => extention.chatRoomId;

  //受信
  void addNewMessageListner() {
    socket.on("new_message", (msg) {
      final newMessage = Message.fromMap(msg);

      if (!newMessage.isCurrent) {
        extention.updateRead(message: newMessage);
        sendUpdateRead([newMessage.id]);
      }

      controller.messages.insert(0, newMessage);
    });
  }

  void addReadListner() {
    socket.on("read", (value) {
      final uid = value["uid"];
      final ids = value["ids"];
      final List<String> temp = List.castFrom(ids);
      temp.forEach((String id) => controller.readUI(id, uid));
    });
  }

  /// 送信
  void sendNewMessage(Message message) {
    socket.emit("new_message", message.toMap());
  }

  void sendUpdateRead(List<String> messageIds) {
    final data = {"uid": extention.currentUser.id, "ids": messageIds};
    socket.emit("read", data);
  }

  void sendUpdateRecent(List<String> userIds) {
    final Map<String, dynamic> data = {
      "chatRoomId": chatRoomId,
      "userIds": userIds,
    };

    socket.emit("update_recent", data);
  }
}
