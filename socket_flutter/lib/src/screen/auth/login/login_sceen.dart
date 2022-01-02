import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_flutter/src/screen/auth/login/login_contoller.dart';
import 'package:socket_flutter/src/screen/widget/custom_button.dart';
import 'package:socket_flutter/src/screen/widget/custom_text_fields.dart';
import 'package:socket_flutter/src/utils/global_functions.dart';

class LoginScreen extends GetView<LoginController> {
  LoginScreen({Key? key}) : super(key: key);
  static const routeName = '/Login';
  final _formKey = GlobalKey<FormState>(debugLabel: '_LoginState');

  @override
  Widget build(BuildContext context) {
    Get.put(LoginController());
    return GestureDetector(
      onTap: () {
        dismisskeyBord(context);
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: controller.emailController,
                      labelText: "Email",
                      icon: Icon(
                        Icons.email,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CustomTextField(
                      controller: controller.passwordController,
                      labelText: "Password",
                      isSecure: true,
                      icon: Icon(
                        Icons.lock,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        child: Text(
                          "Forgot password",
                        ),
                        onPressed: () {},
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomButton(
                      title: "Login",
                      onPressed: () {
                        controller.login();
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextButton(
                      child: Text("Sign UP"),
                      onPressed: () {
                        controller.pushSignUp();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
