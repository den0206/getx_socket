import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:socket_flutter/src/api/user_api.dart';
import 'package:socket_flutter/src/model/user.dart';
import 'package:socket_flutter/src/screen/widget/common_dialog.dart';

class QrViewerController extends GetxController {
  final UserAPI _userAPI = UserAPI();
  User? findUser;

  Future<void> startQrcodeScan() async {
    try {
      final result = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', "Cancel", true, ScanMode.QR);

      if (result == "-1") throw Exception("Can't Scan QR");

      String searchId = result;

      final res = await _userAPI.getById(id: searchId);
      if (!res.status) return;
      findUser = User.fromMap(res.data);
      update();
    } on PlatformException {
      showError('Failed to get platform version.');
    } catch (e) {
      showError(e.toString());
    }
  }

  void selectFindUser() {
    Get.back(result: findUser);
  }
}
