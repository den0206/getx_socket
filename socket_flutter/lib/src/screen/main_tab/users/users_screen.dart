import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_flutter/src/model/user.dart';
import 'package:socket_flutter/src/screen/main_tab/users/users_controller.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<UsersController>(
      init: UsersController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Users'),
          ),
          body: ListView.separated(
            separatorBuilder: (context, index) => Divider(
              color: Colors.black,
              height: 1,
            ),
            itemCount: controller.users.length,
            itemBuilder: (context, index) {
              final User user = controller.users[index];

              return UserCell(user: user);
            },
          ),
        );
      },
    );
  }
}

class UserCell extends StatelessWidget {
  const UserCell({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user.name),
      onTap: () {
        print(user.id);
      },
    );
  }
}
