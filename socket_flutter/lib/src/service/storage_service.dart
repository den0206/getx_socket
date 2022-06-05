import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

enum StorageKey {
  user,
  realtime,
  fcmToken;

  String get keyString {
    switch (this) {
      case StorageKey.user:
        return "user";
      case StorageKey.realtime:
        return "realtime";
      case StorageKey.fcmToken:
        return "fcmToken";
    }
  }

  Future<bool> saveString(dynamic value) async {
    final pref = await SharedPreferences.getInstance();
    final encoded = json.encode(value);
    return await pref.setString(this.keyString, encoded);
  }

  Future<dynamic> loadString() async {
    final pref = await SharedPreferences.getInstance();
    final value = await pref.getString(this.keyString);
    if (value == null) {
      print("No Local Storage");
      return null;
    }
    final decoded = json.decode(value);
    return decoded;
  }

  Future<bool> saveBool(bool value) async {
    final pref = await SharedPreferences.getInstance();
    return await pref.setBool(this.keyString, value);
  }

  Future<bool?> readBool() async {
    final pref = await SharedPreferences.getInstance();
    final value = await pref.getBool(this.keyString);
    return value ?? null;
  }

  Future<bool> deleteLocal() async {
    final pref = await SharedPreferences.getInstance();
    return await pref.remove(keyString);
  }
}
