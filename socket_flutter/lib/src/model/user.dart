import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:socket_flutter/src/service/auth_service.dart';

class User {
  final String id;
  String name;
  final String email;

  String? avatarUrl;
  String? sessionToken;

  bool get isCurrent {
    final currentUser = AuthService.to.currentUser.value;
    if (currentUser == null) return false;
    return currentUser.id == this.id;
  }

  User({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.sessionToken,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      "avatarUrl": avatarUrl,
      'sessionToken': sessionToken,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      avatarUrl: map["avatarUrl"],
      sessionToken: map['sessionToken'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  static User fromJsonModel(Map<String, dynamic> json) => User.fromMap(json);

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    String? sessionToken,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      sessionToken: sessionToken ?? this.sessionToken,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, avatarUrl: $avatarUrl, sessionToken: $sessionToken)';
  }
}

ImageProvider getUserImage(User user) {
  if (user.avatarUrl == null) {
    return Image.asset("assets/images/default_user.png").image;
  } else {
    return NetworkImage(user.avatarUrl!);
  }
}
