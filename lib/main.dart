import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:daewon_am/components/helpers/http_helper.dart';
import 'package:daewon_am/components/models/page_control_model.dart';
import 'package:daewon_am/components/models/user_info_model.dart';
import 'package:daewon_am/components/pages/main_page.dart';
import 'package:daewon_am/components/models/theme_setting_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// "C:\Program Files (x86)\Windows Kits\10\bin\10.0.22000.0\x64\signtool.exe" sign /f "D:\Packages\Key\kbgdaewon.pfx" /fd SHA256 /p 990011 $f

void main() async {
  runApp(const DaewonApp());
  appWindow.minSize = const Size(640, 480);
}

class DaewonApp extends StatelessWidget {
  const DaewonApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.transparent,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("ko", "KR"),
      ],
      home: Scaffold(
        body: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => ThemeSettingModel()),
            ChangeNotifierProvider(create: (context) => UserInfoModel()),
            ChangeNotifierProvider(create: (context) => PageControlModel()),
          ],
          child: const MainPage(),
        )
      ),
    );
  }
}