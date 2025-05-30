import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/utils.dart';
import 'package:sizer/sizer.dart';
import 'package:socket_flutter/src/model/user.dart';
import 'package:socket_flutter/src/screen/main_tab/users/user_edit/user_edit_controller.dart';
import 'package:socket_flutter/src/screen/widget/custom_picker.dart';
import 'package:socket_flutter/src/screen/widget/custom_text_fields.dart';
import 'package:socket_flutter/src/screen/widget/loading_widget.dart';
import 'package:socket_flutter/src/screen/widget/neumorphic/buttons.dart';
import 'package:socket_flutter/src/utils/consts_color.dart';
import 'package:socket_flutter/src/utils/validator.dart';

class UserEditScreen extends LoadingGetView<UserEditController> {
  static const routeName = '/EditUser';
  @override
  UserEditController get ctr => UserEditController();
  final _formKey = GlobalKey<FormState>(debugLabel: '_EditUserState');

  @override
  Widget get child {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Edit User'.tr),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          decoration: const BoxDecoration(
            color: ConstsColor.mainBackgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          constraints: BoxConstraints(maxHeight: 100.h),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Obx(
                () => NeumorphicAvatarButton(
                  imageProvider: controller.userImage.value == null
                      ? getUserImage(controller.editUser)
                      : FileImage(controller.userImage.value!),
                  size: 30.w,
                  onTap: () {
                    controller.selectImage();
                  },
                ),
              ),
              const SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: CustomTextField(
                        controller: controller.nameController,
                        labelText: "Name".tr,
                        validator: valideName,
                        icon: const Icon(Icons.person, color: Colors.black),
                        onChange: (text) {
                          controller.editUser.name = text;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    SelectlanguageArea(
                      currentlang: controller.selectLanguage,
                      onSelectedLang: (selectLang) {
                        controller.editUser.mainLanguage = selectLang;
                      },
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: NeumorphicTextButton(
                        title: "Change Email".tr,
                        onPressed: () {
                          controller.showEditEmail();
                        },
                      ),
                    ),
                    Obx(
                      () => NeumorphicCustomButtton(
                        title: "Edit".tr,
                        width: 70.w,
                        background: Colors.green,
                        onPressed: controller.isChanged.value
                            ? () {
                                controller.updateUser();
                              }
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Builder(
                builder: (context) {
                  return NeumorphicCustomButtton(
                    title: "Delete".tr,
                    width: 70.w,
                    background: Colors.red,
                    onPressed: () {
                      controller.deleteAlert(context);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
