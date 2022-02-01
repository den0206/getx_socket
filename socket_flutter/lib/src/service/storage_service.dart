import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends GetxService {
  static StorageService get to => Get.find();
  late SharedPreferences storage;

  Future<void> initStorage() async {
    storage = await SharedPreferences.getInstance();
  }

  // String
  Future<void> saveLocal(StorageKey key, dynamic value) async {
    final encoded = json.encode(value);

    await storage.setString(key.keyString, encoded);
  }

  Future<dynamic> readLocal(StorageKey key) async {
    final value = await storage.getString(key.keyString);
    if (value == null) {
      print("No Local Storage");
      return null;
    }
    final decoded = json.decode(value);
    return decoded;
  }

  // Bool
  Future<void> saveBool(StorageKey key, bool value) async {
    await storage.setBool(key.keyString, value);
  }

  Future<bool?> readBool(StorageKey key) async {
    final value = storage.getBool(key.keyString);
    if (value == null) {
      return null;
    }
    return value;
  }

  Future<bool> deleteLocal(StorageKey key) async {
    return await storage.remove(key.keyString);
  }
}

enum StorageKey {
  user,
  realtime,
}

extension StorageKeyEXT on StorageKey {
  String get keyString {
    switch (this) {
      case StorageKey.user:
        return "user";
      case StorageKey.realtime:
        return "realtime";
    }
  }
}
