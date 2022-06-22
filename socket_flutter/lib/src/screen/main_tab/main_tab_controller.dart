import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/route_manager.dart';
import 'package:socket_flutter/src/service/notification_service.dart';

class MainTabController extends GetxController {
  static MainTabController get to => Get.find();
  var currentIndex = 0;

  @override
  void onInit() async {
    super.onInit();
    await registerNotification();
  }

  void setIndex(int index) {
    currentIndex = index;
    update();
  }
}
