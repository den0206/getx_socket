import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_flutter/src/screen/auth/signup/signup_controller.dart';
import 'package:socket_flutter/src/screen/widget/custom_button.dart';
import 'package:socket_flutter/src/screen/widget/custom_text_fields.dart';
import 'package:socket_flutter/src/utils/global_functions.dart';

class SignUpScreen extends GetView<SignUpController> {
  const SignUpScreen({Key? key}) : super(key: key);

  static const routeName = '/SignUp';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        dismisskeyBord(context);
      },
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomTextField(
                    controller: controller.nameController,
                    labelText: "name",
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    controller: controller.emaiController,
                    labelText: "email",
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    controller: controller.passwordController,
                    labelText: "password",
                    isSecure: true,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomButton(
                    title: "SignUp",
                    onPressed: () {
                      controller.signUp();
                    },
                  ),
                  TextButton(
                    child: Text("Already have Acount"),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
