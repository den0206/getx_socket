import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:socket_flutter/src/model/message.dart';
import 'package:socket_flutter/src/screen/chat/chat_controller.dart';

class ChatScreen extends GetView<ChatController> {
  const ChatScreen({Key? key}) : super(key: key);
  static const routeName = '/ChatScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Column(
          children: [
            Expanded(
              flex: 9,
              child: Container(
                child: Obx(() => ListView.builder(
                      itemCount: controller.messages.length,
                      itemBuilder: (BuildContext context, int index) {
                        final message = controller.messages[index];

                        return MessageCell(message: message);
                      },
                    )),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(10),
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  controller: controller.textController,
                  decoration: InputDecoration(
                    suffixIcon: Container(
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          controller.sendMessage();
                        },
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageCell extends StatelessWidget {
  const MessageCell({Key? key, required this.message}) : super(key: key);

  final Message message;

  bool get isCurrentUser {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final ts = TextStyle(color: Colors.white);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      margin: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isCurrentUser ? Colors.green : Colors.grey,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment:
            isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Text(
            message.text,
            style: ts.copyWith(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
