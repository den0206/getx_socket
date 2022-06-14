import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:socket_flutter/src/screen/auth/login/login_contoller.dart';
import 'package:socket_flutter/src/screen/widget/custom_text_fields.dart';
import 'package:socket_flutter/src/screen/widget/loading_widget.dart';
import 'package:socket_flutter/src/utils/global_functions.dart';
import 'package:sizer/sizer.dart';
import '../../widget/neumorphic/buttons.dart';

class LoginScreen extends LoadingGetView<LoginController> {
  static const routeName = '/Login';
  final _formKey = GlobalKey<FormState>(debugLabel: '_LoginState');

  @override
  LoginController get ctr => LoginController();

  @override
  Widget get child {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  LottieBuilder.asset(
                    "assets/lotties/circle_earth.json",
                    width: 300,
                    height: 300,
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  CustomTextField(
                    controller: controller.emailController,
                    labelText: "Email",
                    icon: Icon(
                      Icons.email,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    height: 30,
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
                    child: NeumorphicTextButton(
                      title: "Forgot password",
                      onPressed: () {
                        controller.pushResetPassword();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Builder(builder: (context) {
                    return NeumorphicCustomButtton(
                      title: "Login",
                      background: Colors.green,
                      onPressed: () {
                        dismisskeyBord(context);
                        controller.login();
                      },
                    );
                  }),
                  SizedBox(
                    height: 10,
                  ),
                  NeumorphicTextButton(
                    title: "Sign UP",
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
    );
  }
}
