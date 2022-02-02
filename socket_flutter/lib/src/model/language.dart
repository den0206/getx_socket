enum Language {
  bulgarian,
  czech,
  danish,
  german,
  greek,
  spanish,
  estonian,
  english,
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
  portuguese,
  portuguese_pt,
  portuguese_brazilian,
  romanian,
  russian,
  slovak,
  slovenian,
  swedish,
  chinese,
}

extension LanguageEXT on Language {
  String get code {
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
      case Language.english:
        return "EN";
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
      case Language.portuguese:
        return "PT";
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
