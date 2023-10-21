import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:socket_flutter/src/utils/neumorpic_style.dart';

class NeumorphicCustomTextField extends StatelessWidget {
  const NeumorphicCustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.inputType,
    this.isSecure = false,
    this.validator,
    this.autoFocus,
    this.padding,
    this.icon,
    this.onChange,
  });

  final TextEditingController controller;
  final String labelText;
  final TextInputType? inputType;
  final bool isSecure;
  final FormFieldValidator<String>? validator;
  final bool? autoFocus;
  final EdgeInsets? padding;
  final Widget? icon;
  final Function(String text)? onChange;

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      margin: const EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 4),
      style: commonNeumorphic(
        depth: -10,
        boxShape: const NeumorphicBoxShape.stadium(),
      ),
      padding:
          padding ?? const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: icon,
          hintText: labelText,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
        cursorColor: Colors.black,
        keyboardType: inputType,
        validator: validator,
        obscureText: isSecure,
        autofocus: autoFocus ?? false,
        onChanged: onChange,
      ),
    );
  }
}
