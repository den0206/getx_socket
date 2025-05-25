import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_flutter/src/utils/global_functions.dart';

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
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(0, 0, 0, 0.6),
                ),
                child: const PlainLoadingWidget(),
              ),
          ],
        ),
      ),
    );
  }
}

class PlainLoadingWidget extends StatelessWidget {
  const PlainLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          const SizedBox(height: 24),
          Text(
            "Loading...".tr,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }
}

class LoadingCellWidget extends StatelessWidget {
  const LoadingCellWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Center(child: CupertinoActivityIndicator(radius: 12.0)),
    );
  }
}
