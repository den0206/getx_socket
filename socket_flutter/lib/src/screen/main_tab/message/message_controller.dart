import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_flutter/src/model/message.dart';
import 'package:socket_flutter/src/screen/main_tab/message/message_extention.dart';
import 'package:socket_flutter/src/service/recent_extention.dart';

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
    listenReadStatus();
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

  Future<void> sendMessage() async {
    await extention.sendMessage(text: tc.text);
    tc.clear();
    _scrollToBottom();
  }

  Future<void> deleteMessage(Message message) async {
    final action = await extention.delete(message.id);
    if (action) {
      // BUG index0 のメッセージを削除するとクラッシュ

      messages.remove(message);

      final re = RecentExtention();

      /// last message is "Deleted"
      await re.updateRecentWithLastMessage(chatRoomId: message.chatRoomId);
      Get.back();
    }
  }

  bool checkRead(Message message) {
    /// private
    final withUser = extention.withUsers.first;
    return message.readBy.contains(withUser.id);
  }

  /// MARK Scroll Controler

  void addScrollController() {
    sC.addListener(() async {
      if (sC.position.pixels == sC.position.maxScrollExtent && !isFirst) {
        await loadMessages();
      }
    });
  }

  Future<void> _scrollToBottom() async {
    await sC.animateTo(
      sC.position.minScrollExtent,
      duration: 100.milliseconds,
      curve: Curves.easeIn,
    );
  }

  /// MARK Listners

  void listneNewChat() {
    extention.addNerChatListner((message) {
      messages.insert(0, message);
    });
  }

  void listenReadStatus() {
    extention.addReadListner((value) {
      final uid = value["uid"];
      final ids = value["ids"];

      if (ids is List) {
        /// update multiple read
        final List<String> temp = List.castFrom(ids);

        temp.forEach((String id) {
          _readUI(id, uid);
        });
      }

      if (ids is String) {
        /// single read
        _readUI(ids, uid);
      }
    });
  }

  void _readUI(String id, String uid) {
    final messageIds = messages.map((m) => m.id).toList();
    if (messageIds.contains(id)) {
      final index = messageIds.indexOf(id);
      final temp = messages[index];
      temp.readBy.add(uid);

      /// update Reactive
      messages[index] = temp;
    }
  }
}
