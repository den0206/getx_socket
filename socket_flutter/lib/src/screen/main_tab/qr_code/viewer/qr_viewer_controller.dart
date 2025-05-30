import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
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
      final result = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        "Cancel",
        true,
        ScanMode.QR,
      );

      if (result == "-1") return;

      String searchId = result;

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
