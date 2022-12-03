import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:socket_flutter/src/model/language.dart';
import 'package:socket_flutter/src/service/auth_service.dart';
import 'package:socket_flutter/src/utils/global_functions.dart';

class User {
  final String id;
  String name;
  final String email;
  final CountryCode country;
  Language mainLanguage;

  String fcmToken;
  List<String> blockedUsers;
  String? avatarUrl;
  String? sessionToken;

  String searchId;

  bool get isCurrent {
    final currentUser = AuthService.to.currentUser.value;
    if (currentUser == null) return false;
    return currentUser.id == id;
  }

  bool checkBlock(User user) {
    return blockedUsers.contains(user.id);
  }

  bool canContact(User user) {
    return blockedUsers.contains(user.id) || user.blockedUsers.contains(id);
  }

  List<String> get excludeIds {
    // flatmap
    return [
      blockedUsers,
      [id]
    ].expand((element) => element).toList();
  }

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.country,
    required this.mainLanguage,
    required this.blockedUsers,
    required this.fcmToken,
    required this.searchId,
    this.avatarUrl,
    this.sessionToken,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      "countryCode": country.code,
      "fcmToken": fcmToken,
      "mainLanguage": mainLanguage.name,
      "blocked": blockedUsers,
      "avatarUrl": avatarUrl,
      "searchId": searchId,
      'sessionToken': sessionToken,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      country: getCountryFromCode(map["countryCode"] ?? "US"),
      mainLanguage: getLanguage(map["mainLanguage"] ?? "EN"),
      fcmToken: map["fcmToken"] ?? "",
      searchId: map["searchId"] ?? map["id"],
      blockedUsers: List<String>.from(map["blocked"] ?? []),
      avatarUrl: httpsToHttp(value: map["avatarUrl"]),
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
    String? fcmToken,
    String? searchId,
    List<String>? blockedUsers,
    String? avatarUrl,
    String? sessionToken,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      country: country,
      mainLanguage: mainLanguage,
      fcmToken: fcmToken ?? this.fcmToken,
      searchId: searchId ?? this.searchId,
      blockedUsers: blockedUsers ?? this.blockedUsers,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      sessionToken: sessionToken ?? this.sessionToken,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, country: $country, mainLanguage: $mainLanguage, fcmToken: $fcmToken, blockedUsers: $blockedUsers, avatarUrl: $avatarUrl, sessionToken: $sessionToken, searchId: $searchId)';
  }
}

ImageProvider getUserImage(User user) {
  if (user.avatarUrl == null) {
    return Image.asset("assets/images/default_user.png").image;
  } else {
    return CachedNetworkImageProvider(user.avatarUrl!);
  }
}

ImageProvider getCountryFlag(CountryCode country) {
  return Image.asset(
    country.flagUri!,
    package: 'country_list_pick',
  ).image;
}
