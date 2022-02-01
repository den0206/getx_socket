import 'package:flag/flag.dart';

enum Country {
  bulgarian,
  czech,
  danish,
  german,
  greek,
  spanish,
  estonian,
  english,
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
  romanian,
  russian,
  slovak,
  slovenian,
  swedish,
  chinese,
}

extension CountryEXT on Country {
  String get code {
    switch (this) {
      case Country.bulgarian:
        return "BG";
      case Country.czech:
        return "CS";
      case Country.danish:
        return "DA";
      case Country.german:
        return "DE";
      case Country.greek:
        return "EL";
      case Country.spanish:
        return "ES";
      case Country.estonian:
        return "ET";
      case Country.english:
        return "EN";
      case Country.french:
        return "FR";
      case Country.finnish:
        return "FI";
      case Country.hungarian:
        return "HU";
      case Country.japanese:
        return "JA";
      case Country.lithuanian:
        return "LT";
      case Country.italian:
        return "IT";
      case Country.latvian:
        return "LV";
      case Country.dutch:
        return "NL";
      case Country.polish:
        return "PL";
      case Country.portuguese:
        return "PT";
      case Country.romanian:
        return "RO";
      case Country.russian:
        return "RU";
      case Country.slovak:
        return "SK";
      case Country.slovenian:
        return "SL";
      case Country.swedish:
        return "SV";
      case Country.chinese:
        return "ZH";
    }
  }

  FlagsCode get flagsCode {
    switch (this) {
      case Country.bulgarian:
        return FlagsCode.BG;
      case Country.czech:
        return FlagsCode.CZ;
      case Country.danish:
        return FlagsCode.DK;
      case Country.german:
        return FlagsCode.DE;
      case Country.greek:
        return FlagsCode.GR;
      case Country.spanish:
        return FlagsCode.ES;
      case Country.estonian:
        return FlagsCode.EE;
      case Country.english:
        return FlagsCode.US;
      case Country.french:
        return FlagsCode.FR;
      case Country.finnish:
        return FlagsCode.FI;
      case Country.hungarian:
        return FlagsCode.HU;
      case Country.japanese:
        return FlagsCode.JP;
      case Country.lithuanian:
        return FlagsCode.LT;
      case Country.italian:
        return FlagsCode.IT;
      case Country.latvian:
        return FlagsCode.LT;
      case Country.dutch:
        return FlagsCode.NL;
      case Country.polish:
        return FlagsCode.PL;
      case Country.portuguese:
        return FlagsCode.PT;
      case Country.romanian:
        return FlagsCode.RO;
      case Country.russian:
        return FlagsCode.RU;
      case Country.slovak:
        return FlagsCode.SK;
      case Country.slovenian:
        return FlagsCode.SI;
      case Country.swedish:
        return FlagsCode.SE;
      case Country.chinese:
        return FlagsCode.CN;
    }
  }
}
