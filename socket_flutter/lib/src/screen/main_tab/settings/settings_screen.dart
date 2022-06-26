import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/route_manager.dart';
import 'package:get/utils.dart';
import 'package:intl/intl.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:socket_flutter/src/languages/Locale_lang.dart';
import 'package:socket_flutter/src/screen/main_tab/users/user_detail/user_detail_controller.dart';
import 'package:socket_flutter/src/service/storage_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'.tr),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.close),
          )
        ],
      ),
      body: GetBuilder<UserDetailController>(
        builder: (controller) {
          return ListView(
            shrinkWrap: true,
            children: ListTile.divideTiles(
              context: context,
              tiles: [
                ListTile(
                  title: Text("Notification".tr),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    openAppSettings();
                  },
                ),
                ListTile(
                  title: Text("Version".tr),
                  trailing: Text(controller.currentVersion ?? "unknown"),
                ),
                ListTile(
                  title: Text("Select Language".tr),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    showLocaleLangs(context);
                  },
                ),
                ListTile(
                  title: Text("Block List".tr),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    controller.showBlockList();
                  },
                ),
                ListTile(
                  title: Text("Contact".tr),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.of(context).pop();
                    controller.showSettings();
                  },
                ),
                ListTile(
                  title: Text("Clear Cache".tr),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () async {
                    await DefaultCacheManager().emptyCache();
                  },
                ),
                ListTile(
                  title: Text("Logout".tr),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.of(context).pop();
                    controller.tryLogout(context);
                  },
                ),
              ],
            ).toList(),
          );
        },
      ),
    );
  }
}

Future<dynamic> showLocaleLangs(BuildContext context,
    [Function(LocaleLangs current)? onPressed]) {
  return showDialog(
    context: context,
    builder: (builder) {
      return AlertDialog(
        title: Text("Choose Your Language".tr),
        content: Container(
          width: double.maxFinite,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: LocaleLangs.values.length,
            separatorBuilder: (context, index) => Divider(
              color: Colors.black,
            ),
            itemBuilder: (context, index) {
              final current = LocaleLangs.values[index];
              return ListTile(
                title: Text(
                  current.title,
                ),
                onTap: () async {
                  Get.back();
                  await Get.updateLocale(current.locale);
                  Intl.defaultLocale = current.locale.languageCode;
                  await StorageKey.locale.saveString(current.name);
                  if (onPressed != null) onPressed(current);
                },
              );
            },
          ),
        ),
      );
    },
  );
}



 // ListTile(
  //   title: Text("レビュー"),
  //   trailing: Icon(Icons.arrow_forward_ios),
  //   onTap: () {},
  // ),
