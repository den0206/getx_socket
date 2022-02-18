import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:socket_flutter/src/api/temp_token_api.dart';
import 'package:socket_flutter/src/screen/widget/common_dialog.dart';
import 'package:socket_flutter/src/screen/widget/loading_widget.dart';

class ResetPasswordController extends LoadingGetController {
  VerifyState state = VerifyState.checkEmail;
  final TextEditingController emailTextField = TextEditingController();
  final TextEditingController passwordTextField = TextEditingController();
  final TextEditingController verifyTextField = TextEditingController();

  final TempTokenAPI _resetPasswordAPI = TempTokenAPI();

  late final String userId;

  TextEditingController get currentTx {
    switch (this.state) {
      case VerifyState.checkEmail:
        return emailTextField;
      case VerifyState.sendPassword:
        return passwordTextField;
      case VerifyState.verify:
        return verifyTextField;
    }
  }

  bool get isSecure {
    return currentTx != emailTextField;
  }

  bool buttonEnable = false;

  Future<void> sendRequest() async {
    if (currentTx.text == "") return;

    if (state != VerifyState.checkEmail) {
      isOverlay.call(true);
      await Future.delayed(Duration(seconds: 1));
    }

    try {
      switch (this.state) {
        case VerifyState.checkEmail:

          /// validate Email
          state = VerifyState.sendPassword;
          break;
        case VerifyState.sendPassword:

          /// validate Password
          final res =
              await _resetPasswordAPI.requestPassword(emailTextField.text);

          if (res.message != null &&
              res.message!.contains("Not find this Email")) {
            passwordTextField.clear();
            state = VerifyState.checkEmail;
          }

          if (!res.status) break;
          userId = res.data;
          state = VerifyState.verify;
          break;
        case VerifyState.verify:
          final data = {
            "userId": userId,
            "password": passwordTextField.text,
            "verify": verifyTextField.text
          };

          final res = await _resetPasswordAPI.verifyPassword(data);
          if (!res.status) break;

          Get.back(result: res);

          break;
      }
    } catch (e) {
      showError(e.toString());
    } finally {
      isOverlay.call(false);
      buttonEnable = false;
      update();
    }
  }

  void checkField(String value) {
    int minimum;
    switch (this.state) {
      case VerifyState.checkEmail:
      case VerifyState.sendPassword:
        minimum = 1;
        break;
      case VerifyState.verify:
        minimum = 6;
        break;
    }

    buttonEnable = value.length >= minimum;

    update();
  }
}

enum VerifyState { checkEmail, sendPassword, verify }

extension VerifyStateEXT on VerifyState {
  String get title {
    switch (this) {
      case VerifyState.checkEmail:
        return "Check Email";
      case VerifyState.sendPassword:
        return "Send Password";
      case VerifyState.verify:
        return "Verify";
    }
  }

  String get labelText {
    switch (this) {
      case VerifyState.checkEmail:
        return "Your Email";
      case VerifyState.sendPassword:
        return "New Password";
      case VerifyState.verify:
        return "Verify Number";
    }
  }

  TextInputType get inputType {
    switch (this) {
      case VerifyState.checkEmail:
        return TextInputType.emailAddress;
      case VerifyState.sendPassword:
        return TextInputType.visiblePassword;
      case VerifyState.verify:
        return TextInputType.number;
    }
  }
}
