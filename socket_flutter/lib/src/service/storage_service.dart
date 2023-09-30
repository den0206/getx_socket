import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

enum StorageKey {
  user,
  realtime,
  fcmToken,
  checkTerms,
  locale,
  loginEmail;

  Future<bool> saveString(dynamic value) async {
    final pref = await SharedPreferences.getInstance();
    final encoded = json.encode(value);
    return await pref.setString(name, encoded);
  }

  Future<dynamic> loadString() async {
    final pref = await SharedPreferences.getInstance();
    final value = pref.getString(name);
    if (value == null) {
      print("No Local Storage");
      return null;
    }
    final decoded = json.decode(value);
    return decoded;
  }

  Future<bool> saveBool(bool value) async {
    final pref = await SharedPreferences.getInstance();
    return await pref.setBool(name, value);
  }

  Future<bool?> loadBool() async {
    final pref = await SharedPreferences.getInstance();
    final value = pref.getBool(name);
    return value;
  }

  Future<bool> deleteLocal() async {
    final pref = await SharedPreferences.getInstance();
    return await pref.remove(name);
  }
}
