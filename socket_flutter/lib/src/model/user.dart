import 'dart:convert';

import 'package:socket_flutter/src/service/auth_service.dart';

class User {
  final String id;
  final String name;
  final String email;

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
    this.sessionToken,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'sessionToken': sessionToken,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      sessionToken: map['sessionToken'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  static User fromJsonModel(Map<String, dynamic> json) => User.fromMap(json);
}
