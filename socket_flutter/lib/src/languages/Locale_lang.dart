import "package:flutter/material.dart";
import "package:get/get.dart";

enum LocaleLangs {
  English,
  Japanese,
  Chinese;

  Locale get locale {
    switch (this) {
      case LocaleLangs.English:
        return Locale("en", "US");
      case LocaleLangs.Japanese:
        return Locale("ja", "JP");
      case LocaleLangs.Chinese:
        return Locale("zh", "CN");
    }
  }

  String get title {
    switch (this) {
      case LocaleLangs.English:
        return "English".tr;
      case LocaleLangs.Japanese:
        return "Japanese".tr;
      case LocaleLangs.Chinese:
        return "Chinese".tr;
    }
  }

  String get termsPath {
    switch (this) {
      case LocaleLangs.English:
        return "assets/markdown/privacy_eng.md";
      case LocaleLangs.Japanese:
        return "assets/markdown/privacy_jpn.md";
      case LocaleLangs.Chinese:
        return "assets/markdown/privacy_china.md";
    }
  }
}

LocaleLangs getLocale(String? value) {
  final LocaleLangs l = LocaleLangs.values.firstWhere(
    (c) => c.name == value,
    orElse: () => LocaleLangs.English,
  );
  // if you know Locale use l.locale
  return l;
}

class LocaleLang extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        "en_US": {
          "English": "English",
          "Japanese": "Japanese",
          "Chinese": "Chinese",
          "Email": "Email",
          "Password": "Password",
          "Forgot Password": "Forgot Password",
          "Login": "Login",
          "Sign UP": "Sign UP",
          "I have read and accept": "I have read and accept",
          "I agree": "I agree ",
          "the Terms of Use": "The Terms of Use.",
          "Accept": "Accept",
          "Name": "Name",
          "Select Your Country": "Select Your Country",
          "Already have Acount": "Already have Acount",
          "Notification": "Notification",
          "Select Language": "Select Language",
          "Choose Your Language": "Choose Your Language",
          "Version": "Version",
          "Block List": "Block List",
          "Block deletion": "Block deletion",
          "Contact": "Contact",
          "Clear Cache": "Clear Cache",
          "Logout": "Logout",
          "Settings": "Settings",
          "No Internet connection": "No Internet connection",
          "Anonymous": "Anonymous",
          "Group": "Group",
          "Create Group?": "Create Group?",
          "Delete Group": "Delete Group",
          "Message": "Message",
          "Please select the language of your translation":
              "Please select the language of your translation",
          "Copy": "Copy",
          "Copy(Translated)": "Copy(Translated)",
          "Edit": "Edit",
          "Delete": "Delete",
          "OK": "OK",
          "Cancel": "Cancel",
          "Open Url": "Open Url",
          "Uh oh! Something went wrong...": "Uh oh! Something went wrong...",
          "Scan QR": "Scan QR",
          "Generate": "Generate",
          "Viewer": "Viewer",
          "Recents": "Recents",
          "No Message": "No Message",
          "Report": "Report",
          "Send": "Send",
          "Users": "Users",
          "Edit User": "Edit User",
          "Change Email": "Change Email",
          "Error": "Error",
          "Language": "Language",
          "Please Check Your Email": "Please Check Your Email",
          "Check Email": "Check Email",
          "Send Password": "Send Password",
          "Verify Number": "Verify Number",
          "Loading...": "Loading...",
        },
        "ja_JP": {
          "English": "??????",
          "Japanese": "?????????",
          "Chinese": "?????????",
          "Email": "E?????????",
          "Password": "???????????????",
          "Forgot Password": "?????????????????????????????????",
          "Login": "????????????",
          "Sign UP": "??????????????????",
          "I have read and accept": "???????????????????????????",
          "I agree": "????????????????????? ",
          "the Terms of Use": "????????????",
          "Accept": "??????????????????",
          "Name": "?????????",
          "Select Your Country": "??????????????????????????????",
          "Already have Acount": "????????????????????????????????????",
          "Notification": "??????",
          "Select Language": "???????????????",
          "Choose Your Language": "?????????????????????????????????",
          "Version": "???????????????",
          "Block List": "?????????????????????",
          "Block deletion": "??????????????????",
          "Contact": "??????????????????",
          "Clear Cache": "????????????????????????",
          "Logout": "???????????????",
          "Settings": "??????",
          "No Internet connection": "???????????????????????????????????????????????????",
          "Anonymous": "??????",
          "Group": "????????????",
          "Create Group?": "?????????????????????????????????",
          "Delete Group": "??????????????????",
          "Message": "????????????",
          "Please select the language of your translation": "??????????????????????????????????????????",
          "Copy": "?????????",
          "Copy(Translated)": "?????????(??????)",
          "Edit": "??????",
          "Delete": "??????",
          "OK": "OK",
          "Cancel": "???????????????",
          "Open Url": "URL?????????",
          "Uh oh! Something went wrong...": "?????????????????????????????????",
          "Scan QR": "QR?????????????????????",
          "Generate": "??????",
          "Viewer": "????????????",
          "Recents": "???????????????",
          "No Message": "?????????????????????????????????",
          "Report": "??????",
          "Send": "??????",
          "Users": "????????????",
          "Edit User": "?????????????????????",
          "Change Email": "E???????????????",
          "Error": "?????????",
          "Language": "??????",
          "Please Check Your Email": "E????????????????????????????????????",
          "Check Email": "E??????????????????",
          "Send Password": "????????????????????????",
          "Verify Number": "??????",
          // "Loading...": "??????????????????...",
        },
        "zh_CN": {
          "English": "??????",
          "Japanese": "??????",
          "Chinese": "??????",
          "Email": "????????????",
          "Password": "??????",
          "Forgot Password": "???????????????",
          "Login": "??????",
          "Sign UP": "????????????",
          "I have read and accept": "????????????????????????",
          "I agree": "????????? ",
          "the Terms of Use": "???????????????",
          "Accept": "??????",
          "Name": "??????",
          "Select Your Country": "?????????????????????",
          "Already have Acount": "??????",
          "Notification": "??????",
          "Select Language": "????????????",
          "Choose Your Language": "?????????????????????",
          "Version": "??????",
          "Block List": "?????????",
          "Block deletion": "?????????",
          "Contact": "??????",
          "Clear Cache": "????????????",
          "Logout": "??????",
          "Settings": "??????",
          "No Internet connection": "?????????????????????",
          "Anonymous": "?????????",
          "Group": "??????",
          "Create Group?": "??????????????????????????????",
          "Delete Group": "????????????",
          "Message": "??????",
          "Please select the language of your translation": "???????????????????????????",
          "Copy": "??????",
          "Copy(Translated)": "??????????????????",
          "Edit": "??????",
          "Delete": "??????",
          "OK": "??????",
          "Cancel": "??????",
          "Open Url": "????????????",
          "Uh oh! Something went wrong...": "??????",
          "Scan QR": "??????QR",
          "Generate": "??????",
          "Viewer": "??????",
          "Recents": "??????",
          "No Message": "????????????",
          "Report": "??????",
          "Send": "??????",
          "Users": "??????",
          "Edit User": "????????????",
          "Change Email": "??????????????????",
          "Error": "??????",
          "Language": "??????",
          "Please Check Your Email": "????????????????????????",
          "Check Email": "??????????????????",
          "Send Password": "????????????",
          "Verify Number": "??????",
          "Loading...": "????????????...",
        },
      };
}

// Spanish
   // "es_ES": {
   //   "Email": "",
   // }