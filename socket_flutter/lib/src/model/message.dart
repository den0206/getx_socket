import 'dart:convert';

import 'package:socket_flutter/src/model/user.dart';

class Message {
  final String id;
  final String chatRoomId;
  final String text;
  final User user;
  final DateTime date;

  Message({
    required this.id,
    required this.chatRoomId,
    required this.text,
    required this.user,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chatRoomId': chatRoomId,
      'text': text,
      'user': user.toMap(),
      'dateTime': date.millisecondsSinceEpoch,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] ?? '',
      chatRoomId: map['chatRoomId'] ?? '',
      text: map['text'] ?? '',
      user: User.fromMap(map['userId']),
      date: DateTime.parse(map["date"]).toUtc(),
    );
  }

  factory Message.fromMapWithUser(Map<String, dynamic> map, User user) {
    return Message(
      id: map['id'] ?? '',
      chatRoomId: map['chatRoomId'] ?? '',
      text: map['text'] ?? '',
      user: user,
      date: DateTime.parse(map["date"]).toUtc(),
    );
  }

  String toJson() => json.encode(toMap());

  static Message fromJsonModel(Map<String, dynamic> json) =>
      Message.fromMap(json);

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Message(id: $id, chatRoomId: $chatRoomId, text: $text, user: $user, date: $date)';
  }
}
