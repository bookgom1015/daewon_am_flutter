import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:daewon_am/components/dialogs/ok_dialog.dart';
import 'package:daewon_am/components/entries/page_list.dart';
import 'package:daewon_am/components/enums/privileges.dart';
import 'package:daewon_am/components/enums/theme_types.dart';
import 'package:daewon_am/components/globals/global_routes.dart';
import 'package:daewon_am/components/globals/global_theme_settings.dart';
import 'package:daewon_am/components/helpers/http_manager.dart';
import 'package:daewon_am/components/helpers/setting_manager.dart';
import 'package:daewon_am/components/models/page_control_model.dart';
import 'package:daewon_am/components/models/user_info_model.dart';
import 'package:daewon_am/components/pages/accounting_page.dart';
import 'package:daewon_am/components/pages/admin_page.dart';
import 'package:daewon_am/components/pages/chart_page.dart';
import 'package:daewon_am/components/pages/login_page.dart';
import 'package:daewon_am/components/pages/receivable_page.dart';
import 'package:daewon_am/components/pages/workspace_page.dart';
import 'package:daewon_am/components/widgets/presets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:daewon_am/components/helpers/color_manager.dart';
import 'package:daewon_am/components/models/theme_setting_model.dart';
import 'package:daewon_am/components/widgets/buttons/page_nav_buttons.dart';
import 'package:daewon_am/components/widgets/buttons/preference_button.dart';
import 'package:daewon_am/components/widgets/presets/window_buttons.dart';
import 'package:yaml/yaml.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late ThemeSettingModel _themeModel;
  late UserInfoModel _userInfoModel;
  late PageControlModel _pageControlModel;

  late Color _backgroundColor;

  final _navigatorState = GlobalKey<NavigatorState>();

  bool _checked = false;
  bool _firstCall = true;

  final _pageList = PageList();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_firstCall) {
      _firstCall = false;
      _themeModel = context.watch<ThemeSettingModel>();
      _userInfoModel = context.watch<UserInfoModel>();
      _pageControlModel = context.watch<PageControlModel>();
      _themeModel.addListener(onThemeModelChanged);
      _userInfoModel.addListener(onUserInfoModelChanged);
      onThemeModelChanged();
      onUserInfoModelChanged();
      loadThemeSetting();
      checkLastVersion();
    }
    _pageControlModel.setNaviatorStae(_navigatorState.currentState);
  }

  @override
  void dispose() {
    _themeModel.removeListener(onThemeModelChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AnimatedContainer(          
          duration: colorChangeDuration,
          curve: colorChangeCurve,
          decoration: BoxDecoration(
            color: _backgroundColor
          ),
          height: 40,
          child: WindowTitleBarBox(
            child: Row(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: SizedBox(
                          height: 30,
                          child: MoveWindow(),
                        ),
                      ),
                      _userInfoModel.getLoggedIn() ? PageNavButtons(pageList: _pageList) : const SizedBox(),
                      const PreferenceButton()
                    ],
                  )
                ),
                const WindowButtons()
              ],
            ),
          ),
        ),
        Expanded(
          child: AnimatedContainer(
            duration: colorChangeDuration,
            curve: colorChangeCurve,
            decoration: BoxDecoration(
              color: _backgroundColor
            ),
            child: _checked ? Navigator(
              key: _navigatorState,
              initialRoute: loginPageRoute,
              onGenerateRoute: onGenerateRoute,
            ) : const LoadingIndicator()
          )
        )
      ]
    );
  }

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    late Widget page;
    if (settings.name == loginPageRoute) {
      page = const LoginPage();
    }
    else if (settings.name == workspacePageRoute) {
      page = WorkspacePage(pageList: _pageList);
    }
    else {
      throw Exception("Unknown route: ${settings.name}");
    }
    return MaterialPageRoute(
      builder: (context) {
        return page;
      },
      settings: settings
    );
  }

  void onThemeModelChanged() {
    final themeType = _themeModel.getThemeType();
    _backgroundColor = ColorManager.getBackgroundColor(themeType);
  }

  void onUserInfoModelChanged() {
    _pageList.clear();
    _pageList.addPage(const AccountingPage(), PageNavButton(Icons.description_rounded, 18, "회계", 0));
    _pageList.addPage(const ReceivablePage(), PageNavButton(Icons.manage_search, 20, "미수금", 1));
    _pageList.addPage(const ChartPage(), PageNavButton(Icons.bar_chart, 24, "차트", 2));
    if (_userInfoModel.getPrivileges() == EPrivileges.eAdmin) {
      _pageList.addPage(const AdminPage(), PageNavButton(Icons.admin_panel_settings, 20, "관리자", 3));
    }
  }

  void loadThemeSetting() {
    final themeTypeFuture = SettingManager.getThemeSetting();
    themeTypeFuture.then((themeType) {
      _themeModel.changeTheme(themeType);
    });
  }

  void checkLastVersion() {
    final lastVerFuture = HttpManager.getLastVersion();
    lastVerFuture.then((lastVer) {
      final yamlFuture = rootBundle.loadString("pubspec.yaml");
      yamlFuture.then((yamlStr) {
        final yaml = loadYaml(yamlStr);
        final currVer = yaml["version"].toString();
        if (lastVer != currVer) {
          final exeFileName = Platform.resolvedExecutable;
          final end = exeFileName.lastIndexOf("\\");
          final currPath =exeFileName.substring(0, end);
          final filePath = "$currPath\\update\\daewon_am_updater.exe";
          showOkDialog(
            context: context, 
            themeModel: _themeModel,
            title: "알림",
            message: "업데이트된 버전이 확인되었습니다",
            onPressed: () {
              var startFuture = Process.start(filePath, []);
              startFuture.then((proc) {
                exit(0);
              });
            }
          );
          return;
        }
        if (!mounted) return;
        setState(() {
          _checked = true;
        });
      });      
    })
    .catchError((_) {
      if (!mounted) return;
      showOkDialog(
        context: context, 
        themeModel: _themeModel,
        title: "오류",
        message: "버전 정보를 불러오지 못 했습니다",
        onPressed: () {
          if (!mounted) return;
          setState(() {
            _checked = true;
          });
        }
      );
    });
  }
}