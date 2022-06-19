import 'dart:io';

import 'package:get/state_manager.dart';
import 'package:socket_flutter/src/api/message_api.dart';
import 'package:socket_flutter/src/api/translate_api.dart';
import 'package:socket_flutter/src/model/language.dart';
import 'package:socket_flutter/src/model/message.dart';
import 'package:socket_flutter/src/model/page_feed.dart';
import 'package:socket_flutter/src/model/user.dart';
import 'package:socket_flutter/src/service/auth_service.dart';
import 'package:socket_flutter/src/service/notification_service.dart';
import 'package:socket_flutter/src/service/recent_extention.dart';

import '../../../model/recent.dart';

/// MARK  Message関連のAPI処理等を纏める

class MessageExtention {
  final String chatRoomId;
  final List<User> withUsers;

  final User currentUser = AuthService.to.currentUser.value!;
  final MessageAPI _messageAPI = MessageAPI();
  final TranslateAPI _translateAPI = TranslateAPI();
  final RecentExtention re = RecentExtention();

  Rx<Language> targetLanguage = Language.english_american.obs;

  final int limit = 10;

  bool reachLast = false;
  String? nextCursor;

  MessageExtention({
    required this.chatRoomId,
    required this.withUsers,
  });

  List<String> get userIds =>
      [currentUser.id, ...withUsers.map((u) => u.id).toList()];

  bool get isSameLanguage {
    return currentUser.mainLanguage == targetLanguage;
  }

  Future<List<Message>> loadMessage() async {
    final res = await _messageAPI.loadMessage(
        chatRoomId: chatRoomId, limit: limit, nextCursor: nextCursor);

    if (!res.status) throw Exception("Cant load messages");
    final Pages<Message> pages = Pages.fromMap(res.data, Message.fromJsonModel);

    reachLast = !pages.pageInfo.hasNextPage;
    nextCursor = pages.pageInfo.nextPageCursor;

    return pages.pageFeeds;
  }

  Future<Message> sendMessage({
    required MessageType type,
    required String text,
    String? translated,
    File? file,
  }) async {
    final Map<String, dynamic> messageData = {
      "chatRoomId": chatRoomId,
      "text": text,
      "translated": translated != "" ? translated : null,
      "userId": currentUser.id,
    };

    try {
      var res;

      switch (type) {
        case MessageType.text:
          res = await _messageAPI.sendMessage(message: messageData);
          break;
        case MessageType.image:
          if (file == null) throw Exception("File Error");
          ;

          res = await _messageAPI.sendImageMessage(
            message: messageData,
            file: file,
          );
          break;
        case MessageType.video:
          if (file == null) throw Exception("File Error");
          res = await _messageAPI.sendVideoMessage(
            message: messageData,
            videoFile: file,
          );
      }

      if (!res.status) throw Exception("API Error");

      final message = Message.fromMapWithUser(res.data, currentUser);

      return message;
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateLastRecent(Message newMessage) async {
    final existUsers = await updateRecent(
        chatRoomId: chatRoomId, lastMessage: newMessage.text);

    /// Recent が消されているユーザーを求める
    final deleteUsers = userIds.toSet().difference(existUsers.toSet()).toList();
    if (deleteUsers.isNotEmpty) {
      print("RECREATE Recents $deleteUsers!");

      /// ReCreate New Recent
      final allUsers = [currentUser, ...withUsers];
      await Future.forEach(deleteUsers, (String id) async {
        await re.createRecentAPI(id, currentUser.id, allUsers, chatRoomId);
      });
    }
  }

  Future<void> sendNotification({required Message newMessage}) async {
    final tokens = withUsers.map((u) => u.fcmToken).toList();
    await NotificationService.to
        .pushNotification(tokens: tokens, lastMessage: newMessage.text);
  }

  /// MARK Delete Message
  Future<void> updateDeleteRecent() async {
    final remainRecents =
        await re.updateRecentWithLastMessage(chatRoomId: chatRoomId);

    if (remainRecents.isNotEmpty) {
      remainRecents.forEach((Recent recent) {
        re.updateRecentSocket(userId: recent.user.id, chatRoomId: chatRoomId);
      });
    }
  }

  Future<bool> deleteMessage(Message message) async {
    if (!message.isCurrent) throw Exception("Not Math userId");
    try {
      final res = await _messageAPI.deleteMessage(message.id);
      if (!res.status) throw Exception("Not Delete message");
      return res.status;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// MARK Recent Status

  Future<List<String>> updateRecent(
      {required String chatRoomId, required String lastMessage}) async {
    final updated = await re.updateRecentWithLastMessage(
        chatRoomId: chatRoomId, lastMessage: lastMessage);

    return updated.map((r) => r.user.id).toList();
  }

  /// MARK Read Status

  Future<List<String>> updateReadList(List<Message> messages) async {
    /// unread を絞り出す
    final unreads = messages
        .where((message) => !message.isRead && !message.isCurrent)
        .toList();
    if (unreads.isEmpty) return [];
    await Future.forEach(unreads, (Message message) async {
      if (!message.isRead) await updateRead(message: message);
    });

    return unreads.map((u) => u.id).toList();
  }

  Future<void> updateRead(
      {required Message message, bool useSocket = false}) async {
    final uniqueRead = [currentUser.id, ...message.readBy].toSet().toList();
    final body = {
      "messageId": message.id,
      "readBy": uniqueRead,
    };

    final res = await _messageAPI.updateMessage(body);

    if (!res.status) throw Exception("not update read");
  }
}

// translate
extension MessageExtTranslation on MessageExtention {
  Future<String?> translateText(
      {required Map<int, String> text,
      required String currentTrs,
      required Language src,
      required Language tar}) async {
    final res =
        await _translateAPI.getTranslate(text: text, src: src, tar: tar);

    if (!res.status) return null;

    final data = Map.from(res.data);
    // <int,String> へcast
    final Map<int, String> current = {};
    data.entries.forEach((map) => {current[int.parse(map.key)] = map.value});
    print("今回の翻訳 ${current}");

    // 翻訳済みのテキストを段落つきのmapへ
    final alreadyTrs = currentTrs.trim().split("\n").asMap();

    var newMap = Map.of(alreadyTrs);
    current.entries.forEach((element) {
      newMap[element.key] = element.value;
    });

    var temp = "";
    newMap.entries.forEach((element) {
      temp += element.value;
      if (element.key != newMap.keys.last) temp += "\n";
    });

    return temp;
  }

  void setTargetLanguage({Language? language}) {
    Language current;
    if (language == null) {
      current = withUsers.length == 1
          ? withUsers[0].mainLanguage
          : Language.english_american;
    } else {
      current = language;
    }

    this.targetLanguage.call(current);
  }
}
