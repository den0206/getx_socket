import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_flutter/src/screen/main_tab/message/message_extention.dart';

class MessageController extends GetxController {
  final TextEditingController tc = TextEditingController();

  /// extention
  final MessageExtention extention = Get.arguments;

  @override
  void onInit() async {
    super.onInit();

    await loadMessages();
  }

  Future<void> loadMessages() async {
    if (extention.reachLast) return;
    final temp = await extention.loadMessage();

    print(temp.length);
  }

  Future<void> sendMessage() async {
    await extention.sendMessage(text: tc.text);
  }
}
