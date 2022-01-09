import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:socket_flutter/src/model/user.dart';
import 'package:socket_flutter/src/screen/main_tab/message/message_extention.dart';
import 'package:socket_flutter/src/screen/main_tab/message/message_screen.dart';
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

    if (chatRoomId == null) {
      print("Not Generate ChatID");
      return;
    }

    Get.until((route) => route.isFirst);

    final MessageExtention extention =
        MessageExtention(chatRoomId: chatRoomId, withUsers: [user]);

    Get.toNamed(MessageScreen.routeName, arguments: extention);
  }
}
