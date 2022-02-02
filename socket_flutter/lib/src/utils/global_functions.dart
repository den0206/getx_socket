import 'package:country_list_pick/support/code_countries_en.dart';
import 'package:country_list_pick/support/code_country.dart';
import 'package:flutter/material.dart';
import 'package:socket_flutter/src/model/language.dart';

void dismisskeyBord(BuildContext context) {
  FocusScope.of(context).unfocus();
}

String getFileExtension(String fileName) {
  return "." + fileName.split('.').last;
}

CountryCode getCountryFromCode(String code) {
  List<Map> jsonList = countriesEnglish;

  final json = jsonList.where((element) => element["code"] == code).toList()[0];

  final country = CountryCode(
    name: json["name"],
    code: code,
    dialCode: json["dial_code"],
    flagUri: 'flags/${json['code'].toLowerCase()}.png',
  );

  return country;
}

Language getLanguage(String lang) {
  final language =
      Language.values.firstWhere((element) => element.name == lang);
  return language;
}
