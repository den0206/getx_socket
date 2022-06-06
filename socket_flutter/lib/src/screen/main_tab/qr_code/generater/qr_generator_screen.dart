import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:socket_flutter/src/screen/main_tab/qr_code/generater/qr_generator_controller.dart';
import 'package:socket_flutter/src/service/auth_service.dart';

class QrGenerateScreen extends StatelessWidget {
  const QrGenerateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QrGeneratorController>(
      init: QrGeneratorController(),
      builder: (controller) {
        return Center(
          child: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: !controller.isLoading
                      ? IconButton(
                          icon: Icon(
                            Icons.refresh,
                            size: 40,
                          ),
                          onPressed: () {
                            controller.updateSearchId();
                          },
                        )
                      : CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.black),
                        ),
                ),
              ),
              QrImage(
                data: AuthService.to.currentUser.value!.searchId,
                version: QrVersions.auto,
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                size: 200,
                gapless: false,
                errorStateBuilder: (cxt, err) {
                  if (err != null) {
                    return Container(
                      child: Center(
                        child: Text(
                          "Uh oh! Something went wrong...",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  return Container();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
