import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:socket_flutter/src/screen/auth/signup/signup_controller.dart';
import 'package:socket_flutter/src/screen/widget/custom_button.dart';
import 'package:socket_flutter/src/screen/widget/custom_picker.dart';
import 'package:socket_flutter/src/screen/widget/custom_text_fields.dart';
import 'package:socket_flutter/src/screen/widget/loading_widget.dart';
import 'package:socket_flutter/src/utils/validator.dart';

import '../../widget/custom_pin.dart';
import '../../widget/neumorphic/buttons.dart';
import '../login/login_sceen.dart';

class SignUpScreen extends LoadingGetView<SignUpController> {
  static const routeName = '/SignUp';
  @override
  SignUpController get ctr => SignUpController();

  final _formKey = GlobalKey<FormState>(debugLabel: '_SignUpState');

  @override
  Widget get child {
    return GetBuilder<SignUpController>(
      builder: (controller) {
        return Scaffold(
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            width: double.infinity,
            height: double.infinity,
            child: Form(
              key: _formKey,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (controller.state == VerifyState.checkEmail) ...[
                        CircleImageButton(
                          imageProvider: controller.userImage == null
                              ? Image.asset(
                                  "assets/images/default_user.png",
                                ).image
                              : FileImage(controller.userImage!),
                          size: 15.h,
                          onTap: () {
                            controller.selectImage();
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: controller.nameController,
                          labelText: "Name".tr,
                          validator: valideName,
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          controller: controller.emaiController,
                          labelText: "Email".tr,
                          validator: validateEmail,
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CountryListPick(
                                appBar: AppBar(
                                  title: Text("Select Your Country".tr),
                                ),
                                theme: CountryTheme(
                                  labelColor: Colors.black,
                                  alphabetSelectedBackgroundColor: Colors.green,
                                  alphabetTextColor: Colors.black,
                                  isShowFlag: true,
                                  isShowTitle: true,
                                  isShowCode: false,
                                  isDownIcon: true,
                                  showEnglishName: true,
                                ),
                                onChanged: (CountryCode? code) {
                                  if (code == null) return;
                                  controller.currentCountry = code;
                                  controller.autoSetLang(code);
                                },
                                initialSelection:
                                    controller.currentCountry.code,
                                // useUiOverlay: true,
                                useSafeArea: false,
                              ),
                              const SizedBox(height: 10),
                              SelectlanguageArea(
                                currentlang: controller.currentLanguage,
                                onSelectedLang: (selectLang) =>
                                    controller.currentLanguage.call(selectLang),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                        CustomTextField(
                          controller: controller.passwordController,
                          labelText: "Password".tr,
                          validator: validPassword,
                          isSecure: true,
                        ),
                        SizedBox(height: 2.h),
                        Row(
                          children: [
                            Checkbox(
                              value: controller.acceptTerms,
                              activeColor: Colors.green,
                              onChanged: (value) {
                                if (value == null) return;
                                controller.acceptTerms = value;
                                controller.update();
                              },
                            ),
                            Builder(
                              builder: (context) {
                                return RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                    children: [
                                      TextSpan(text: "I agree".tr),
                                      TextSpan(
                                        text: "the Terms of Use".tr,
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            await showTermsDialog(context);
                                          },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                      if (controller.state == VerifyState.verify) ...[
                        CustomPinCodeField(
                          controller: controller.pinCodeController,
                          inputType: controller.state.inputType,
                          isSecure: true,
                        ),
                      ],
                      SizedBox(height: 10.h),
                      NeumorphicCustomButtton(
                        title: controller.buttonTitle,
                        background: Colors.green,
                        onPressed: controller.buttonEnable
                            ? () {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  controller.signUp();
                                }
                              }
                            : null,
                      ),
                      if (controller.state == VerifyState.checkEmail) ...[
                        NeumorphicTextButton(
                          title: "Already have Acount".tr,
                          onPressed: () {
                            Get.back();
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
