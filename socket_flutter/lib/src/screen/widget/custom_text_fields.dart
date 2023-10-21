import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.inputType,
    this.isSecure = false,
    this.validator,
    this.icon,
    this.onChange,
  });

  final TextEditingController controller;
  final String labelText;
  final TextInputType? inputType;
  final bool isSecure;
  final FormFieldValidator<String?>? validator;
  final Widget? icon;
  final Function(String text)? onChange;

  @override
  Widget build(BuildContext context) {
    RxBool visiblity = isSecure.obs;

    return Obx(
      () {
        return TextFormField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: icon,
            suffixIcon: isSecure
                ? IconButton(
                    icon: Icon(
                      visiblity.value ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      visiblity.toggle();
                    },
                  )
                : null,
            hintText: labelText,
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
              ),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
              ),
            ),
          ),
          cursorColor: Colors.black,
          keyboardType: inputType,
          validator: validator,
          obscureText: visiblity.value,
          onChanged: onChange,
        );
      },
    );
  }
}
