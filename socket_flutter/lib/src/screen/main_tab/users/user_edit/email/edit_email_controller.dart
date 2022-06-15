import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:socket_flutter/src/api/temp_token_api.dart';
import 'package:socket_flutter/src/api/user_api.dart';
import 'package:socket_flutter/src/model/user.dart';
import 'package:socket_flutter/src/screen/widget/common_dialog.dart';
import 'package:socket_flutter/src/service/auth_service.dart';

import '../../../../widget/custom_pin.dart';

class EditEmailController extends GetxController {
  final TextEditingController emaiController = TextEditingController();
  final TextEditingController pinController = TextEditingController();

  VerifyState state = VerifyState.checkEmail;
  final _tempTokenAPI = TempTokenAPI();
  final _userAPI = UserAPI();

  bool buttonEnable = false;

  TextEditingController? get currentTX {
    switch (this.state) {
      case VerifyState.checkEmail:
        return emaiController;
      case VerifyState.sendPassword:
        return null;
      case VerifyState.verify:
        return pinController;
    }
  }

  Future<void> updateEmail() async {
    if (emaiController.text == "") return;
    try {
      switch (this.state) {
        case VerifyState.checkEmail:
          final res = await _tempTokenAPI.requestNewEmail(emaiController.text);
          if (!res.status) break;

          state = VerifyState.verify;
          break;

        case VerifyState.verify:
          final Map<String, dynamic> data = {
            "email": emaiController.text,
            "verify": pinController.text
          };
          final checkRes = await _tempTokenAPI.verifyEmail(data);
          if (!checkRes.status) break;

          final res = await _userAPI.editUser(userData: data);
          if (!res.status) break;
          final newUser = User.fromMap(res.data);
          await AuthService.to.updateUser(newUser);

          Get.back();
          break;
        default:
          break;
      }
    } catch (e) {
      showError(e.toString());
    } finally {
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
