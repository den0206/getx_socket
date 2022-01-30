import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:socket_flutter/src/model/user.dart';
import 'package:socket_flutter/src/screen/main_tab/users/user_edit/user_edit_controller.dart';
import 'package:socket_flutter/src/screen/widget/custom_button.dart';
import 'package:socket_flutter/src/screen/widget/custom_text_fields.dart';
import 'package:sizer/sizer.dart';

class UserEditScreen extends GetView<UserEditController> {
  const UserEditScreen({Key? key}) : super(key: key);

  static const routeName = '/EditUser';

  @override
  Widget build(BuildContext context) {
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
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Obx(() => GestureDetector(
                    onTap: () {
                      controller.selectImage();
                    },
                    child: Container(
                      width: 30.w,
                      height: 30.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                        image: DecorationImage(
                          image: controller.userImage.value == null
                              ? getUserImage(controller.editUser)
                              : FileImage(controller.userImage.value!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
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
                height: 40,
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
