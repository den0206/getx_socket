import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'custom_text_fields.dart';
import 'neumorphic/buttons.dart';

enum VerifyState {
  checkEmail,
  sendPassword,
  verify;

  String get title {
    switch (this) {
      case VerifyState.checkEmail:
        return "Check Email";
      case VerifyState.sendPassword:
        return "Send Password";
      case VerifyState.verify:
        return "Verify";
    }
  }

  String get labelText {
    switch (this) {
      case VerifyState.checkEmail:
        return "Your Email";
      case VerifyState.sendPassword:
        return "New Password";
      case VerifyState.verify:
        return "Verify Number";
    }
  }

  TextInputType get inputType {
    switch (this) {
      case VerifyState.checkEmail:
        return TextInputType.emailAddress;
      case VerifyState.sendPassword:
        return TextInputType.visiblePassword;
      case VerifyState.verify:
        return TextInputType.number;
    }
  }

  bool get isSecure {
    return this != VerifyState.checkEmail;
  }
}

class PinCodeArea extends StatelessWidget {
  const PinCodeArea({
    Key? key,
    required this.currentState,
    required this.currentTX,
    this.onChange,
    this.onPressed,
  }) : super(key: key);

  final VerifyState currentState;
  final TextEditingController currentTX;
  final Function(String)? onChange;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (currentState == VerifyState.verify)
            Text(
              "Please Check Your Email",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Stack(
              children: [
                if (currentState != VerifyState.verify)
                  CustomTextField(
                    controller: currentTX,
                    icon: Icon(
                      Icons.email,
                      color: Colors.grey,
                    ),
                    labelText: currentState.labelText,
                    inputType: currentState.inputType,
                    isSecure: currentState.isSecure,
                    onChange: onChange,
                  ),
                if (currentState == VerifyState.verify)
                  CustomPinCodeField(
                    controller: currentTX,
                    inputType: currentState.inputType,
                    isSecure: currentState.isSecure,
                    onChange: onChange,
                  ),
              ],
            ),
          ),
          Builder(builder: (context) {
            return NeumorphicCustomButtton(
              title: currentState.title,
              background: Colors.green,
              titleColor: Colors.white,
              onPressed: onPressed,
            );
          }),
        ],
      ),
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
