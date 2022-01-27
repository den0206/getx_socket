import 'package:flutter/material.dart';
import 'package:socket_flutter/src/model/message.dart';
import 'package:sizer/sizer.dart';

class ImageBubble extends StatelessWidget {
  const ImageBubble({Key? key, required this.message}) : super(key: key);
  final Message message;

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
