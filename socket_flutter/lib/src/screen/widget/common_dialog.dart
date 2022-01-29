import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    Key? key,
    required this.title,
    required this.descripon,
    required this.onPress,
    required this.icon,
    required this.mainColor,
  }) : super(key: key);

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
            padding: EdgeInsets.fromLTRB(10, 70, 10, 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  descripon,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.grey,
                          textStyle: TextStyle(
                            color: Colors.white,
                          )),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Cancel",
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: mainColor,
                          textStyle: TextStyle(
                            color: Colors.white,
                          )),
                      onPressed: () {
                        Navigator.pop(context);
                        onPress();
                      },
                      child: Text(
                        "OK",
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

Future showError(String? message) {
  return showDialog(
    context: Get.context!,
    builder: (context) {
      return AlertDialog(
        title: Text("Error"),
        content: message != null ? Text(message) : Text("UnknownError"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("OK"),
          ),
        ],
      );
    },
  );
}
