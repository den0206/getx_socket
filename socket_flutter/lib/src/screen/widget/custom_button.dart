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
