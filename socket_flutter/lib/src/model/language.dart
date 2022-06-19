import 'package:country_list_pick/country_list_pick.dart';

enum Language {
  bulgarian,
  czech,
  danish,
  german,
  greek,
  spanish,
  estonian,
  english_british,
  english_american,
  french,
  finnish,
  hungarian,
  japanese,
  lithuanian,
  italian,
  latvian,
  dutch,
  polish,
  portuguese_pt,
  portuguese_brazilian,
  romanian,
  russian,
  slovak,
  slovenian,
  swedish,
  chinese;

  String get source_lang {
    switch (this) {
      case Language.english_british:
      case Language.english_american:
        return "EN";
      case Language.portuguese_pt:
      case Language.portuguese_brazilian:
        return "PT";
      default:
        return this.target_lang;
    }
  }

  String get target_lang {
    switch (this) {
      case Language.bulgarian:
        return "BG";
      case Language.czech:
        return "CS";
      case Language.danish:
        return "DA";
      case Language.german:
        return "DE";
      case Language.greek:
        return "EL";
      case Language.spanish:
        return "ES";
      case Language.estonian:
        return "ET";
      case Language.english_british:
        return "EN-GB";
      case Language.english_american:
        return "EN-US";
      case Language.french:
        return "FR";
      case Language.finnish:
        return "FI";
      case Language.hungarian:
        return "HU";
      case Language.japanese:
        return "JA";
      case Language.lithuanian:
        return "LT";
      case Language.italian:
        return "IT";
      case Language.latvian:
        return "LV";
      case Language.dutch:
        return "NL";
      case Language.polish:
        return "PL";
      case Language.portuguese_pt:
        return "PT-PT";
      case Language.portuguese_brazilian:
        return "PT-BR";
      case Language.romanian:
        return "RO";
      case Language.russian:
        return "RU";
      case Language.slovak:
        return "SK";
      case Language.slovenian:
        return "SL";
      case Language.swedish:
        return "SV";
      case Language.chinese:
        return "ZH";
    }
  }
}

Language? originLang(CountryCode country) {
  switch (country.code) {
    case "BG":
      return Language.bulgarian;
    case "CZ":
      return Language.czech;
    case "DE":
      return Language.german;
    case "GR":
      return Language.greek;
    case "EL":
      return Language.spanish;
    case "EE":
      return Language.estonian;
    case "GB":
      return Language.english_british;
    case "US":
      return Language.english_american;
    case "FR":
      return Language.french;
    case "FI":
      return Language.finnish;
    case "HU":
      return Language.hungarian;
    case "LT":
      return Language.lithuanian;
    case "JP":
      return Language.japanese;
    case "IT":
      return Language.italian;
    case "LV":
      return Language.latvian;
    case "NL":
      return Language.polish;
    case "PT":
      return Language.portuguese_pt;
    case "RO":
      return Language.romanian;
    case "RU":
      return Language.russian;
    case "SK":
      return Language.slovak;
    case "SI":
      return Language.slovenian;
    case "SE":
      return Language.swedish;
    case "CN":
      return Language.chinese;
    default:
      return null;
  }
}
