import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import 'package:socket_flutter/src/screen/main_tab/users/user_edit/email/edit_email_controller.dart';
import 'package:socket_flutter/src/screen/widget/loading_widget.dart';
import '../../../../widget/custom_pin.dart';

class EditEmailScreen extends LoadingGetView<EditEmailController> {
  @override
  get ctr => EditEmailController();

  static const routeName = '/EditEmail';

  @override
  Widget get child {
    return GetBuilder<EditEmailController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Change Email'),
          ),
          body: controller.currentTX != null
              ? PinCodeArea(
                  currentState: controller.state,
                  currentTX: controller.currentTX!,
                  onChange: controller.checkField,
                  onPressed: !controller.buttonEnable
                      ? null
                      : () {
                          controller.updateEmail();
                        },
                )
              : Container(),
        );
      },
    );
  }
}
