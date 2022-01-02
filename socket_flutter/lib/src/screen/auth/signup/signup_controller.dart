import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/route_manager.dart';
import 'package:socket_flutter/src/api/user_api.dart';

class SignUpController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emaiController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final userAPI = UserAPI();

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> signUp() async {
    final Map<String, dynamic> userData = {
      "name": nameController.text,
      "email": emaiController.text,
      "password": passwordController.text,
    };

    final result = await userAPI.signUp(userData);

    if (result.status) {
      Get.back(result: result);
    }
  }
}
