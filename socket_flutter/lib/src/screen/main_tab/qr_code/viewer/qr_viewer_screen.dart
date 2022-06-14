import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:socket_flutter/src/screen/main_tab/qr_code/viewer/qr_viewer_controller.dart';
import 'package:sizer/sizer.dart';
import 'package:socket_flutter/src/screen/widget/user_country_widget.dart';
import 'package:socket_flutter/src/utils/neumorpic_style.dart';

class QrViewerScreen extends StatelessWidget {
  const QrViewerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color mainColor = Colors.green;
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
                  onTap: () {
                    controller.selectFindUser();
                  },
                ),
                SizedBox(
                  height: 40,
                ),
              ],
              NeumorphicButton(
                padding: EdgeInsets.all(15),
                style: commonNeumorphic(depth: 0.5),
                child: Column(
                  children: [
                    Text(
                      "Scan QR",
                      style: TextStyle(
                          color: mainColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.sp),
                    ),
                    Icon(
                      Icons.qr_code_2,
                      size: 23.h,
                      color: mainColor,
                    ),
                  ],
                ),
                onPressed: () {
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
