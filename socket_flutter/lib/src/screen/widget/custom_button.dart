import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.title,
    this.titleColor = Colors.white,
    this.width = 250,
    this.height = 60,
    this.isLoading = false,
    this.background = Colors.blue,
    this.onPressed,
  }) : super(key: key);

  final String title;
  final Color titleColor;
  final Color background;
  final double width;
  final double height;
  final bool isLoading;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(color: titleColor),
        ),
      ),
    );
  }
}

class CustomCircleButton extends StatelessWidget {
  const CustomCircleButton({
    Key? key,
    required this.title,
    required this.icon,
    this.size,
    this.borderColor = Colors.green,
    required this.backColor,
    required this.onPress,
    this.mainColor = Colors.white,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final double? size;
  final Color borderColor;
  final Color backColor;
  final Color mainColor;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: backColor,
          border: Border.all(color: borderColor, width: 2),
          shape: BoxShape.circle,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: size != null ? size! / 2 : null,
              color: mainColor,
            ),
            Text(
              title,
              style: TextStyle(color: mainColor),
            )
          ],
        ),
      ),
    );
  }
}

class CircleImageButton extends StatelessWidget {
  const CircleImageButton({
    Key? key,
    required this.imageProvider,
    required this.size,
    this.fit = BoxFit.cover,
    this.onTap,
  }) : super(key: key);

  final ImageProvider imageProvider;
  final double size;

  final BoxFit fit;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.green,
            width: 2,
          ),
        ),
        child: ClipOval(
          child: Image(
            image: imageProvider,
            fit: fit,
            width: size,
            height: size,
            loadingBuilder: (context, child, event) {
              if (event != null) {
                return Skeleton.leaf(
                  enabled: true,
                  child: child,
                );
              }
              return child;
            },
            errorBuilder: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      ),
    );
  }
}
