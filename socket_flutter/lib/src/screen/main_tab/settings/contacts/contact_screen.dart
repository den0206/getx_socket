import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/utils.dart';

import 'package:socket_flutter/src/screen/widget/loading_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'contact_controller.dart';

class ContactScreen extends LoadingGetView<ContactController> {
  static const routeName = '/Contact';
  final key = UniqueKey();
  @override
  ContactController get ctr => ContactController();

  @override
  Widget get child {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact'.tr),
      ),
      body: GetBuilder<ContactController>(
        builder: (controller) {
          return controller.connectionStatus
              ? WebView(
                  initialUrl: controller.contactURL,
                  key: key,
                  javascriptMode: JavascriptMode.unrestricted,
                  onPageFinished: (_) {},
                  onPageStarted: (_) {},
                )
              : Center(
                  child: Text("No Internet connection".tr),
                );
        },
      ),
    );
  }
}
