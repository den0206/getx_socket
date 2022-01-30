import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socket_flutter/src/api/user_api.dart';
import 'package:socket_flutter/src/model/user.dart';
import 'package:socket_flutter/src/service/auth_service.dart';
import 'package:socket_flutter/src/service/image_extention.dart';
import 'package:socket_flutter/src/service/storage_service.dart';

class UserEditController extends GetxController {
  final User currentUser = AuthService.to.currentUser.value!;
  late final User editUser;
  final UserAPI _userAPI = UserAPI();

  Rxn<File> userImage = Rxn<File>();
  final TextEditingController nameController = TextEditingController();

  final imageExt = ImageExtention();
  RxBool get isChanged {
    if (editUser.name.isEmpty) {
      return false.obs;
    }
    if (userImage.value != null || currentUser.name != editUser.name) {
      return true.obs;
    } else {
      return false.obs;
    }
  }

  @override
  void onInit() {
    super.onInit();
    _onInit();
  }

  void _onInit() {
    editUser = currentUser.copyWith();
    nameController.text = editUser.name;
  }

  Future<void> selectImage() async {
    final imageFile =
        await imageExt.selectImage(imageSource: ImageSource.gallery);

    userImage.call(imageFile);
  }

  Future<void> updateUser() async {
    if (!isChanged.value) return;

    final res = await _userAPI.editUser(
        userData: editUser.toMap(), avatarFile: userImage.value);

    if (!res.status) return;
    final StorageService storage = StorageService.to;

    final newUser = User.fromMap(res.data);
    newUser.sessionToken = currentUser.sessionToken;

    await storage.saveLocal(StorageKey.user, newUser.toMap());
    print(newUser.toString());

    AuthService.to.currentUser.call(newUser);

    Get.back();
  }
}
