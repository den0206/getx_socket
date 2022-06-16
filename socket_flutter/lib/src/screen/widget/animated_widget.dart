import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class FadeinWidget extends StatefulWidget {
  FadeinWidget({Key? key, required this.child, this.duration})
      : super(key: key);

  final Widget child;
  final Duration? duration;

  @override
  State<FadeinWidget> createState() => _FadeinWidgetState();
}

class _FadeinWidgetState extends State<FadeinWidget>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: widget.duration == null
          ? Duration(milliseconds: 600)
          : widget.duration,
    );

    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    controller.forward();

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.stop();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    animation.removeStatusListener((status) {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: widget.child,
    );
  }
}

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({
    Key? key,
    required this.title,
    required this.path,
  }) : super(key: key);

  final String title;
  final String path;

  @override
  Widget build(BuildContext context) {
    return FadeinWidget(
      duration: Duration(seconds: 1),
      child: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(
              height: 20,
            ),
            LottieBuilder.asset(
              path,
              width: 300,
              height: 300,
            ),
          ],
        ),
      ),
    );
  }
}
