import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:lottie/lottie.dart';
import 'package:socket_flutter/src/screen/auth/login/login_contoller.dart';
import 'package:socket_flutter/src/screen/widget/animated_widget.dart';
import 'package:socket_flutter/src/screen/widget/custom_text_fields.dart';
import 'package:socket_flutter/src/screen/widget/loading_widget.dart';
import 'package:socket_flutter/src/utils/global_functions.dart';
import 'package:sizer/sizer.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../widget/neumorphic/buttons.dart';

class LoginScreen extends LoadingGetView<LoginController> {
  static const routeName = '/Login';
  final _formKey = GlobalKey<FormState>(debugLabel: '_LoginState');

  @override
  LoginController get ctr => LoginController();

  @override
  Widget get child {
    return Builder(builder: (context) {
      return VisibilityDetector(
        key: Key("Login"),
        onVisibilityChanged: (visibilityInfo) {
          var visiblePercentage = visibilityInfo.visibleFraction * 100;
          if (visiblePercentage == 100) {
            // 初回起動時のみ
            if (!controller.acceptTerms) showTermsDialog(context);
          }
        },
        child: Scaffold(
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
        ),
      );
    });
  }

  Future<void> showTermsDialog(BuildContext context) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return GetBuilder<LoginController>(
          builder: (current) {
            return FadeinWidget(
              child: Center(
                child: Container(
                  width: 85.w,
                  height: MediaQuery.of(context).size.height - 80,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 7,
                        child: FutureBuilder(
                            future: rootBundle
                                .loadString("assets/markdown/privacy.md"),
                            builder: (BuildContext context,
                                AsyncSnapshot<String> snapshot) {
                              if (snapshot.hasData) {
                                return Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: Colors.black)),
                                  child: Markdown(
                                    data: snapshot.data!,
                                    shrinkWrap: true,
                                  ),
                                );
                              }

                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }),
                      ),
                      Expanded(
                        flex: 1,
                        child: Material(
                          child: Row(
                            children: [
                              Checkbox(
                                value: current.acceptTerms,
                                onChanged: (value) {
                                  if (value == null) return;
                                  current.acceptTerms = value;
                                  current.update();
                                },
                              ),
                              Text(
                                'I have read and accept',
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                maxLines: 2,
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: NeumorphicCustomButtton(
                          title: "Accept",
                          background: Colors.green,
                          onPressed: !current.acceptTerms
                              ? null
                              : () {
                                  current.setTerms(context);
                                },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
