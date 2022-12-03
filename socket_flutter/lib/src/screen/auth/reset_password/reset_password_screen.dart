import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:socket_flutter/src/screen/auth/reset_password/reset_password_controller.dart';
import 'package:socket_flutter/src/screen/widget/loading_widget.dart';

import '../../widget/custom_pin.dart';

class ResetPasswordScreen extends LoadingGetView<ResetPasswordController> {
  static const routeName = '/ResetPassword';

  @override
  ResetPasswordController get ctr => ResetPasswordController();
  final _formKey = GlobalKey<FormState>(debugLabel: '_ResetPasswordState');

  @override
  Widget get child {
    return GetBuilder<ResetPasswordController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text(controller.state.title),
            foregroundColor: Colors.black,
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          body: Form(
            key: _formKey,
            child: PinCodeArea(
              currentState: controller.state,
              currentTX: controller.currentTx,
              onChange: controller.checkField,
              onPressed: !controller.buttonEnable
                  ? null
                  : () {
                      if (_formKey.currentState?.validate() ?? false) {
                        controller.sendRequest();
                      }
                    },
            ),
          ),
        );
      },
    );
  }
}
