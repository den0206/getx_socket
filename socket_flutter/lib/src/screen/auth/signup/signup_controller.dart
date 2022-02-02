import 'dart:io';

import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socket_flutter/src/api/user_api.dart';
import 'package:socket_flutter/src/model/language.dart';
import 'package:socket_flutter/src/screen/widget/common_dialog.dart';
import 'package:socket_flutter/src/service/image_extention.dart';
import 'package:socket_flutter/src/utils/global_functions.dart';

class SignUpController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emaiController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Rxn<File> userImage = Rxn<File>();

  CountryCode currentCountry = getCountryFromCode("US");
  Rxn<Language> currentLanguage = Rxn<Language>();

  final RxBool isLoading = false.obs;

  final _userAPI = UserAPI();

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> selectImage() async {
    final imageExt = ImageExtention();
    final imageFile =
        await imageExt.selectImage(imageSource: ImageSource.gallery);

    userImage.call(imageFile);
  }

  Future<void> signUp() async {
    if (currentLanguage.value == null) {
      showError("Select Language");
      return;
    }
    isLoading.call(true);
    await Future.delayed(Duration(seconds: 1));

    try {
      final Map<String, dynamic> userData = {
        "name": nameController.text,
        "email": emaiController.text,
        "countryCode": currentCountry.code,
        "mainLanguage": currentLanguage.value!.name,
        "password": passwordController.text,
      };

      final result = await _userAPI.signUp(
        userData: userData,
        avatarFile: userImage.value,
      );
      if (result.status) {
        Get.back(result: result);
      }
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading.call(false);
    }
  }
}
