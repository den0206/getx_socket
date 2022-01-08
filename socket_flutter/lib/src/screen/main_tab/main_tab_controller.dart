import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/route_manager.dart';

class MainTabController extends GetxController {
  static MainTabController get to => Get.find();
  var currentIndex = 0;

  @override
  void onInit() {
    super.onInit();
  }

  void setIndex(int index) {
    currentIndex = index;
    update();
  }
}
