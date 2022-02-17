import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:socket_flutter/src/api/reset_password_api.dart';
import 'package:socket_flutter/src/screen/widget/common_dialog.dart';

class ResetPasswordController extends GetxController {
  ResetState state = ResetState.checkEmail;
  final TextEditingController emailTextField = TextEditingController();
  final TextEditingController passwordTextField = TextEditingController();
  final TextEditingController verifyTextField = TextEditingController();

  final ResetPasswordAPI _resetPasswordAPI = ResetPasswordAPI();

  late final String userId;

  TextEditingController get currentTx {
    switch (this.state) {
      case ResetState.checkEmail:
        return emailTextField;
      case ResetState.sendPassword:
        return passwordTextField;
      case ResetState.verify:
        return verifyTextField;
    }
  }

  bool get isSecure {
    return currentTx != emailTextField;
  }

  final RxBool isLoading = false.obs;

  Future<void> sendRequest() async {
    if (currentTx.text == "") {
      showError("Confirm Text");
      return;
    }

    if (state != ResetState.checkEmail) {
      isLoading.call(true);
      await Future.delayed(Duration(seconds: 1));
    }

    try {
      switch (this.state) {
        case ResetState.checkEmail:

          /// validate Email
          state = ResetState.sendPassword;
          break;
        case ResetState.sendPassword:

          /// validate Password
          final res = await _resetPasswordAPI.request(emailTextField.text);

          if (res.message != null &&
              res.message!.contains("Not find this Email")) {
            passwordTextField.clear();
            state = ResetState.checkEmail;
          }

          if (!res.status) break;
          userId = res.data;
          state = ResetState.verify;
          break;
        case ResetState.verify:
          final data = {
            "userId": userId,
            "password": passwordTextField.text,
            "verify": verifyTextField.text
          };

          final res = await _resetPasswordAPI.verify(data);
          if (!res.status) break;
          print(res.data);

          Get.back(result: res);

          break;
      }
    } catch (e) {
      showError(e.toString());
    } finally {
      isLoading.call(false);
      update();
    }
  }
}

enum ResetState { checkEmail, sendPassword, verify }

extension ResetStateEXT on ResetState {
  String get title {
    switch (this) {
      case ResetState.checkEmail:
        return "Check Email";
      case ResetState.sendPassword:
        return "Send Password";
      case ResetState.verify:
        return "Verify";
    }
  }

  String get labelText {
    switch (this) {
      case ResetState.checkEmail:
        return "Your Email";
      case ResetState.sendPassword:
        return "New Password";
      case ResetState.verify:
        return "Verify Number";
    }
  }

  TextInputType get inputType {
    switch (this) {
      case ResetState.checkEmail:
        return TextInputType.emailAddress;
      case ResetState.sendPassword:
        return TextInputType.visiblePassword;
      case ResetState.verify:
        return TextInputType.number;
    }
  }
}
