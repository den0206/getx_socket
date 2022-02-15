import 'package:flutter/material.dart';
import 'package:socket_flutter/src/screen/main_tab/qr_code/generater/qr_generator_screen.dart';
import 'package:socket_flutter/src/screen/main_tab/qr_code/viewer/qr_viewer_screen.dart';

class QrTabScreen extends StatelessWidget {
  const QrTabScreen({Key? key}) : super(key: key);

  static const routeName = '/QrTabScreen';

  @override
  Widget build(BuildContext context) {
    final List<Widget> _tabView = [QrGenerateScreen(), QrViewerScreen()];

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('QRCode'),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(20),
            child: TabBar(
              indicatorColor: Colors.white,
              indicatorWeight: 4,
              tabs: [
                Tab(child: Text("Generate", style: TextStyle(fontSize: 20.0))),
                Tab(child: Text("Viewer", style: TextStyle(fontSize: 20.0))),
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
