import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

enum StorageKey {
  user,
  realtime,
  fcmToken,
  checkTerms,
  locale;

  String get keyString {
    switch (this) {
      case StorageKey.user:
        return "user";
      case StorageKey.realtime:
        return "realtime";
      case StorageKey.fcmToken:
        return "fcmToken";
      case StorageKey.checkTerms:
        return "checkTerms";
      case StorageKey.locale:
        return "locale";
    }
  }

  Future<bool> saveString(dynamic value) async {
    final pref = await SharedPreferences.getInstance();
    final encoded = json.encode(value);
    return await pref.setString(keyString, encoded);
  }

  Future<dynamic> loadString() async {
    final pref = await SharedPreferences.getInstance();
    final value = pref.getString(keyString);
    if (value == null) {
      print("No Local Storage");
      return null;
    }
    final decoded = json.decode(value);
    return decoded;
  }

  Future<bool> saveBool(bool value) async {
    final pref = await SharedPreferences.getInstance();
    return await pref.setBool(keyString, value);
  }

  Future<bool?> loadBool() async {
    final pref = await SharedPreferences.getInstance();
    final value = pref.getBool(keyString);
    return value;
  }

  Future<bool> deleteLocal() async {
    final pref = await SharedPreferences.getInstance();
    return await pref.remove(keyString);
  }
}
