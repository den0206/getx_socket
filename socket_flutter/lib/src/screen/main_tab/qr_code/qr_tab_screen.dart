import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:socket_flutter/src/screen/main_tab/qr_code/generater/qr_generator_screen.dart';
import 'package:socket_flutter/src/screen/main_tab/qr_code/viewer/qr_viewer_screen.dart';

class QrTabScreen extends StatelessWidget {
  const QrTabScreen({super.key});

  static const routeName = '/QrTabScreen';

  @override
  Widget build(BuildContext context) {
    final List<Widget> _tabView = [
      const QrGenerateScreen(),
      const QrViewerScreen()
    ];

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(20),
            child: TabBar(
              indicatorColor: Colors.green,
              indicatorWeight: 4,
              tabs: [
                Tab(
                    child: Text(
                  "Generate".tr,
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.black54,
                  ),
                )),
                Tab(
                    child: Text(
                  "Viewer".tr,
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.black54,
                  ),
                )),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: _tabView,
        ),
      ),
    );
  }
}
