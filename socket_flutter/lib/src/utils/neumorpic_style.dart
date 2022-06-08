import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:socket_flutter/src/utils/consts_color.dart';

NeumorphicStyle commonNeumorphic(
    {NeumorphicBoxShape? boxShape,
    double? depth,
    Color? color,
    Color? shadowColor,
    LightSource? lightSource}) {
  return NeumorphicStyle(
    shape: NeumorphicShape.concave,
    boxShape:
        boxShape ?? NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
    depth: depth ?? 10,
    lightSource: lightSource ?? LightSource.topLeft,
    color: color,
    shadowLightColor: shadowColor,
    intensity: 1,
  );
}

NeumorphicRadioStyle commonRatioStyle({Color? selectedColor}) {
  return NeumorphicRadioStyle(
    selectedColor: selectedColor,
    unselectedColor: ConstsColor.mainBackgroundColor,
    intensity: 1,
    selectedDepth: -5,
    unselectedDepth: 5,
    boxShape: NeumorphicBoxShape.circle(),
  );
}
