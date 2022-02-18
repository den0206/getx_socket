import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socket_flutter/src/utils/global_functions.dart';
import 'package:get/get.dart';

/// MARK  Abstract Class

abstract class LoadingGetController extends GetxController {
  final RxBool isOverlay = false.obs;
}

abstract class LoadingGetView<T extends LoadingGetController>
    extends GetView<T> {
  T get ctr;
  Widget get child;

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<T>()) Get.lazyPut(() => ctr);

    return GestureDetector(
      onTap: () {
        dismisskeyBord(context);
      },
      child: Obx(
        () => Stack(
          fit: StackFit.expand,
          children: [
            child,
            if (controller.isOverlay.value)
              Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(0, 0, 0, 0.6),
                ),
                child: PlainLoadingWidget(),
              )
          ],
        ),
      ),
    );
  }
}

class PlainLoadingWidget extends StatelessWidget {
  const PlainLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          SizedBox(
            height: 24,
          ),
          Text(
            "Loading...",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              decoration: TextDecoration.none,
            ),
          )
        ],
      ),
    );
  }
}

class LoadingCellWidget extends StatelessWidget {
  const LoadingCellWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
          child: CupertinoActivityIndicator(
        radius: 12.0,
      )),
    );
  }
}
