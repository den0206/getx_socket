import 'package:flutter/material.dart';

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
    return Container(
      height: height,
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(color: titleColor),
        ),
        onPressed: onPressed,
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
    this.addShadow = true,
    this.fit = BoxFit.cover,
    this.onTap,
  }) : super(key: key);

  final ImageProvider imageProvider;
  final double size;
  final bool addShadow;
  final BoxFit fit;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey,
          image: DecorationImage(
            image: imageProvider,
            fit: fit,
          ),
          border: Border.all(color: Colors.green, width: 1),
          boxShadow: addShadow
              ? [
                  BoxShadow(
                    offset: Offset(0, 5),
                    blurRadius: 15.0,
                    color: Colors.grey,
                  ),
                ]
              : null,
        ),
      ),
    );
  }
}
