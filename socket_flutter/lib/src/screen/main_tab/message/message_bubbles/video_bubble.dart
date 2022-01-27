import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:socket_flutter/src/model/message.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';

class VideoBubbleController extends GetxController {
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;

  final String videoUrl;
  final RxBool isPlayng = false.obs;

  VideoBubbleController(
    this.videoUrl,
  );

  @override
  void onInit() async {
    print("Cal");
    super.onInit();
    videoPlayerController = VideoPlayerController.network(videoUrl);

    await videoPlayerController.initialize();

    await videoPlayerController.setVolume(0.3);
    await videoPlayerController.setLooping(false);
    await videoPlayerController.pause();

    videoPlayerController.addListener(
      () {
        if (videoPlayerController.value.position ==
            videoPlayerController.value.duration) {
          if (!chewieController.isFullScreen) isPlayng.value = false;
          update();
        }
      },
    );
    print(videoPlayerController.value.size.aspectRatio);

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: false,
      autoInitialize: true,
      aspectRatio: videoPlayerController.value.size.aspectRatio,
      fullScreenByDefault: false,
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.portraitUp,
      ],
      deviceOrientationsOnEnterFullScreen: [
        DeviceOrientation.landscapeLeft,
      ],
      placeholder: Container(
        color: Colors.black87,
        child: Container(
          child: Center(
              child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )),
        ),
      ),
    );
  }

  @override
  void onClose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.onClose();
  }

  void playVideo() async {
    if (!videoPlayerController.value.isInitialized) return;
    chewieController.togglePause();
    isPlayng.toggle();

    update();
  }
}

class VideoBubble extends StatelessWidget {
  const VideoBubble({Key? key, required this.message}) : super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VideoBubbleController>(
      init: VideoBubbleController(message.videoUrl!),
      builder: (controller) {
        return GestureDetector(
          onTap: () {
            controller.playVideo();
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 10, right: 10.0),
            constraints: BoxConstraints(
              maxHeight: 250,
              maxWidth: 300,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
              color: Colors.black,
            ),
            child: !controller.isPlayng.value
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.network(
                        message.imageUrl!,
                        width: 50.w,
                        height: 50.w,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return ErrorImageWidget();
                        },
                      ),
                      Icon(
                        Icons.play_circle_fill,
                        color: Colors.black,
                        size: 80,
                      )
                    ],
                  )
                : Chewie(
                    controller: controller.chewieController,
                  ),
          ),
        );
      },
    );
  }
}

class ErrorImageWidget extends StatelessWidget {
  const ErrorImageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Image.asset(
        'assets/images/logo.png',
        width: 200.0,
        height: 200.0,
        fit: BoxFit.cover,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(8.0),
      ),
      clipBehavior: Clip.hardEdge,
    );
  }
}
