import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socket_flutter/src/model/custom_exception.dart';
import 'package:socket_flutter/src/model/message.dart';
import 'package:socket_flutter/src/screen/main_tab/message/message_extention.dart';
import 'package:socket_flutter/src/screen/main_tab/message/message_file_sheet.dart';
import 'package:socket_flutter/src/screen/main_tab/recents/recents_controller.dart';
import 'package:socket_flutter/src/screen/widget/common_dialog.dart';
import 'package:socket_flutter/src/screen/widget/loading_widget.dart';
import 'package:socket_flutter/src/service/image_extention.dart';
import 'package:socket_flutter/src/service/recent_extention.dart';
import 'package:socket_flutter/src/service/storage_service.dart';
import 'package:socket_flutter/src/utils/global_functions.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:collection/collection.dart';

class MessageController extends LoadingGetController {
  final TextEditingController tc = TextEditingController();
  final ScrollController sC = ScrollController();

  final RxList<Message> messages = RxList<Message>();
  final RxBool isLoading = false.obs;
  bool isFirst = true;

  final focusNode = FocusNode();
  final RxBool showEmoji = false.obs;
  final RxBool useRealtime = true.obs;
  final StorageService storage = StorageService.to;

  /// extention
  final MessageExtention extention = Get.arguments;

  bool get isPrivate {
    return extention.withUsers.length == 1 ? true : false;
  }

  /// translate
  final StreamController<String> streamController = StreamController();
  final RxString after = "".obs;
  final RxBool isTranslationg = false.obs;

  String searchText = "";
  Map<int, String> oldMap = {0: ""};
  Map<int, String> newMap = {0: ""};

  @override
  void onInit() async {
    super.onInit();
    extention.setTargetLanguage();
    streamText();
    addScrollController();
    await loadLocal();
    await loadMessages();
    if (messages.isNotEmpty && sC.hasClients)
      sC.jumpTo(sC.position.minScrollExtent);

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
    streamController.close();

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
      {required MessageType type,
      required String text,
      String? translated,
      File? file}) async {
    isOverlay.call(true);
    await extention.sendMessage(
        type: type, text: text, translated: translated, file: file);
    tc.clear();
    showEmoji.call(false);
    after.call("");
    isOverlay.call(false);
    _scrollToBottom();
  }

  Future<void> deleteMessage(Message message) async {
    Get.back();
    isOverlay.call(true);
    try {
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
        final recents = await re.updateRecentWithLastMessage(
            chatRoomId: message.chatRoomId);
        if (recents.isNotEmpty) {
          recents.forEach((recent) {
            RecentsController.to.recentIO.sendUpdateRecent(
                userIds: recent.user.id, chatRoomId: recent.chatRoomId);
          });
        }
      }
    } catch (e) {
      print(e.toString());
    } finally {
      isOverlay.call(false);
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

    if (text.length >= 3 && useRealtime.value) {
      isTranslationg.call(true);
      checkText();
    }
  }

  void streamText() {
    streamController.stream.debounce(Duration(seconds: 1)).listen((s) {
      // backspaceの時は呼ばない
      if (!searchText.contains(s) && useRealtime.value) checkText();

      searchText = s;
    });
  }

  Future<void> checkText() async {
    if (tc.text.length <= 3) return;

    final sep = tc.text.trim().split("\n");
    newMap = sep.asMap();

    // 改行の際は呼ばない
    if (!DeepCollectionEquality().equals(oldMap, newMap)) {
      translateText();
    }
    oldMap = newMap;
  }

  Future<void> translateText() async {
    if (extention.isSameLanguage) {
      showError("Same Language");
      useRealtime.call(false);
      return;
    }
    isTranslationg.call(true);
    try {
      final extract = extractrMap(oldMap, newMap);
      final trs = await extention.translateText(
        text: extract,
        currentTrs: after.value,
        src: extention.currentUser.mainLanguage,
        tar: extention.targetLanguage.value,
      );
      if (trs == null) {
        throw NotFoundException("Not Found");
      }
      after.call(trs);
    } catch (e) {
      print(e.toString());
    } finally {
      isTranslationg.call(false);
    }
  }
}



    // if (!isTranslationg.value) isTranslationg.call(true);
    // try {
    //   final trs = await extention.translateText(
    //     text: tc.text,
    //     src: extention.currentUser.mainLanguage,
    //     tar: extention.targetLanguage,
    //   );

  
    // } catch (e) {
    // } finally {
    //   isTranslationg.call(false);
    // }