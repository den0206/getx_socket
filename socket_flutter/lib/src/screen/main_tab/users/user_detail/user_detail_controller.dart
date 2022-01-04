import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:socket_flutter/src/model/user.dart';
import 'package:socket_flutter/src/service/auth_service.dart';
import 'package:socket_flutter/src/service/create_recent.dart';

class UserDetailController extends GetxController {
  UserDetailController(this.user);

  final User user;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> startPrivateChat() async {
    if (user.isCurrent) return;

    final cr = CreateRecent();
    final currentUser = AuthService.to.currentUser.value!;

    final chatRoomId =
        await cr.createChatRoom(currentUser.id, user.id, [currentUser, user]);

    print(chatRoomId);
  }
}
