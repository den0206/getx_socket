import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:socket_flutter/src/model/recent.dart';
import 'package:socket_flutter/src/screen/main_tab/main_tab_controller.dart';
import 'package:socket_flutter/src/screen/main_tab/recents/recents_controller.dart';
import 'package:socket_flutter/src/screen/widget/animated_widget.dart';
import 'package:socket_flutter/src/screen/widget/overlap_avatars.dart';
import 'package:socket_flutter/src/screen/widget/user_country_widget.dart';
import 'package:socket_flutter/src/service/auth_service.dart';
import 'package:socket_flutter/src/utils/consts_color.dart';

import '../../../utils/neumorpic_style.dart';

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
                leading: Center(
                  child: UserCountryWidget(
                    user: AuthService.to.currentUser.value!,
                    size: 35,
                    onTap: () {
                      MainTabController.to.setIndex(2);
                    },
                  ),
                ),
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
                          color: ConstsColor.mainBackgroundColor,
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

                  if (index == controller.recents.length - 1) {
                    controller.loadRecents();
                  }
                  return NeumorphicRecentCell(recent: recent);
                }, childCount: controller.recents.length),
              ),
              SliverFillRemaining(
                child: Container(
                  alignment: Alignment.center,
                  color: ConstsColor.mainBackgroundColor,
                  child: controller.recents.isEmpty
                      ? EmptyScreen(
                          title: "No Message",
                          path: "assets/lotties/chat_girl.json",
                        )
                      : null,
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

class NeumorphicRecentCell extends GetView<RecentsController> {
  const NeumorphicRecentCell({Key? key, required this.recent})
      : super(key: key);

  final Recent recent;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        controller.pushMessageScreen(recent);
      },
      child: Container(
        color: ConstsColor.mainBackgroundColor,
        child: Neumorphic(
          style: commonNeumorphic(depth: 0.6),
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                recent.type == RecentType.private
                    ? UserCountryWidget(
                        user: recent.withUser!,
                        size: 35,
                      )
                    : OverlapAvatars(users: recent.group!.members),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      recent.type == RecentType.private
                          ? recent.withUser!.name
                          : recent.group?.title ?? "Group",
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
                if (recent.counter != 0) ...[
                  Spacer(),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                    child: Center(
                        child: Text(
                      "${recent.counter}",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )),
                  )
                ]
              ],
            ),
          ),
        ),
      ),
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
            color: ConstsColor.mainBackgroundColor,
            border:
                Border(bottom: BorderSide(color: Colors.black, width: 0.5))),
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
              recent.type == RecentType.private
                  ? UserCountryWidget(
                      user: recent.withUser!,
                      size: 35,
                    )
                  : OverlapAvatars(users: recent.group!.members),
              SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    recent.type == RecentType.private
                        ? recent.withUser!.name
                        : recent.group?.title ?? "Group",
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
              if (recent.counter != 0) ...[
                Spacer(),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                  ),
                  child: Center(
                      child: Text(
                    "${recent.counter}",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}

/// MARK  For android
class CustomClampingScrollPhysics extends ClampingScrollPhysics {
  const CustomClampingScrollPhysics({
    required ScrollPhysics parent,
    this.canUnderscroll = false,
    this.canOverscroll = false,
  }) : super(parent: parent);

  final bool canUnderscroll;

  final bool canOverscroll;

  @override
  ClampingScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomClampingScrollPhysics(
        parent: buildParent(ancestor)!,
        canUnderscroll: canUnderscroll,
        canOverscroll: canOverscroll);
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    if (value < position.pixels &&
        position.pixels <= position.minScrollExtent) // underscroll
      return canUnderscroll ? 0.0 : value - position.pixels;
    if (position.maxScrollExtent <= position.pixels &&
        position.pixels < value) // overscroll
      return canOverscroll ? 0.0 : value - position.pixels;
    if (value < position.minScrollExtent &&
        position.minScrollExtent < position.pixels) // hit top edge
      return value - position.minScrollExtent;
    if (position.pixels < position.maxScrollExtent &&
        position.maxScrollExtent < value) // hit bottom edge
      return value - position.maxScrollExtent;
    return 0.0;
  }
}
