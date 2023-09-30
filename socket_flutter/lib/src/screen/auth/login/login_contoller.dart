import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_flutter/src/api/user_api.dart';
import 'package:socket_flutter/src/languages/locale_lang.dart';
import 'package:socket_flutter/src/model/response_api.dart';
import 'package:socket_flutter/src/model/user.dart';
import 'package:socket_flutter/src/screen/auth/reset_password/reset_password_screen.dart';
import 'package:socket_flutter/src/screen/auth/signup/signup_screen.dart';
import 'package:socket_flutter/src/screen/widget/common_dialog.dart';
import 'package:socket_flutter/src/screen/widget/loading_widget.dart';
import 'package:socket_flutter/src/service/auth_service.dart';
import 'package:socket_flutter/src/service/notification_service.dart';
import 'package:socket_flutter/src/service/storage_service.dart';
import 'package:socket_flutter/src/utils/global_functions.dart';

class LoginController extends LoadingGetController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final userAPI = UserAPI();
  bool acceptTerms = false;
  LocaleLangs currentLang = LocaleLangs.English;

  @override
  void onInit() async {
    super.onInit();

    await _initTerms();
  }

  Future<void> _initTerms() async {
    final temp = await StorageKey.locale.loadString();
    if (temp != null) currentLang = getLocale(temp);

    acceptTerms = await StorageKey.checkTerms.loadBool() ?? false;
    emailController.text = await StorageKey.loginEmail.loadString() ?? "";
  }

  void updateTerms(LocaleLangs lang) {
    // 利用規約の更新
    currentLang = lang;
    update();
  }

  Future<void> setTerms(BuildContext context) async {
    if (!acceptTerms) return;
    await StorageKey.checkTerms.saveBool(true);
    Navigator.pop(context);
  }

  Future<void> login() async {
    await registerNotification();

    isOverlay.call(true);

    await Future.delayed(const Duration(seconds: 1));

    try {
      final fcm = await NotificationService.to.getFCMToken();

      if (fcm == null) throw Exception("Can't get FCM");

      final Map<String, dynamic> credential = {
        "email": emailController.text.toLowerCase(),
        "password": passwordController.text,
        "fcm": fcm,
      };
      final ResponseAPI res = await userAPI.login(credential);

      if (!res.status) return;

      final userData = res.data["user"];
      final token = res.data["token"];

      final user = User.fromMap(userData);
      user.sessionToken = token;
      await Future.delayed(const Duration(seconds: 1));

      await Get.delete<LoginController>();

      await AuthService.to.updateUser(user);
    } catch (e) {
      showError(e.toString());
    } finally {
      isOverlay.call(false);
    }
  }

  Future<void> pushSignUp() async {
    final result = await Get.toNamed(SignUpScreen.routeName);
    if (result is ResponseAPI) {
      final user = User.fromMap(result.data);
      emailController.text = user.email;

      showSnackBar(title: "Success Create User", message: "Please Login");
    }
  }

  Future<void> pushResetPassword() async {
    final result = await Get.toNamed(ResetPasswordScreen.routeName);
    if (result is ResponseAPI) {
      final user = User.fromMap(result.data);
      emailController.text = user.email;

      showSnackBar(title: "Reset Password", message: "Please Login");
    }
  }
}
