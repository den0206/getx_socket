import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socket_flutter/src/screen/widget/common_dialog.dart';
import 'package:socket_flutter/src/screen/widget/loading_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ContactController extends LoadingGetController {
  bool connectionStatus = false;
  final contactURL = dotenv.env['CONTACT_URL'];
  late WebViewController webViewController;

  @override
  void onInit() async {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      check();
    });
  }

  Future<void> initWebView() async {
    webViewController = WebViewController();
    await webViewController.setJavaScriptMode(JavaScriptMode.unrestricted);

    await webViewController.setNavigationDelegate(NavigationDelegate(
      onProgress: (int progress) {
        print(progress);
      },
      onPageStarted: (String url) {},
      onPageFinished: (String url) {},
      onWebResourceError: (WebResourceError error) {
        showError("No Internet");
      },
      onNavigationRequest: (NavigationRequest request) {
        // if (request.url.startsWith('https://www.youtube.com/')) {
        //   return NavigationDecision.prevent;
        // }
        return NavigationDecision.navigate;
      },
    ));

    await webViewController.loadRequest(Uri.parse(contactURL!));
  }

  Future check() async {
    isOverlay.call(true);

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        connectionStatus = true;
      }

      await initWebView();
    } on SocketException catch (_) {
      showError("No Internet");
    } catch (e) {
      connectionStatus = false;
      showError(e.toString());
    } finally {
      isOverlay.call(false);
      update();
    }
  }
}
