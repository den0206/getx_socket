import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_flutter/src/api/user_api.dart';
import 'package:socket_flutter/src/model/response_api.dart';
import 'package:socket_flutter/src/model/user.dart';
import 'package:socket_flutter/src/screen/auth/signup/signup_screen.dart';
import 'package:socket_flutter/src/service/auth_service.dart';
import 'package:socket_flutter/src/service/notification_service.dart';
import 'package:socket_flutter/src/service/storage_service.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final userAPI = UserAPI();
  final StorageService storage = StorageService.to;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> login() async {
    final fcm = await NotificationService.to.getFCMToken();

    if (fcm == null) return;

    final Map<String, dynamic> credential = {
      "email": emailController.text,
      "password": passwordController.text,
      "fcm": fcm,
    };

    final ResponseAPI res = await userAPI.login(credential);

    if (res.message != null) {
      print(res.message);
      return;
    }
    if (res.status) {
      final userData = res.data["user"];
      final token = res.data["token"];

      final user = User.fromMap(userData);
      user.sessionToken = token;

      await storage.saveLocal(StorageKey.user, user.toMap());

      await Future.delayed(Duration(seconds: 1));
      await Get.delete<LoginController>();
      AuthService.to.currentUser.call(user);
    }
  }

  Future<void> pushSignUp() async {
    final result = await Get.toNamed(SignUpScreen.routeName);

    if (result is bool && result) {
      /// snackbar
      Get.snackbar(
        "Success Create User",
        "Please Login",
        icon: Icon(Icons.person, color: Colors.white),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        borderRadius: 20,
        margin: EdgeInsets.all(15),
        colorText: Colors.white,
        duration: Duration(seconds: 4),
        isDismissible: true,
        dismissDirection: DismissDirection.down,
        forwardAnimationCurve: Curves.easeOutBack,
      );
    }
  }
}
