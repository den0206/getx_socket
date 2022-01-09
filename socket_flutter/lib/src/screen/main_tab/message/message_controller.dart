import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_flutter/src/model/message.dart';
import 'package:socket_flutter/src/screen/main_tab/message/message_extention.dart';
import 'package:socket_flutter/src/screen/widget/common_dialog.dart';

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
    sC.jumpTo(sC.position.maxScrollExtent);

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
    if (extention.reachLast) return;

    isLoading.call(true);

    await Future.delayed(Duration(seconds: 1));

    try {
      final temp = await extention.loadMessage();

      if (!isFirst) {
        messages.insertAll(0, temp);
      } else {
        messages.addAll(temp);
      }
    } catch (e) {
      showError(e);
    } finally {
      isLoading.call(false);

      if (isFirst) {
        await _scrollToBottom();
        isFirst = false;
      }
    }
  }

  void addScrollController() {
    sC.addListener(() async {
      if (sC.position.pixels == sC.position.minScrollExtent && !isFirst) {
        await loadMessages();
      }
    });
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
