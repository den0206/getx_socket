import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:socket_flutter/src/screen/main_tab/blocks/block_list_controller.dart';
import 'package:socket_flutter/src/screen/main_tab/users/users_screen.dart';

class BlockListScreen extends StatelessWidget {
  const BlockListScreen({Key? key}) : super(key: key);

  static const routeName = '/BlockList';

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BlockListController>(
      init: BlockListController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Block List'.tr),
          ),
          body: ListView.separated(
            separatorBuilder: (context, index) => Divider(),
            itemCount: controller.blocks.length,
            itemBuilder: (context, index) {
              final user = controller.blocks[index];
              return Slidable(
                key: Key(user.id),
                endActionPane: ActionPane(
                  motion: ScrollMotion(),
                  extentRatio: 0.25,
                  children: [
                    SlidableAction(
                      backgroundColor: Colors.yellow,
                      label: "Block deletion".tr,
                      icon: Icons.message,
                      onPressed: (context) {
                        controller.blockUser(user);
                      },
                    )
                  ],
                ),
                child: UserCell(
                  user: user,
                  onTap: () {
                    controller.tryUnblock(context, user);
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
