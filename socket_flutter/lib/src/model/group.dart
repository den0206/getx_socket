import 'dart:convert';

import 'package:socket_flutter/src/model/user.dart';
import 'package:socket_flutter/src/service/auth_service.dart';

class Group {
  final String id;
  final String ownerId;
  final String? title;
  final List<User> members;

  bool get isOwner {
    final currentUser = AuthService.to.currentUser.value;
    if (currentUser == null) return false;
    return ownerId == currentUser.id;
  }

  Group({
    required this.id,
    required this.ownerId,
    required this.members,
    this.title,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ownerId': ownerId,
      'title': title,
      'members': members.map((x) => x.toMap()).toList(),
    };
  }

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      id: map['id'] ?? '',
      ownerId: map['ownerId'] ?? '',
      title: map['title'],
      members: List<User>.from(map['members']?.map((x) => User.fromMap(x))),
    );
  }

  /// MARK 初期化(with members)
  factory Group.fromMapWithMembers(
    Map<String, dynamic> map,
    List<User> members,
  ) {
    return Group(
      id: map['id'] ?? '',
      ownerId: map['ownerId'] ?? '',
      title: map['title'],
      members: members,
    );
  }

  String toJson() => json.encode(toMap());

  factory Group.fromJson(String source) => Group.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Group(id: $id, ownerId: $ownerId, title: $title, members: $members)';
  }
}
