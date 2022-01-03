import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class MainTabController extends GetxController {
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
