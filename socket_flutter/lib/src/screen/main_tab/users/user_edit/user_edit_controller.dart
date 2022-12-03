import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socket_flutter/src/api/user_api.dart';
import 'package:socket_flutter/src/model/language.dart';
import 'package:socket_flutter/src/model/user.dart';
import 'package:socket_flutter/src/screen/main_tab/users/user_edit/email/edit_email_screen.dart';
import 'package:socket_flutter/src/screen/widget/common_dialog.dart';
import 'package:socket_flutter/src/screen/widget/loading_widget.dart';
import 'package:socket_flutter/src/service/auth_service.dart';
import 'package:socket_flutter/src/service/image_extention.dart';

class UserEditController extends LoadingGetController {
  final User currentUser = AuthService.to.currentUser.value!;
  late final User editUser;
  final UserAPI _userAPI = UserAPI();

  Rxn<File> userImage = Rxn<File>();
  final TextEditingController nameController = TextEditingController();
  final Rxn<Language> selectLanguage = Rxn<Language>();

  final imageExt = ImageExtention();

  RxBool get isChanged {
    if (editUser.name.isEmpty) {
      return false.obs;
    }
    if (userImage.value != null ||
        currentUser.name != editUser.name ||
        selectLanguage.value != currentUser.mainLanguage) {
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
    selectLanguage.value = editUser.mainLanguage;
  }

  Future<void> selectImage() async {
    final imageFile =
        await imageExt.selectImage(imageSource: ImageSource.gallery);

    userImage.call(imageFile);
  }

  Future<void> updateUser() async {
    if (!isChanged.value) return;
    isOverlay.call(true);
    await Future.delayed(const Duration(seconds: 1));

    try {
      final res = await _userAPI.editUser(
          userData: editUser.toMap(), avatarFile: userImage.value);

      if (!res.status) return;

      final newUser = User.fromMap(res.data);
      await AuthService.to.updateUser(newUser);

      if (userImage.value != null) {
        await CachedNetworkImage.evictFromCache(newUser.avatarUrl!);
        // Tips update same url image
        newUser.avatarUrl = "${newUser.avatarUrl}?v=${Random().nextInt(1000)}";
      }

      Get.back(result: newUser);
    } catch (e) {
      showError(e.toString());
    } finally {
      isOverlay.call(false);
    }
  }

  Future<void> showEditEmail() async {
    final _ = await Get.toNamed(EditEmailScreen.routeName);
  }

  Future<void> deleteAlert(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          title: "Delete",
          descripon: "Remove all Relation!",
          icon: Icons.delete,
          mainColor: Colors.red,
          onPress: () async {
            await deleteUser();
          },
        );
      },
    );
  }

  Future<void> deleteUser() async {
    await Future.delayed(const Duration(milliseconds: 500));

    isOverlay.call(true);
    try {
      final res = await _userAPI.deleteUser();
      if (!res.status) return;

      await AuthService.to.logout();
      Get.back();
    } catch (e) {
      showError(e.toString());
    } finally {
      isOverlay.call(false);
    }
  }
}
