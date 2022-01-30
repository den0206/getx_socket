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

class CircleImageButton extends StatelessWidget {
  const CircleImageButton({
    Key? key,
    required this.imageProvider,
    required this.size,
    this.addShadow = true,
    this.onTap,
  }) : super(key: key);

  final ImageProvider imageProvider;
  final double size;
  final bool addShadow;
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
            fit: BoxFit.cover,
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
