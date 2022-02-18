import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:socket_flutter/src/screen/auth/reset_password/reset_password_controller.dart';
import 'package:socket_flutter/src/screen/main_tab/users/user_edit/email/edit_email_controller.dart';
import 'package:socket_flutter/src/screen/widget/custom_button.dart';
import 'package:sizer/sizer.dart';
import 'package:socket_flutter/src/screen/widget/custom_text_fields.dart';

class EditEmailScreen extends StatelessWidget {
  const EditEmailScreen({Key? key}) : super(key: key);
  static const routeName = '/EditEmail';

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditEmailController>(
      init: EditEmailController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Title'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (controller.state == VerifyState.checkEmail) ...[
                  CustomTextField(
                    controller: controller.emaiController,
                    labelText: controller.state.labelText,
                    inputType: controller.state.inputType,
                    isSecure: false,
                  ),
                ],
                if (controller.state == VerifyState.verify) ...[
                  CustomPinCodeField(
                    controller: controller.pinController,
                    inputType: controller.state.inputType,
                    isSecure: false,
                  )
                ],
                SizedBox(
                  height: 10.h,
                ),
                CustomButton(
                  title: "Update Email",
                  onPressed: () {
                    controller.updateEmail();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
