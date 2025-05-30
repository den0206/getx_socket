import 'package:collection/collection.dart';
import 'package:country_list_pick/support/code_countries_en.dart';
import 'package:country_list_pick/support/code_country.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_flutter/src/model/language.dart';

void dismisskeyBord(BuildContext context) {
  FocusScope.of(context).unfocus();
}

String getFileExtension(String fileName) {
  return ".${fileName.split('.').last}";
}

List<CountryCode> getAllCountry() {
  List<Map> jsonList = countriesEnglish;

  final countries = jsonList
      .map(
        (json) => CountryCode(
          name: json["name"],
          code: json["code"],
          dialCode: json["dial_code"],
          flagUri: 'flags/${json['code'].toLowerCase()}.png',
        ),
      )
      .toList();

  return countries;
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
  final language = Language.values.firstWhere(
    (element) => element.name == lang,
  );
  return language;
}

Map<int, String> extractrMap(Map<int, String> oldMap, Map<int, String> newMap) {
  final Map<int, String> res = Map<int, String>();

  for (var map in newMap.entries) {
    final index = oldMap.keys.firstWhereOrNull((o) => map.key == o);
    if (index != null) {
      if (map.value != oldMap[map.key]) res[index] = map.value;
    } else {
      res[map.key] = map.value;
    }
  }
  return res;
}

void showSnackBar({
  required String title,
  required String message,
  Color background = Colors.green,
  SnackPosition position = SnackPosition.BOTTOM,
}) {
  Get.snackbar(
    title,
    message,
    icon: const Icon(Icons.person, color: Colors.white),
    snackPosition: position,
    backgroundColor: background,
    borderRadius: 20,
    margin: const EdgeInsets.all(15),
    colorText: Colors.white,
    duration: const Duration(seconds: 4),
    isDismissible: true,
    dismissDirection: DismissDirection.down,
    forwardAnimationCurve: Curves.easeOutBack,
  );
}

String? httpsToHttp({required String? value}) {
  if (value == null) return null;
  if (value.contains("https")) return value.replaceFirst("https", "http");
  return value;
}
