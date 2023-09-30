import 'package:get/get.dart';
import 'package:socket_flutter/src/model/user.dart';
import 'package:socket_flutter/src/screen/main_tab/main_tab_controller.dart';
import 'package:socket_flutter/src/screen/main_tab/recents/recents_controller.dart';
import 'package:socket_flutter/src/screen/main_tab/report/report_controller.dart';
import 'package:socket_flutter/src/service/storage_service.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find();
  final Rxn<User> currentUser = Rxn<User>();

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

    final value = await StorageKey.user.loadString();
    if (value == null) return;

    currentUser.call(User.fromMap(value));
    print(currentUser.value.toString());
  }

  Future<void> updateUser(User newUser) async {
    newUser.sessionToken ??= currentUser.value!.sessionToken;

    // set home
    await StorageKey.user.saveString(newUser.toMap());
    // set login email(String)
    await StorageKey.loginEmail.saveString(newUser.email);

    currentUser.call(newUser);
  }

  Future<void> logout() async {
    await Get.delete<RecentsController>();
    await Get.delete<MainTabController>();

    if (Get.isRegistered<ReportController>()) {
      await Get.delete<ReportController>();
    }

    await StorageKey.user.deleteLocal();
    currentUser.value = null;
  }
}
