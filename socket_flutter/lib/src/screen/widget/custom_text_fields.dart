import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {Key? key,
      required this.controller,
      required this.labelText,
      this.inputType,
      this.isSecure = false,
      this.validator,
      this.icon,
      this.onChange})
      : super(key: key);

  final TextEditingController controller;
  final String labelText;
  final TextInputType? inputType;
  final bool isSecure;
  final FormFieldValidator<String>? validator;
  final Widget? icon;
  final Function(String text)? onChange;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: icon,
        hintText: labelText,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
      ),
      cursorColor: Colors.black,
      keyboardType: inputType,
      validator: validator,
      obscureText: isSecure,
      onChanged: onChange,
    );
  }
}

class CustomPinCodeField extends StatelessWidget {
  const CustomPinCodeField({
    Key? key,
    required this.controller,
    required this.inputType,
    required this.isSecure,
    this.onChange,
  }) : super(key: key);

  final TextEditingController controller;
  final TextInputType inputType;
  final bool isSecure;
  final Function(String text)? onChange;

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      controller: controller,
      length: 6,
      autoFocus: true,
      obscureText: false,
      autoDisposeControllers: true,
      blinkWhenObscuring: true,
      animationType: AnimationType.fade,
      validator: (v) {
        if (v!.length < 6) {
          return "";
        } else {
          return null;
        }
      },
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5),
        fieldHeight: 50,
        fieldWidth: 40,
        activeColor: Colors.grey,
        inactiveColor: Colors.grey,
        selectedColor: Colors.grey,
        activeFillColor: Colors.white,
        inactiveFillColor: Colors.white,
        selectedFillColor: Colors.white,
      ),
      cursorColor: Colors.black,
      animationDuration: Duration(milliseconds: 300),
      enableActiveFill: false,
      keyboardType: inputType,
      onChanged: onChange ?? (value) {},
      beforeTextPaste: (text) {
        print("Allowing to paste $text");

        return true;
      },
    );
  }
}
