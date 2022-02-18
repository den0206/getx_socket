import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:socket_flutter/src/screen/auth/reset_password/reset_password_controller.dart';
import 'package:socket_flutter/src/screen/widget/custom_button.dart';
import 'package:socket_flutter/src/screen/widget/custom_text_fields.dart';
import 'package:socket_flutter/src/screen/widget/loading_widget.dart';
import 'package:socket_flutter/src/utils/global_functions.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  static const routeName = '/ResetPassword';

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ResetPasswordController>(
      init: ResetPasswordController(),
      builder: (controller) {
        return OverlayLoadingWidget(
          isLoading: controller.isLoading,
          child: Scaffold(
            appBar: AppBar(
              title: Text(controller.state.title),
              foregroundColor: Colors.black,
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
            body: Center(
              child: Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (controller.state == VerifyState.verify)
                    Text(
                      "Please Check Your Email",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Stack(
                      children: [
                        if (controller.state != VerifyState.verify)
                          CustomTextField(
                            controller: controller.currentTx,
                            labelText: controller.state.labelText,
                            inputType: controller.state.inputType,
                            isSecure: controller.isSecure,
                            onChange: controller.checkField,
                          ),
                        if (controller.state == VerifyState.verify)
                          CustomPinCodeField(
                            controller: controller.currentTx,
                            inputType: controller.state.inputType,
                            isSecure: controller.isSecure,
                            onChange: controller.checkField,
                          ),
                      ],
                    ),
                  ),
                  CustomButton(
                    title: controller.state.title,
                    onPressed: controller.buttonEnable
                        ? () {
                            dismisskeyBord(context);
                            controller.sendRequest();
                          }
                        : null,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
