import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:socket_flutter/src/api/temp_token_api.dart';
import 'package:socket_flutter/src/screen/widget/common_dialog.dart';
import 'package:socket_flutter/src/screen/widget/loading_widget.dart';

import '../../widget/custom_pin.dart';

class ResetPasswordController extends LoadingGetController {
  VerifyState state = VerifyState.checkEmail;
  final TextEditingController emailTextField = TextEditingController();
  final TextEditingController passwordTextField = TextEditingController();
  final TextEditingController verifyTextField = TextEditingController();

  final TempTokenAPI _resetPasswordAPI = TempTokenAPI();

  late final String userId;

  TextEditingController get currentTx {
    switch (state) {
      case VerifyState.checkEmail:
        return emailTextField;
      case VerifyState.sendPassword:
        return passwordTextField;
      case VerifyState.verify:
        return verifyTextField;
    }
  }

  bool buttonEnable = false;

  Future<void> sendRequest() async {
    if (currentTx.text == "") return;

    if (state != VerifyState.checkEmail) {
      isOverlay.call(true);
      await Future.delayed(const Duration(seconds: 1));
    }

    try {
      switch (state) {
        case VerifyState.checkEmail:

          /// validate Email
          state = VerifyState.sendPassword;
          break;
        case VerifyState.sendPassword:

          /// validate Password
          final res = await _resetPasswordAPI.requestPassword(
            emailTextField.text,
          );

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
            "verify": verifyTextField.text,
          };

          final res = await _resetPasswordAPI.verifyPassword(data);
          if (!res.status) break;

          Get.back(result: res);

          break;
      }
    } catch (e) {
      if (e.toString() == "Error During Communication: Not find this Email") {
        state = VerifyState.checkEmail;
        emailTextField.clear();
        passwordTextField.clear();
      }
      showError(e.toString());
    } finally {
      isOverlay.call(false);
      buttonEnable = false;
      update();
    }
  }

  void checkField(String value) {
    buttonEnable = value.length >= state.minLength;

    update();
  }
}
