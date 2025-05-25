import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:socket_flutter/src/utils/validator.dart';

import 'custom_text_fields.dart';
import 'neumorphic/buttons.dart';

enum VerifyState {
  checkEmail,
  sendPassword,
  verify;

  String get title {
    switch (this) {
      case VerifyState.checkEmail:
        return "Check Email".tr;
      case VerifyState.sendPassword:
        return "Send Password".tr;
      case VerifyState.verify:
        return "Verify Number".tr;
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

  int get minLength {
    switch (this) {
      case VerifyState.checkEmail:
        return 1;
      case VerifyState.sendPassword:
        return 5;
      case VerifyState.verify:
        return 6;
    }
  }

  String? validator(String? value) {
    switch (this) {
      case VerifyState.checkEmail:
        return validateEmail(value);
      case VerifyState.sendPassword:
        return validPassword(value);
      case VerifyState.verify:
        return null;
    }
  }
}

class PinCodeArea extends StatelessWidget {
  const PinCodeArea({
    super.key,
    required this.currentState,
    required this.currentTX,
    this.onChange,
    this.onPressed,
  });

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
              "Please Check Your Email".tr,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Stack(
              children: [
                if (currentState != VerifyState.verify)
                  CustomTextField(
                    controller: currentTX,
                    icon: const Icon(Icons.email, color: Colors.grey),
                    labelText: currentState.title,
                    inputType: currentState.inputType,
                    isSecure: currentState.isSecure,
                    validator: currentState.validator,
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
          Builder(
            builder: (context) {
              return NeumorphicCustomButtton(
                title: currentState.title,
                background: Colors.green,
                titleColor: Colors.white,
                onPressed: onPressed,
              );
            },
          ),
        ],
      ),
    );
  }
}

class CustomPinCodeField extends StatelessWidget {
  const CustomPinCodeField({
    super.key,
    required this.controller,
    required this.inputType,
    required this.isSecure,
    this.onChange,
  });

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
      animationDuration: const Duration(milliseconds: 300),
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
