import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:socket_flutter/src/screen/main_tab/users/user_detail/user_detail_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
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
                  title: Text("通知"),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    openAppSettings();
                  },
                ),

                // ListTile(
                //   title: Text("レビュー"),
                //   trailing: Icon(Icons.arrow_forward_ios),
                //   onTap: () {},
                // ),
                ListTile(
                  title: Text("バージョン"),
                  trailing: Text(controller.currentVersion ?? "unknown"),
                ),
                ListTile(
                  title: Text("ブロックリスト"),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    controller.showBlockList();
                  },
                ),
                ListTile(
                  title: Text("お問い合わせ"),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.of(context).pop();
                    controller.showSettings();
                  },
                ),
                ListTile(
                  title: Text("キャッシュの削除"),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () async {
                    await DefaultCacheManager().emptyCache();
                  },
                ),
                ListTile(
                  title: Text("ログアウト"),
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
