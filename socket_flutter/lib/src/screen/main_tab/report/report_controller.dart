import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:socket_flutter/src/api/report_api.dart';
import 'package:socket_flutter/src/model/message.dart';
import 'package:socket_flutter/src/model/user.dart';
import 'package:socket_flutter/src/screen/widget/loading_widget.dart';

import '../../../utils/global_functions.dart';
import '../../widget/common_dialog.dart';

class ReportController extends LoadingGetController {
  final User user;
  final Message? message;

  final reportField = TextEditingController();

  RxBool get enableReport {
    return (reportField.text.isNotEmpty && !user.isCurrent).obs;
  }

  ReportController({required this.user, this.message});

  @override
  void onClose() async {
    print("Dismiss Report");
    super.onClose();
  }

  Future<void> sendReport(BuildContext context) async {
    if (user.isCurrent) return;
    final ReportAPI _reportAPI = ReportAPI();
    isOverlay.call(true);
    await Future.delayed(const Duration(seconds: 1));
    try {
      final reportData = {
        "reported": user.id,
        "reportedContent": reportField.text,
        "message": message?.id,
      };
      await _reportAPI.sendReport(reportData: reportData);

      reportField.clear();
      Navigator.of(context).pop();
      showSnackBar(
        title: "Thank you Report!",
        message: "We will check soon!",
        background: Colors.red,
      );
    } catch (e) {
      isOverlay.call(false);
      showError(e.toString());
    }
  }
}
