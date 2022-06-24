import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:socket_flutter/src/model/message.dart';
import 'package:sizer/sizer.dart';
import 'package:socket_flutter/src/screen/widget/common_dialog.dart';
import 'package:socket_flutter/src/service/image_extention.dart';
import 'package:socket_flutter/src/utils/global_functions.dart';

class ImageBubble extends StatelessWidget {
  const ImageBubble({Key? key, required this.message}) : super(key: key);
  final Message message;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(ImageDetailScreen(imageUrl: message.imageUrl!));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            (Radius.circular(8)),
          ),
          border: Border.all(color: Colors.grey, width: 2),
        ),
        child: Image.network(
          message.imageUrl!,
          width: 50.w,
          height: 50.w,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              margin: EdgeInsets.only(bottom: 10, right: 10.0),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
              width: 50.w,
              height: 50.w,
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                  value: loadingProgress.expectedTotalBytes != null &&
                          loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container();
          },
        ),
      ),
    );
  }
}

class ImageDetailScreen extends StatelessWidget {
  const ImageDetailScreen({Key? key, required this.imageUrl}) : super(key: key);
  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(
                Icons.download,
                color: Colors.white,
              ),
              onPressed: () {
                showCommonDialog(
                    context: context,
                    title: "Image",
                    content: "Donwload Image??",
                    okAction: () async {
                      final result =
                          await ImageExtention().downloadImage(imageUrl);

                      if (result) {
                        showSnackBar(
                          title: "Success",
                          message: "Dowmload Image",
                          position: SnackPosition.TOP,
                        );
                      }
                    });
              },
            )
          ],
        ),
        body: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: FadeInImage(
              image: Image.network(imageUrl).image,
              placeholder: AssetImage("assets/images/default_user.png"),
            ),
          ),
        ),
      ),
    );
  }
}
