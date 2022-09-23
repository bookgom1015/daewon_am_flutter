import 'package:daewon_am/components/color_manager.dart';
import 'package:daewon_am/components/globals/global_routes.dart';
import 'package:daewon_am/components/globals/global_theme_settings.dart';
import 'package:daewon_am/components/models/page_control_model.dart';
import 'package:daewon_am/components/models/theme_setting_model.dart';
import 'package:daewon_am/components/models/user_info_model.dart';
import 'package:daewon_am/components/widgets/buttons/mouse_reaction_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  late ThemeSettingModel _themeModel;
  late UserInfoModel _userInfoModel;
  late PageControlModel _pageControlModel;

  late Color _normal;
  late Color _mouseOver;

  late Color _foregroundColor;
  late Color _widgetColor;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _themeModel = context.watch<ThemeSettingModel>();
    _userInfoModel = context.watch<UserInfoModel>();
    _pageControlModel = context.watch<PageControlModel>();

    loadColors();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 128,
                height: 128,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _widgetColor
                ),
                child: Icon(
                  Icons.person,
                  size: 100,
                  color: _foregroundColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  _userInfoModel.getUserId(),
                  style: TextStyle(
                    color: _foregroundColor,
                    fontSize: 18
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 40),
          MouseReactionButton(
            onTap: () {
              _userInfoModel.logout();
              Navigator.of(context).pop();

              var state = _pageControlModel.getNavigatorState();
              if (state != null) {
                Navigator.pushNamedAndRemoveUntil(state.context, loginPageRoute, (route) => false);
              }
            },
            width: 100,
            height: 40,
            borderRadius: BorderRadius.circular(8),
            duration: colorChangeDuration,
            curve: colorChangeCurve,
            normal: _normal,
            mouseOver: _mouseOver,
            child: Center(
              child: Text(
                "로그아웃",
                style: TextStyle(
                  color: _foregroundColor,
                  fontSize: 16
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void loadColors() {
    var themeType = _themeModel.getThemeType();

    _normal = ColorManager.getLogoutButtonBackgroundColor(themeType);
    _mouseOver = ColorManager.getLogoutButtonBackgroundMouseOverColor(themeType);
    _foregroundColor = ColorManager.getForegroundColor(themeType);
    _widgetColor = ColorManager.getWidgetBackgroundColor(themeType);
  }
}