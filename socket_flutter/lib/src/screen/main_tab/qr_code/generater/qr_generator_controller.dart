import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:socket_flutter/src/api/user_api.dart';
import 'package:socket_flutter/src/model/user.dart';
import 'package:socket_flutter/src/screen/widget/common_dialog.dart';
import 'package:socket_flutter/src/service/auth_service.dart';
import 'package:uuid/uuid.dart';

class QrGeneratorController extends GetxController {
  final UserAPI _userAPI = UserAPI();
  bool isLoading = false;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> updateSearchId() async {
    isLoading = true;
    update();

    await Future.delayed(Duration(seconds: 1));
    try {
      final Map<String, dynamic> data = {"searchId": Uuid().v4()};

      final res = await _userAPI.editUser(userData: data);
      if (!res.status) return;
      final newUser = User.fromMap(res.data);
      await AuthService.to.updateUser(newUser);
      update();
    } catch (e) {
      showError(e.toString());
    } finally {
      isLoading = false;
    }
  }
}
