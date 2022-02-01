import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socket_flutter/src/model/country.dart';
import 'package:socket_flutter/src/model/message.dart';
import 'package:socket_flutter/src/screen/main_tab/message/message_extention.dart';
import 'package:socket_flutter/src/screen/main_tab/message/message_file_sheet.dart';
import 'package:socket_flutter/src/screen/main_tab/recents/recents_controller.dart';
import 'package:socket_flutter/src/service/image_extention.dart';
import 'package:socket_flutter/src/service/recent_extention.dart';
import 'package:socket_flutter/src/service/storage_service.dart';

class MessageController extends GetxController {
  final TextEditingController tc = TextEditingController();
  final ScrollController sC = ScrollController();

  final RxList<Message> messages = RxList<Message>();

  final RxBool isLoading = false.obs;
  bool isFirst = true;

  final focusNode = FocusNode();
  final RxBool showEmoji = false.obs;

  /// extention
  final MessageExtention extention = Get.arguments;

  /// translate
  final StorageService storage = StorageService.to;
  final RxString before = "".obs;
  final RxString after = "".obs;
  final RxBool isTranslationg = false.obs;
  final RxBool useRealtime = true.obs;
  Timer? _trsTimer;

  @override
  void onInit() async {
    super.onInit();
    addScrollController();
    await loadLocal();
    await loadMessages();
    if (messages.isNotEmpty) sC.jumpTo(sC.position.minScrollExtent);

    listnFocus();
    listneNewChat();
    listenReadStatus();
  }

  @override
  void onClose() {
    sC.removeListener(() {});
    sC.dispose();
    focusNode.dispose();
    extention.stopService();
    _trsTimer?.cancel();

    super.onClose();
  }

  Future<void> loadLocal() async {
    final currentReal = await storage.readBool(StorageKey.realtime);
    if (currentReal == null) {
      useRealtime.call(true);
    } else {
      useRealtime.call(currentReal);
    }
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

  Future<void> sendMessage(
      {required MessageType type, required String text, File? file}) async {
    await extention.sendMessage(type: type, text: text, file: file);
    tc.clear();
    showEmoji.call(false);
    _scrollToBottom();
  }

  Future<void> deleteMessage(Message message) async {
    final action = await extention.delete(message.id);
    if (action) {
      // BUG indexlast のメッセージを削除するとクラッシュ

      final index = messages.indexOf(message);
      if (index == messages.length) {
        print("Call");
        return;
      } else {
        messages.remove(message);
      }
      final re = RecentExtention();

      /// last message is "Deleted"
      final recents =
          await re.updateRecentWithLastMessage(chatRoomId: message.chatRoomId);
      if (recents.isNotEmpty) {
        recents.forEach((recent) {
          RecentsController.to.recentIO.sendUpdateRecent(
              userIds: recent.user.id, chatRoomId: recent.chatRoomId);
        });
      }
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

  void showBottomSheet() {
    final imageExtention = ImageExtention();
    final List<MessageFileButton> actions = [
      MessageFileButton(
        icon: Icons.camera,
        onPress: () {
          print("Camera");
        },
      ),
      MessageFileButton(
        icon: Icons.image,
        onPress: () async {
          final selectedImage = await imageExtention.selectImage(
              imageSource: ImageSource.gallery);

          if (selectedImage != null) {
            sendMessage(
                type: MessageType.image, text: "image", file: selectedImage);
            Get.back();
          }
        },
      ),
      MessageFileButton(
        icon: Icons.videocam,
        onPress: () async {
          final selectedVideo = await imageExtention.selectVideo();
          if (selectedVideo != null) {
            sendMessage(
                type: MessageType.video, text: "video", file: selectedVideo);
            Get.back();
          }
        },
      ),
      MessageFileButton(
        icon: Icons.close,
        onPress: () {
          Get.back();
        },
      ),
    ];
    Get.bottomSheet(
      MessageFileSheet(actions: actions),
      backgroundColor: Colors.white,
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

  void listnFocus() {
    focusNode.addListener(
      () {
        if (focusNode.hasFocus) {
          showEmoji.call(false);
        }
      },
    );
  }

  Future<void> toggleReal() async {
    tc.text = "";
    after.call("");
    useRealtime.toggle();
    await storage.saveBool(StorageKey.realtime, useRealtime.value);
  }

  void onChangeText(String text) {
    after.call("");

    _trsTimer?.cancel();

    if (text.length >= 3 && useRealtime.value) {
      isTranslationg.call(true);
      _trsTimer = Timer(Duration(seconds: 1), () async {
        translateText();
      });
    }
  }

  Future<void> translateText() async {
    if (tc.text.length <= 3) return;
    if (!isTranslationg.value) isTranslationg.call(true);
    try {
      final trs = await extention.translateText(
          text: tc.text, src: Country.japanese, tar: Country.english);

      if (trs == null) return;
      after.call(trs);
    } catch (e) {
    } finally {
      isTranslationg.call(false);
    }
  }
}
