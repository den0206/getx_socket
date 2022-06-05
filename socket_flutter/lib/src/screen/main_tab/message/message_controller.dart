import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socket_flutter/src/model/custom_exception.dart';
import 'package:socket_flutter/src/model/message.dart';
import 'package:socket_flutter/src/screen/main_tab/message/message_extention.dart';
import 'package:socket_flutter/src/screen/main_tab/message/message_file_sheet.dart';

import 'package:socket_flutter/src/screen/widget/common_dialog.dart';
import 'package:socket_flutter/src/screen/widget/loading_widget.dart';
import 'package:socket_flutter/src/service/image_extention.dart';
import 'package:socket_flutter/src/service/storage_service.dart';
import 'package:socket_flutter/src/utils/global_functions.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:collection/collection.dart';

import '../../../socket/message_io.dart';

class MessageController extends LoadingGetController {
  final TextEditingController tx = TextEditingController();
  final ScrollController sC = ScrollController();

  final RxList<Message> messages = RxList<Message>();
  final RxBool isLoading = false.obs;
  bool isFirst = true;

  final focusNode = FocusNode();
  final RxBool showEmoji = false.obs;
  final RxBool useRealtime = true.obs;
  late MessageIO _messageIO;

  /// extention
  final MessageExtention extention = Get.arguments;

  bool get isPrivate => extention.withUsers.length == 1 ? true : false;

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
    _addSocket();
    addScrollController();
    await loadLocal();
    await loadMessages();

    listnFocus();
  }

  @override
  void onClose() {
    sC.dispose();
    focusNode.dispose();

    _messageIO.destroySocket();
    streamController.close();

    super.onClose();
  }

  void _addSocket() {
    _messageIO = MessageIO(this);
    _messageIO.initSocket();

    /// new message listner
    _messageIO.addNewMessageListner();

    /// read listner
    _messageIO.addReadListner();
  }

  Future<void> loadLocal() async {
    final currentReal = await StorageKey.realtime.readBool();
    useRealtime.call(currentReal ?? true);
  }

  Future<void> loadMessages() async {
    if (extention.reachLast || isLoading.value) return;

    isLoading.call(true);

    await Future.delayed(Duration(seconds: 1));

    try {
      final temp = await extention.loadMessage();
      final unreads = await extention.updateReadList(temp);
      if (unreads.isNotEmpty) _messageIO.sendUpdateRead(unreads);

      messages.addAll(temp);
    } catch (e) {
      showError(e.toString());
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
    try {
      final newMessage = await extention.sendMessage(
          type: type, text: text, translated: translated, file: file);

      _messageIO.sendNewMessage(newMessage);
      await extention.updateLastRecent(newMessage);
      _messageIO.sendUpdateRecent(extention.userIds);
      await extention.sendNotification(newMessage: newMessage);
      showEmoji.call(false);
      after.call("");
      _scrollToBottom();
      tx.clear();
    } catch (e) {
      showError(e.toString());
    } finally {
      isOverlay.call(false);
    }
  }

  Future<void> deleteMessage(Message message) async {
    isOverlay.call(true);
    await Future.delayed(Duration(seconds: 1));
    try {
      final canDelete = await extention.deleteMessage(message);
      if (!canDelete) return;
      messages.remove(message);
      await extention.updateDeleteRecent();
    } catch (e) {
      showError(e.toString());
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

    if (messages.isNotEmpty && sC.hasClients)
      sC.jumpTo(sC.position.minScrollExtent);
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

  void readUI(String id, String uid) {
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
    tx.text = "";
    after.call("");
    useRealtime.toggle();
    await StorageKey.realtime.saveBool(useRealtime.value);
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
    if (tx.text.length <= 3) return;

    final sep = tx.text.trim().split("\n");
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
      showError((e.toString()));
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