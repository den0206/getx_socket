import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:socket_flutter/src/api/user_api.dart';
import 'package:socket_flutter/src/model/user.dart';
import 'package:socket_flutter/src/screen/widget/common_dialog.dart';

import '../../users/user_detail/user_detail_screen.dart';

class QrViewerController extends GetxController {
  final UserAPI _userAPI = UserAPI();
  User? findUser;

  Future<void> startQrcodeScan() async {
    try {
      final result = await BarcodeScanner.scan(
        options: ScanOptions(
          restrictFormat: [BarcodeFormat.qr],
          strings: {
            'cancel': 'Cancel',
            'flash_on': 'Flash On',
            'flash_off': 'Flash Off',
          },
        ),
      );

      // キャンセルまたは失敗の場合は終了
      if (result.type == ResultType.Cancelled ||
          result.type == ResultType.Error) {
        return;
      }

      String searchId = result.rawContent;

      final res = await _userAPI.getById(id: searchId);
      if (!res.status) return;
      findUser = User.fromMap(res.data);
      update();
    } on FormatException {
      showError("ご利用できないQRです。");
    } on PlatformException {
      showError('Failed to get platform version.');
    } catch (e) {
      showError(e.toString());
    }
  }

  void selectFindUser() {
    if (findUser == null) return;
    Get.to(() => UserDetailScreen(findUser!));
  }

  void resetFindUser() {
    findUser = null;
    update();
  }
}
