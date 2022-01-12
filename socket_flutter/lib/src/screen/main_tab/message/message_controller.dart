import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_flutter/src/model/message.dart';
import 'package:socket_flutter/src/screen/main_tab/message/message_extention.dart';

class MessageController extends GetxController {
  final TextEditingController tc = TextEditingController();
  final ScrollController sC = ScrollController();

  final RxList<Message> messages = RxList<Message>();
  RxBool isLoading = false.obs;
  bool isFirst = true;

  /// extention
  final MessageExtention extention = Get.arguments;

  @override
  void onInit() async {
    super.onInit();
    addScrollController();
    await loadMessages();
    if (messages.isNotEmpty) sC.jumpTo(sC.position.minScrollExtent);

    listneNewChat();
  }

  @override
  void onClose() {
    sC.removeListener(() {});
    sC.dispose();
    extention.stopService();

    super.onClose();
  }

  Future<void> loadMessages() async {
    if (extention.reachLast || isLoading.value) return;

    isLoading.call(true);

    await Future.delayed(Duration(seconds: 1));

    try {
      final temp = await extention.loadMessage();

      messages.addAll(temp);
    } catch (e) {
      print(e);
      // showError(e);
    } finally {
      isLoading.call(false);

      if (isFirst) {
        isFirst = false;
      }
    }
  }

  bool checkRead(Message message) {
    /// private
    final withUser = extention.withUsers.first;
    return message.readBy.contains(withUser.id);
  }

  void addScrollController() {
    sC.addListener(() async {
      if (sC.position.pixels == sC.position.maxScrollExtent && !isFirst) {
        await loadMessages();
      }
    });
  }

  void listneNewChat() {
    extention.addNerChatListner((message) {
      messages.insert(0, message);
    });
  }

  Future<void> sendMessage() async {
    await extention.sendMessage(text: tc.text);
    tc.clear();
    _scrollToBottom();
  }

  Future<void> _scrollToBottom() async {
    await sC.animateTo(
      sC.position.minScrollExtent,
      duration: 100.milliseconds,
      curve: Curves.easeIn,
    );
  }
}
