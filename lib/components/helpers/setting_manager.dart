
import 'dart:convert';

import 'package:daewon_am/components/enums/theme_types.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SettingManager {
  static const String userIdKey = "user_id";
  static const String userPwdKey = "user_pwd";
  static const String _themeSettingJsonKey = "theme_setting_json";
  static const String _userInfoJsonKey = "user_info_json";

  static Future<EThemeTypes> getThemeSetting() async {
    const storage = FlutterSecureStorage();
    final value = await storage.read(key: _themeSettingJsonKey);
    if (value == null) {
      return EThemeTypes.eDark;
    }
    else {
      return textToTheme(value);
    }
  }

  static Future<void> setThemeSetting(EThemeTypes themeType) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: _themeSettingJsonKey, value: themeType.text);
  }

  static Future<dynamic> getUserInfoJson() async {
    const storage = FlutterSecureStorage();
    final value = await storage.read(key: _userInfoJsonKey);
    if (value == null) {
      return jsonDecode("{}");
    }
    else {
      return jsonDecode(value);
    }
  }

  static Future<void> setUserInfoJson(dynamic json) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: _userInfoJsonKey, value: jsonEncode(json));
  }
}