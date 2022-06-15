import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:socket_flutter/src/screen/main_tab/users/user_detail/user_detail_controller.dart';
import 'package:socket_flutter/src/screen/widget/neumorphic/buttons.dart';
import '../../../model/user.dart';
import '../../widget/loading_widget.dart';

class ReportScreen extends LoadingGetView<UserDetailController> {
  final User user;

  ReportScreen(this.user);
  @override
  UserDetailController get ctr => UserDetailController(user);

  @override
  Widget get child {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Report ${user.name}',
          style: TextStyle(
            color: Colors.red,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 30),
                constraints: BoxConstraints(maxWidth: 80.w),
                child: TextField(
                  controller: controller.reportField,
                  // autofocus: true,
                  cursorColor: Colors.black,
                  maxLines: 10,
                  // maxLength: 200,
                  style: TextStyle(fontSize: 17),
                  decoration: InputDecoration(
                    hintText: "Report about ${user.name}",
                    focusColor: Colors.black,
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    contentPadding: const EdgeInsets.all(10),
                  ),
                  // onChanged: controller.streamText,
                ),
              ),
              Builder(builder: (context) {
                return NeumorphicCustomButtton(
                  title: "Send",
                  background: Colors.green,
                  onPressed: !controller.enableReport.value
                      ? null
                      : () {
                          controller.sendReport(context);
                        },
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
