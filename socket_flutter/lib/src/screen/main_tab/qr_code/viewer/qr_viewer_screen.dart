import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_flutter/src/screen/main_tab/qr_code/viewer/qr_viewer_controller.dart';
import 'package:socket_flutter/src/screen/widget/custom_button.dart';
import 'package:sizer/sizer.dart';
import 'package:socket_flutter/src/screen/widget/user_country_widget.dart';

class QrViewerScreen extends StatelessWidget {
  const QrViewerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QrViewerController>(
      init: QrViewerController(),
      builder: (controller) {
        return Center(
          child: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (controller.findUser != null) ...[
                UserCountryWidget(
                  user: controller.findUser!,
                  size: 40.w,
                  addShadow: true,
                  onTap: () {
                    controller.selectFindUser();
                  },
                ),
                SizedBox(
                  height: 40,
                ),
              ],
              CustomCircleButton(
                title: "Scan",
                icon: Icons.qr_code_2,
                size: 100,
                backColor: Colors.green,
                onPress: () {
                  controller.startQrcodeScan();
                },
              )
            ],
          ),
        );
      },
    );
  }
}
