import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_flutter/src/screen/auth/reset_password/reset_password_controller.dart';
import 'package:socket_flutter/src/screen/auth/signup/signup_controller.dart';
import 'package:socket_flutter/src/screen/widget/custom_button.dart';
import 'package:socket_flutter/src/screen/widget/custom_picker.dart';
import 'package:socket_flutter/src/screen/widget/custom_text_fields.dart';
import 'package:socket_flutter/src/screen/widget/loading_widget.dart';
import 'package:sizer/sizer.dart';

class SignUpScreen extends LoadingGetView<SignUpController> {
  static const routeName = '/SignUp';
  @override
  SignUpController get ctr => SignUpController();

  @override
  Widget get child {
    return GetBuilder<SignUpController>(
      builder: (controller) {
        return Scaffold(
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (controller.state == VerifyState.checkEmail) ...[
                      CircleImageButton(
                        imageProvider: controller.userImage == null
                            ? Image.asset("assets/images/default_user.png")
                                .image
                            : FileImage(controller.userImage!),
                        size: 15.h,
                        onTap: () {
                          controller.selectImage();
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
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
                      Container(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CountryListPick(
                              appBar: AppBar(
                                title: Text("Select Your Country"),
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
                              },
                              initialSelection: controller.currentCountry.code,
                              // useUiOverlay: true,
                              useSafeArea: false,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            selectlanguageArea(
                              currentlang: controller.currentLanguage,
                              onSelectedLang: (selectLang) =>
                                  controller.currentLanguage.call(selectLang),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                      CustomTextField(
                        controller: controller.passwordController,
                        labelText: "password",
                        isSecure: true,
                      ),
                    ],
                    if (controller.state == VerifyState.verify) ...[
                      CustomPinCodeField(
                        controller: controller.pinCodeController,
                        inputType: controller.state.inputType,
                        isSecure: true,
                      )
                    ],
                    SizedBox(
                      height: 10.h,
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
        );
      },
    );
  }
}
