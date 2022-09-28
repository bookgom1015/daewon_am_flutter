import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:daewon_am/components/globals/global_routes.dart';
import 'package:daewon_am/components/globals/global_theme_settings.dart';
import 'package:daewon_am/components/models/page_control_model.dart';
import 'package:daewon_am/components/models/user_info_model.dart';
import 'package:daewon_am/components/pages/login_page.dart';
import 'package:daewon_am/components/pages/workspace_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:daewon_am/components/helpers/theme/color_manager.dart';
import 'package:daewon_am/components/models/theme_setting_model.dart';
import 'package:daewon_am/components/widgets/presets/page_nav_buttons.dart';
import 'package:daewon_am/components/widgets/buttons/preference_button.dart';
import 'package:daewon_am/components/widgets/presets/window_buttons.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late ThemeSettingModel _themeModel;
  late UserInfoModel _userInfoModel;
  late PageControlModel _pageControlModel;

  final _navigatorState = GlobalKey<NavigatorState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _themeModel = context.watch<ThemeSettingModel>();
    _userInfoModel = context.watch<UserInfoModel>();
    _pageControlModel = context.watch<PageControlModel>();

    _pageControlModel.setNaviatorStae(_navigatorState.currentState);
  }

  @override
  Widget build(BuildContext context) {
    var themeType = _themeModel.getThemeType();
    var backgroundColor = ColorManager.getBackgroundColor(themeType);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AnimatedContainer(
          duration: colorChangeDuration,
          curve: colorChangeCurve,
          decoration: BoxDecoration(
            color: backgroundColor
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
                      _userInfoModel.getLoggedIn() ? const PageNavButtons() : const SizedBox(),
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
              color: backgroundColor
            ),
            child: Navigator(
              key: _navigatorState,
              initialRoute: loginPageRoute,
              onGenerateRoute: onGenerateRoute,
            )
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
      page = const WorkspacePage();
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
}