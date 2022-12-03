import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:socket_flutter/src/screen/main_tab/qr_code/generater/qr_generator_controller.dart';
import 'package:socket_flutter/src/screen/widget/neumorphic/buttons.dart';
import 'package:socket_flutter/src/service/auth_service.dart';
import 'package:socket_flutter/src/utils/consts_color.dart';
import 'package:socket_flutter/src/utils/neumorpic_style.dart';

class QrGenerateScreen extends StatelessWidget {
  const QrGenerateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QrGeneratorController>(
      init: QrGeneratorController(),
      builder: (controller) {
        return Stack(
          children: [
            Center(
              child: Neumorphic(
                padding: const EdgeInsets.all(15),
                style: commonNeumorphic(depth: 0.5),
                child: QrImage(
                  data: AuthService.to.currentUser.value!.searchId,
                  version: QrVersions.auto,
                  backgroundColor: Colors.green,
                  foregroundColor: ConstsColor.mainBackgroundColor,
                  size: 200,
                  gapless: false,
                  errorStateBuilder: (cxt, err) {
                    if (err != null) {
                      return Center(
                        child: Text(
                          "Uh oh! Something went wrong...".tr,
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    return Container();
                  },
                ),
              ),
            ),
            Positioned(
              top: 5.h,
              right: 20,
              child: !controller.isLoading
                  ? NeumorphicIconButton(
                      icon: const Icon(
                        Icons.refresh,
                        size: 40,
                      ),
                      onPressed: () {
                        controller.updateSearchId();
                      },
                    )
                  : const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    ),
            )
          ],
        );
      },
    );
  }
}
