import 'dart:io';

import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socket_flutter/src/api/temp_token_api.dart';
import 'package:socket_flutter/src/api/user_api.dart';
import 'package:socket_flutter/src/model/language.dart';
import 'package:socket_flutter/src/screen/auth/reset_password/reset_password_controller.dart';
import 'package:socket_flutter/src/screen/widget/common_dialog.dart';
import 'package:socket_flutter/src/screen/widget/loading_widget.dart';
import 'package:socket_flutter/src/service/image_extention.dart';
import 'package:socket_flutter/src/utils/global_functions.dart';

class SignUpController extends LoadingGetController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emaiController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();

  File? userImage;
  CountryCode currentCountry = getCountryFromCode("US");
  Rxn<Language> currentLanguage = Rxn<Language>();

  VerifyState state = VerifyState.checkEmail;

  final _userAPI = UserAPI();
  final _tempTokenAPI = TempTokenAPI();

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> selectImage() async {
    final imageExt = ImageExtention();
    final imageFile =
        await imageExt.selectImage(imageSource: ImageSource.gallery);

    userImage = imageFile;

    update();
  }

  Future<void> signUp() async {
    if (currentLanguage.value == null) {
      showError("Select Language");
      return;
    }
    isOverlay.call(true);
    await Future.delayed(Duration(seconds: 1));

    try {
      switch (this.state) {
        case VerifyState.checkEmail:
          final res = await _tempTokenAPI.requestNewEmail(emaiController.text);
          if (!res.status) break;

          state = VerifyState.verify;
          break;
        case VerifyState.verify:
          final Map<String, dynamic> userData = {
            "name": nameController.text,
            "email": emaiController.text,
            "countryCode": currentCountry.code,
            "mainLanguage": currentLanguage.value!.name,
            "password": passwordController.text,
            "verify": pinCodeController.text,
          };

          /// Pincodeの確認
          final checkRes = await _tempTokenAPI.verifyEmail(userData);
          if (!checkRes.status) break;

          /// New Userの確認
          final result = await _userAPI.signUp(
            userData: userData,
            avatarFile: userImage,
          );
          if (!result.status) break;

          Get.back(result: result);

          break;

        default:
          break;
      }
    } catch (e) {
      print(e.toString());
    } finally {
      isOverlay.call(false);
      update();
    }
  }
}
