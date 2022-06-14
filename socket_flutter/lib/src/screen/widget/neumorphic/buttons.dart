import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:socket_flutter/src/utils/consts_color.dart';

import '../../../utils/neumorpic_style.dart';
import '../custom_button.dart';
import 'package:sizer/sizer.dart';

class NeumorphicCustomButtton extends StatelessWidget {
  const NeumorphicCustomButtton({
    Key? key,
    required this.title,
    this.titleColor = Colors.white,
    this.width = 250,
    this.height = 60,
    this.background,
    this.onPressed,
  }) : super(key: key);

  final String title;
  final Color titleColor;
  final double width;
  final double height;
  final Color? background;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: NeumorphicButton(
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: titleColor,
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onPressed: onPressed,
        style: commonNeumorphic(
          color:
              onPressed != null ? background : ConstsColor.mainBackgroundColor,
          // lightSource: LightSource.bottomRight,
          depth: 1.2,
        ),
      ),
    );
  }
}

class NeumorphicIconButton extends StatelessWidget {
  const NeumorphicIconButton({
    Key? key,
    required this.icon,
    this.color,
    this.depth,
    this.onPressed,
    this.boxShape,
  }) : super(key: key);

  final Widget icon;

  final Color? color;

  final double? depth;
  final NeumorphicBoxShape? boxShape;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      padding: EdgeInsets.all(10),
      style: NeumorphicStyle(
        boxShape: boxShape ?? NeumorphicBoxShape.circle(),
        color: color ?? ConstsColor.mainBackgroundColor,
        depth: depth ?? 1,
        intensity: 2,
      ),
      child: icon,
      onPressed: onPressed,
    );
  }
}

class NeumorphicAvatarButton extends StatelessWidget {
  const NeumorphicAvatarButton({
    Key? key,
    required this.imageProvider,
    this.size = 120,
    this.onTap,
  }) : super(key: key);

  final ImageProvider<Object> imageProvider;
  final double size;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      padding: EdgeInsets.all(10),
      style: NeumorphicStyle(
        boxShape: NeumorphicBoxShape.circle(),
        color: ConstsColor.mainBackgroundColor,
        depth: 1,
        intensity: 2,
        // depth: NeumorphicTheme.embossDepth(context),
      ),
      child: CircleImageButton(
        imageProvider: imageProvider,
        size: size,
        onTap: onTap,
      ),
    );
  }
}

class NeumorphicTextButton extends StatelessWidget {
  const NeumorphicTextButton({
    Key? key,
    required this.title,
    this.titleColor = Colors.green,
    this.onPressed,
  }) : super(key: key);

  final String title;
  final Color titleColor;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: NeumorphicText(
        title,
        style: NeumorphicStyle(
          intensity: 1,
          depth: 1,
          color: titleColor,
          surfaceIntensity: 2,
        ),
        textStyle: NeumorphicTextStyle(fontWeight: FontWeight.bold),
      ),
      onPressed: onPressed ?? null,
    );
  }
}
