import 'package:flutter/material.dart';

void dismisskeyBord(BuildContext context) {
  FocusScope.of(context).unfocus();
}

String getFileExtension(String fileName) {
  return "." + fileName.split('.').last;
}
