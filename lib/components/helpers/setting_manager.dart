
import 'dart:convert';
import 'dart:io';

class SettingManager {
  static const String userIdKey = "user_id";
  static const String userPwdKey = "user_pwd";

  static Future<File> getSettingFile() async {
    final exeFileName = Platform.resolvedExecutable;
    final end = exeFileName.lastIndexOf("\\");
    final currPath =exeFileName.substring(0, end);
    final dir = Directory("$currPath\\data");
    final file = File("$currPath\\data\\settings.dat");
    if (!await file.exists()) {
      if (!await dir.exists()) await dir.create();
      await file.create();
      final json = jsonEncode({});
      file.writeAsString(json.toString());
    }
    return file;
  }
}