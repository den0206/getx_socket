import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends GetxService {
  static StorageService get to => Get.find();
  late SharedPreferences storage;

  Future<void> initStorage() async {
    storage = await SharedPreferences.getInstance();
  }

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

  Future<bool> deleteLocal(StorageKey key) async {
    return await storage.remove(key.keyString);
  }
}

enum StorageKey {
  user,
  barcodeNo,
}

extension StorageKeyEXT on StorageKey {
  String get keyString {
    switch (this) {
      case StorageKey.user:
        return "user";
      case StorageKey.barcodeNo:
        return "barcodeNo";
    }
  }
}
