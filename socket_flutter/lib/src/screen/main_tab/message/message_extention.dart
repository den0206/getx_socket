import 'package:socket_flutter/src/api/message_api.dart';
import 'package:socket_flutter/src/model/message.dart';
import 'package:socket_flutter/src/model/user.dart';
import 'package:socket_flutter/src/service/auth_service.dart';

class MessageExtention {
  final String chatRoomId;
  final List<User> withUsers;

  final MessageAPI _messageAPI = MessageAPI();

  MessageExtention({
    required this.chatRoomId,
    required this.withUsers,
  });

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

    print(message);
  }
}
