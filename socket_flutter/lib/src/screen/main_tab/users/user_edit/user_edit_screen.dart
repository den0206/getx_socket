import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:socket_flutter/src/model/user.dart';
import 'package:socket_flutter/src/screen/main_tab/users/user_edit/user_edit_controller.dart';
import 'package:socket_flutter/src/screen/widget/custom_button.dart';
import 'package:socket_flutter/src/screen/widget/custom_picker.dart';
import 'package:socket_flutter/src/screen/widget/custom_text_fields.dart';
import 'package:sizer/sizer.dart';
import 'package:socket_flutter/src/screen/widget/loading_widget.dart';

class UserEditScreen extends LoadingGetView<UserEditController> {
  static const routeName = '/EditUser';
  @override
  UserEditController get ctr => UserEditController();

  @override
  Widget get child {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Edit User'),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          constraints: BoxConstraints(maxHeight: 100.h),
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Obx(() => CircleImageButton(
                    imageProvider: controller.userImage.value == null
                        ? getUserImage(controller.editUser)
                        : FileImage(controller.userImage.value!),
                    size: 30.w,
                    onTap: () {
                      controller.selectImage();
                    },
                  )),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomTextField(
                  controller: controller.nameController,
                  labelText: "name",
                  icon: Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                  onChange: (text) {
                    controller.editUser.name = text;
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              selectlanguageArea(
                currentlang: controller.selectLanguage,
                onSelectedLang: (selectLang) {
                  controller.editUser.mainLanguage = selectLang;
                },
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  child: Text(
                    "Change Email",
                  ),
                  onPressed: () {
                    controller.showEditEmail();
                  },
                ),
              ),
              Obx(
                () => CustomButton(
                  title: "Edit",
                  width: 70.w,
                  background: Colors.green,
                  onPressed: controller.isChanged.value
                      ? () {
                          controller.updateUser();
                        }
                      : null,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Builder(builder: (context) {
                return CustomButton(
                  title: "Delete",
                  width: 70.w,
                  background: Colors.red,
                  onPressed: () {
                    controller.deleteAlert(context);
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}