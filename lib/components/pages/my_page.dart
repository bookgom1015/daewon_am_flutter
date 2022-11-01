import 'dart:convert';

import 'package:daewon_am/components/dialogs/ok_dialog.dart';
import 'package:daewon_am/components/enums/privileges.dart';
import 'package:daewon_am/components/helpers/color_manager.dart';
import 'package:daewon_am/components/globals/global_routes.dart';
import 'package:daewon_am/components/globals/global_theme_settings.dart';
import 'package:daewon_am/components/helpers/setting_manager.dart';
import 'package:daewon_am/components/models/page_control_model.dart';
import 'package:daewon_am/components/models/theme_setting_model.dart';
import 'package:daewon_am/components/models/user_info_model.dart';
import 'package:daewon_am/components/widgets/buttons/mouse_reaction_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyPage extends StatefulWidget {
  final BuildContext parentContext;

  const MyPage({
    Key? key,
    required this.parentContext}) : super(key: key);

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

  bool _firstCall = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_firstCall) {
      _firstCall = false;
      _themeModel = context.watch<ThemeSettingModel>();
      _userInfoModel = context.watch<UserInfoModel>();
      _pageControlModel = context.watch<PageControlModel>();  
      _themeModel.addListener(onThemeModelChanged);
      onThemeModelChanged();
    }
  }

  @override
  void dispose() {
    _themeModel.removeListener(onThemeModelChanged);
    super.dispose();    
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _userInfoModel.getUserId(),
                      style: TextStyle(
                        color: _foregroundColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.only(left: 2),
                      child: Text(
                        _userInfoModel.getPrivileges().desc,
                        style: TextStyle(
                          color: _foregroundColor,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 40),
          MouseReactionButton(
            onTap: logout,
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

  void onThemeModelChanged() {
    final themeType = _themeModel.getThemeType();
    _normal = ColorManager.getLogoutButtonBackgroundColor(themeType);
    _mouseOver = ColorManager.getLogoutButtonBackgroundMouseOverColor(themeType);
    _foregroundColor = ColorManager.getForegroundColor(themeType);
    _widgetColor = ColorManager.getWidgetBackgroundColor(themeType);
  }

  void logout() {
    if (!_userInfoModel.getLoggedIn()) return;
    _userInfoModel.logout();
    final finished = SettingManager.setUserInfoJson(jsonDecode("{}"));
    finished.then((value) {
      final state = _pageControlModel.getNavigatorState();
      if (state == null) {
        if (!mounted) return;
        showOkDialog(
          context: context, 
          themeModel: _themeModel,
          title: "경고",
          message: "잘못된 context가 감지되었습니다"
        );
        return;
      }
      Navigator.of(context).popUntil((route) => route.isFirst);
      _pageControlModel.reset();
      Navigator.pushNamedAndRemoveUntil(state.context, loginPageRoute, (route) => false);
    }); 
  }
}