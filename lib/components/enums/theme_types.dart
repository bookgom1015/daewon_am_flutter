
enum EThemeTypes {
  eDark,
  eLight,
  ePinkBlue,
}

extension EThemeTypesExt on EThemeTypes {
  String get text {
    switch (this) {
      case EThemeTypes.eDark:
      return "Dark";
      case EThemeTypes.eLight:
      return "Light";
      case EThemeTypes.ePinkBlue:
      return "PinkBlue";
      default:
      return "Dark";
    }
  }
}

EThemeTypes textToTheme(String text) {
  switch (text) {
    case "Dark":
    return EThemeTypes.eDark;
    case "Light":
    return EThemeTypes.eLight;
    case "PinkBlue":
    return EThemeTypes.ePinkBlue;
    default:
    return EThemeTypes.eDark;
  }
}