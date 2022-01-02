import 'package:flutter/material.dart';
import 'package:socket_flutter/src/screen/widget/custom_button.dart';
import 'package:socket_flutter/src/service/auth_service.dart';

class MainTabScreen extends StatelessWidget {
  const MainTabScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Title'),
      ),
      body: Center(
        child: CustomButton(
          title: "Logout",
          background: Colors.red,
          onPressed: () async {
            await AuthService.to.logout();
          },
        ),
      ),
    );
  }
}
