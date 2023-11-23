import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/utils.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    super.key,
    required this.title,
    required this.descripon,
    required this.onPress,
    required this.icon,
    required this.mainColor,
  });

  final String title;
  final String descripon;

  final Function() onPress;
  final IconData icon;
  final Color mainColor;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  descripon,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          textStyle: const TextStyle(
                            color: Colors.white,
                          )),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Cancel".tr,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: mainColor,
                          textStyle: const TextStyle(
                            color: Colors.white,
                          )),
                      onPressed: () {
                        Navigator.pop(context);
                        onPress();
                      },
                      child: Text(
                        "OK".tr,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Positioned(
            top: -60,
            child: CircleAvatar(
              backgroundColor: mainColor,
              radius: 60,
              child: Icon(
                icon,
                color: Colors.white,
                size: 50,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void showError(String message) {
  if (Get.context == null) return;
  // InvalidTokenException or NoBindDataException　の場合,遷移をRoot に戻す

  showCommonDialog(
    context: Get.context!,
    title: "Error".tr,
    content: message,
    backRoot: false,
  );
}

// アラートが表示されているかの分岐
bool _isDialogShowing = false;

void showCommonDialog({
  required BuildContext context,
  String? title,
  String? content,
  TextAlign? contentAlign = TextAlign.center,
  bool backRoot = false,
  VoidCallback? okAction,
}) {
  // アラートが表示されている場合、アラートを追加しない
  if (_isDialogShowing) return;

  _isDialogShowing = true;

  if (Platform.isIOS) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext ctx) {
        return CupertinoAlertDialog(
          title: title != null ? Text(title) : null,
          content:
              content != null ? Text(content, textAlign: contentAlign) : null,
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
                if (backRoot && Navigator.canPop(context)) {
                  Navigator.popUntil(context, (route) => route.isFirst);
                }
              },
              isDefaultAction: false,
              isDestructiveAction: false,
              child: Text(okAction != null ? 'Cancel'.tr : "OK".tr),
            ),
            if (okAction != null)
              CupertinoDialogAction(
                onPressed: () {
                  okAction();
                  Navigator.of(context).pop();
                },
                isDefaultAction: true,
                isDestructiveAction: true,
                child: Text('OK'.tr),
              )
          ],
        );
      },
    ).then((value) => _isDialogShowing = false);
  }
  if (Platform.isAndroid) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: title != null ? Center(child: Text(title)) : null,
          content: content != null
              ? Text(
                  content,
                  textAlign: contentAlign,
                )
              : null,
          actions: [
            TextButton(
              child: Text(okAction != null ? 'Cancel'.tr : "OK".tr),
              onPressed: () {
                Navigator.of(context).pop();
                if (backRoot && Navigator.canPop(context)) {
                  Navigator.popUntil(context, (route) => route.isFirst);
                }
              },
            ),
            if (okAction != null)
              TextButton(
                child: Text('OK'.tr),
                onPressed: () {
                  okAction();
                  Navigator.of(context).pop();
                },
              ),
          ],
        );
      },
    ).then((value) => _isDialogShowing = false);
  }
}
