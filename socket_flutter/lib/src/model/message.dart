import 'dart:convert';

import 'package:socket_flutter/src/model/user.dart';
import 'package:socket_flutter/src/service/auth_service.dart';
import 'package:socket_flutter/src/utils/date_format.dart';

class Message {
  final String id;
  final String chatRoomId;
  final String text;
  final User user;
  final DateTime date;

  bool get isCurrent {
    final currentUser = AuthService.to.currentUser.value;
    if (currentUser == null) return false;
    return this.user.id == currentUser.id;
  }

  String get formattedTime {
    return DateFormatter.getVerBoseDateString(date);
  }

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
      'userId': user.toMap(),
      'date': date.toIso8601String(),
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
