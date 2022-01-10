import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:socket_flutter/src/model/recent.dart';
import 'package:socket_flutter/src/screen/main_tab/recents/recents_controller.dart';

class RecentsScreen extends StatelessWidget {
  const RecentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecentsController>(
      init: RecentsController(),
      autoRemove: false,
      builder: (controller) {
        return CupertinoPageScaffold(
          backgroundColor: Colors.green,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                toolbarHeight: 70,
                title: Text("Recents"),
              ),
              CupertinoSliverRefreshControl(
                onRefresh: () async {
                  await controller.reLoad();
                },
              ),
              SliverToBoxAdapter(
                child: Container(
                  // color: Colors.green,
                  height: 20,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(20.0),
                            topRight: const Radius.circular(20.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final recent = controller.recents[index];
                  return RecentCell(recent: recent);
                }, childCount: controller.recents.length),
              ),
              SliverFillRemaining(
                child: Container(
                  color: Colors.white,
                ),
                hasScrollBody: false,
                fillOverscroll: true,
              ),
            ],
          ),
        );
      },
    );
  }
}

class RecentCell extends GetView<RecentsController> {
  const RecentCell({Key? key, required this.recent}) : super(key: key);

  final Recent recent;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        controller.pushMessageScreen(recent);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                bottom: BorderSide(color: Colors.grey.shade300, width: 0.5))),
        child: Slidable(
          key: Key(recent.id),
          endActionPane: ActionPane(
            motion: ScrollMotion(),
            extentRatio: 0.25,
            children: [
              SlidableAction(
                backgroundColor: Colors.red,
                label: "Delete",
                icon: Icons.delete,
                onPressed: (context) {
                  controller.deleteRecent(recent);
                },
              )
            ],
          ),
          child: Row(
            children: [
              Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black,
                      width: 3,
                    ),
                  )),
              SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    recent.withUser!.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xff686795),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    constraints: BoxConstraints(minWidth: 100, maxWidth: 200),
                    child: Text(
                      recent.lastMessage,
                      maxLines: 2,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
