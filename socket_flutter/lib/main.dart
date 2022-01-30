import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:sizer/sizer.dart';
import 'package:socket_flutter/src/app_root.dart';

import 'src/screen/root_screen.dart';
import 'src/service/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.put(StorageService()).initStorage();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          title: 'Socket_Flutter',
          theme: ThemeData(
              primarySwatch: Colors.blue,
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.green,
              )),
          getPages: AppRoot.pages,
          initialRoute: RootScreen.routeName,
        );
      },
    );
  }
}
