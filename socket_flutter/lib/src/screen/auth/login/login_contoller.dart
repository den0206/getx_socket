import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_flutter/src/api/user_api.dart';
import 'package:socket_flutter/src/model/response_api.dart';
import 'package:socket_flutter/src/model/user.dart';
import 'package:socket_flutter/src/screen/auth/reset_password/reset_password_screen.dart';
import 'package:socket_flutter/src/screen/auth/signup/signup_screen.dart';
import 'package:socket_flutter/src/service/auth_service.dart';
import 'package:socket_flutter/src/service/notification_service.dart';
import 'package:socket_flutter/src/service/storage_service.dart';
import 'package:socket_flutter/src/utils/global_functions.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final userAPI = UserAPI();
  final StorageService storage = StorageService.to;
  final RxBool isLoading = false.obs;

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

    isLoading.call(true);

    try {
      final ResponseAPI res = await userAPI.login(credential);

      final userData = res.data["user"];
      final token = res.data["token"];

      final user = User.fromMap(userData);
      user.sessionToken = token;

      await storage.saveLocal(StorageKey.user, user.toMap());

      await Future.delayed(Duration(seconds: 1));
      await Get.delete<LoginController>();
      AuthService.to.currentUser.call(user);
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading.call(false);
    }
  }

  Future<void> pushSignUp() async {
    final result = await Get.toNamed(SignUpScreen.routeName);
    if (result is ResponseAPI) {
      final user = User.fromMap(result.data);
      emailController.text = user.email;

      showSnackBar(title: "Success Create User");
    }
  }

  Future<void> pushResetPassword() async {
    final result = await Get.toNamed(ResetPasswordScreen.routeName);
    if (result is ResponseAPI) {
      final user = User.fromMap(result.data);
      emailController.text = user.email;

      showSnackBar(title: "Reset Password");
    }
  }
}
