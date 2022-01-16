import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:socket_flutter/src/screen/main_tab/groups/groups_controller.dart';

class GroupsScreen extends GetView<GroupsController> {
  const GroupsScreen({Key? key}) : super(key: key);
  static const routeName = '/GroupScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Groups'),
      ),
      body: Container(),
    );
  }
}
