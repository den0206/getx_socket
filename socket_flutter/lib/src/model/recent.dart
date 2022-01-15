import 'dart:convert';

import 'package:socket_flutter/src/model/group.dart';
import 'package:socket_flutter/src/model/user.dart';

enum RecentType { private, group }

class Recent {
  final String id;
  final String chatRoomId;
  final User user;
  User? withUser;
  Group? group;

  final String lastMessage;
  final int counter;
  final DateTime date;

  bool get isGroup {
    return withUser == null;
  }

  RecentType get type {
    if (withUser != null) {
      return RecentType.private;
    }
    return RecentType.group;
  }

  Recent({
    required this.id,
    required this.chatRoomId,
    required this.user,
    this.withUser,
    this.group,
    required this.lastMessage,
    required this.counter,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chatRoomId': chatRoomId,
      'user': user.toMap(),
      'withUser': withUser?.toMap(),
      'lastMessage': lastMessage,
      'counter': counter,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory Recent.fromMap(Map<String, dynamic> map) {
    return Recent(
      id: map['id'] ?? '',
      chatRoomId: map['chatRoomId'] ?? '',
      user: User.fromMap(map['userId']),
      withUser:
          map['withUserId'] != null ? User.fromMap(map['withUserId']) : null,
      lastMessage: map['lastMessage'] ?? '',
      counter: map['counter']?.toInt() ?? 0,
      date: DateTime.parse(map["date"]).toUtc(),
    );
  }

  String toJson() => json.encode(toMap());

  static Recent fromJsonModel(Map<String, dynamic> json) =>
      Recent.fromMap(json);

  factory Recent.fromJson(String source) => Recent.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Recent(id: $id, chatRoomId: $chatRoomId, user: $user, withUser: $withUser, lastMessage: $lastMessage, counter: $counter, date: $date)';
  }
}
