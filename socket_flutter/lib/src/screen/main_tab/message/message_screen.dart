import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:socket_flutter/src/screen/main_tab/message/message_controller.dart';

class MessageScreen extends GetView<MessageController> {
  const MessageScreen({Key? key}) : super(key: key);

  static const routeName = '/MessageScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chats"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return Text("Sample");
              },
            ),
          ),
          _messageInput(context)
        ],
      ),
    );
  }

  Widget _messageInput(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14),
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 3),
                      blurRadius: 5,
                      color: Colors.black,
                    )
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.emoji_emotions_outlined),
                      color: Colors.grey[500],
                      onPressed: () {
                        print("Emoji");
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: TextField(
                      controller: controller.tc,
                      decoration: InputDecoration(
                        hintText: "Message...",
                        border: InputBorder.none,
                      ),
                    )),
                    IconButton(
                      onPressed: () {
                        print("Show");
                      },
                      icon: Icon(Icons.attach_file, color: Colors.grey[500]),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 16,
            ),
            FloatingActionButton(
              child: Icon(
                Icons.send,
                color: Colors.white,
                size: 18,
              ),
              backgroundColor: Colors.green,
              elevation: 0,
              onPressed: () {
                if (controller.tc.text.isEmpty) {
                  return null;
                } else {
                  FocusScope.of(context).unfocus();
                  controller.sendMessage();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
