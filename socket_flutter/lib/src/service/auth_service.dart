import 'package:get/get.dart';

import 'package:socket_flutter/src/model/user.dart';
import 'package:socket_flutter/src/screen/main_tab/recents/recents_controller.dart';
import 'package:socket_flutter/src/service/storage_service.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find();
  final Rxn<User> currentUser = Rxn<User>();
  final StorageService storage = StorageService.to;

  @override
  void onInit() async {
    super.onInit();
    await loadUser();
  }

  @override
  void onClose() {
    super.onClose();
    print("Destroy AUTH");
  }

  Future<void> loadUser() async {
    if (currentUser.value != null) return;
    final value = await storage.readLocal(StorageKey.user);
    print(value);
    if (value == null) return;

    this.currentUser.call(User.fromMap(value));
  }

  Future<void> logout() async {
    await Get.delete<RecentsController>();

    await storage.deleteLocal(StorageKey.user);
    this.currentUser.value = null;
  }
}
