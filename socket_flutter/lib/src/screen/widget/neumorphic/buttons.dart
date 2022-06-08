import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:socket_flutter/src/utils/consts_color.dart';

import '../custom_button.dart';

class NeumorphicIconButton extends StatelessWidget {
  const NeumorphicIconButton({
    Key? key,
    required this.iconData,
    this.color,
    this.iconColor,
    this.size,
    this.depth,
    this.onPressed,
  }) : super(key: key);

  final IconData iconData;
  final Color? iconColor;
  final Color? color;
  final double? size;
  final double? depth;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      padding: EdgeInsets.all(10),
      style: NeumorphicStyle(
        boxShape: NeumorphicBoxShape.circle(),
        color: color ?? ConstsColor.mainBackgroundColor,
        depth: depth ?? 1,
        intensity: 2,
      ),
      child: Icon(
        iconData,
        size: size,
        color: iconColor,
      ),
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
