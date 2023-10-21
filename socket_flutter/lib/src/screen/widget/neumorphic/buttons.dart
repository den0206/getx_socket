import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sizer/sizer.dart';
import 'package:socket_flutter/src/utils/consts_color.dart';

import '../../../utils/neumorpic_style.dart';
import '../custom_button.dart';

class NeumorphicCustomButtton extends StatelessWidget {
  const NeumorphicCustomButtton({
    super.key,
    required this.title,
    this.titleColor = Colors.white,
    this.width = 250,
    this.height = 60,
    this.background,
    this.onPressed,
  });

  final String title;
  final Color titleColor;
  final double width;
  final double height;
  final Color? background;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: NeumorphicButton(
        onPressed: onPressed,
        style: commonNeumorphic(
          color:
              onPressed != null ? background : ConstsColor.mainBackgroundColor,
          // lightSource: LightSource.bottomRight,
          depth: 1.2,
        ),
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
      ),
    );
  }
}

class NeumorphicIconButton extends StatelessWidget {
  const NeumorphicIconButton({
    super.key,
    required this.icon,
    this.color,
    this.depth,
    this.onPressed,
    this.boxShape,
  });

  final Widget icon;

  final Color? color;

  final double? depth;
  final NeumorphicBoxShape? boxShape;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      padding: const EdgeInsets.all(10),
      style: NeumorphicStyle(
        boxShape: boxShape ?? const NeumorphicBoxShape.circle(),
        color: color ?? ConstsColor.mainBackgroundColor,
        depth: depth ?? 1,
        intensity: 2,
      ),
      onPressed: onPressed,
      child: icon,
    );
  }
}

class NeumorphicAvatarButton extends StatelessWidget {
  const NeumorphicAvatarButton({
    super.key,
    required this.imageProvider,
    this.size = 120,
    this.onTap,
  });

  final ImageProvider<Object> imageProvider;
  final double size;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      padding: const EdgeInsets.all(10),
      style: const NeumorphicStyle(
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
    super.key,
    required this.title,
    this.titleColor = Colors.green,
    this.onPressed,
  });

  final String title;
  final Color titleColor;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
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
    );
  }
}
