import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:socket_flutter/src/api/temp_token_api.dart';
import 'package:socket_flutter/src/api/user_api.dart';
import 'package:socket_flutter/src/model/user.dart';
import 'package:socket_flutter/src/screen/widget/common_dialog.dart';
import 'package:socket_flutter/src/screen/widget/loading_widget.dart';
import 'package:socket_flutter/src/service/auth_service.dart';
import 'package:socket_flutter/src/utils/global_functions.dart';

import '../../../../widget/custom_pin.dart';

class EditEmailController extends LoadingGetController {
  final TextEditingController emaiController = TextEditingController();
  final TextEditingController pinController = TextEditingController();

  VerifyState state = VerifyState.checkEmail;
  final _tempTokenAPI = TempTokenAPI();
  final _userAPI = UserAPI();

  bool buttonEnable = false;

  TextEditingController? get currentTX {
    switch (state) {
      case VerifyState.checkEmail:
        return emaiController;
      case VerifyState.sendPassword:
        return null;
      case VerifyState.verify:
        return pinController;
    }
  }

  Future<void> updateEmail() async {
    if (!buttonEnable) return;

    isOverlay.call(true);
    await Future.delayed(const Duration(seconds: 1));

    try {
      switch (state) {
        case VerifyState.checkEmail:
          final res = await _tempTokenAPI.requestNewEmail(emaiController.text);
          if (!res.status) break;
          buttonEnable = false;
          state = VerifyState.verify;
          break;

        case VerifyState.verify:
          final Map<String, dynamic> data = {
            "email": emaiController.text,
            "verify": pinController.text,
          };
          final checkRes = await _tempTokenAPI.verifyEmail(data);
          if (!checkRes.status) break;

          final res = await _userAPI.editUser(userData: data);
          if (!res.status) break;
          final newUser = User.fromMap(res.data);
          await AuthService.to.updateUser(newUser);

          Get.back();

          showSnackBar(title: "Change Email", message: "Keep Mind");
          break;
        default:
          break;
      }

      update();
    } catch (e) {
      showError(e.toString());
    } finally {
      isOverlay.call(false);
    }
  }

  void checkField(String value) {
    buttonEnable = value.length >= state.minLength;

    update();
  }
}
