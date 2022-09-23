import 'package:daewon_am/components/enums/theme_types.dart';
import 'package:flutter/material.dart';

class ThemeSettingModel with ChangeNotifier {
  EThemeTypes _themeType = EThemeTypes.eDark;

  void changeTheme(EThemeTypes type) {    
    if (type == _themeType) return;
    _themeType = type;
    notifyListeners();
  }

  EThemeTypes getThemeType() {
    return _themeType;
  }
}