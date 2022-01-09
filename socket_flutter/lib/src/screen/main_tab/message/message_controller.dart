import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_flutter/src/model/message.dart';
import 'package:socket_flutter/src/screen/main_tab/message/message_extention.dart';

class MessageController extends GetxController {
  final TextEditingController tc = TextEditingController();
  final ScrollController sC = ScrollController();

  final RxList<Message> messages = RxList<Message>();

  /// extention
  final MessageExtention extention = Get.arguments;

  @override
  void onInit() async {
    super.onInit();

    await loadMessages();
    sC.jumpTo(sC.position.maxScrollExtent);

    listneNewChat();
  }

  @override
  void onClose() {
    sC.dispose();
    extention.stopService();
    super.onClose();
  }

  Future<void> loadMessages() async {
    if (extention.reachLast) return;
    final temp = await extention.loadMessage();

    messages.addAll(temp);

    await _scrollToBottom();
  }

  void listneNewChat() {
    extention.addNerChatListner((message) {
      messages.add(message);
    });
  }

  Future<void> sendMessage() async {
    await extention.sendMessage(text: tc.text);
    tc.clear();
    _scrollToBottom();
  }

  Future<void> _scrollToBottom() async {
    await sC.animateTo(
      sC.position.maxScrollExtent + 100,
      duration: 100.milliseconds,
      curve: Curves.easeIn,
    );
  }
}
