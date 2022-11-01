import 'package:daewon_am/components/helpers/color_manager.dart';
import 'package:daewon_am/components/dialogs/preference_dialog.dart';
import 'package:daewon_am/components/globals/global_theme_settings.dart';
import 'package:daewon_am/components/models/page_control_model.dart';
import 'package:daewon_am/components/models/theme_setting_model.dart';
import 'package:daewon_am/components/models/user_info_model.dart';
import 'package:daewon_am/components/widgets/buttons/mouse_reaction_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PreferenceButton extends StatefulWidget {
  const PreferenceButton({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PreferenceButtonState();
}

class _PreferenceButtonState extends State<PreferenceButton> {
  late ThemeSettingModel _themeModel;
  late UserInfoModel _userInfoModel;
  late PageControlModel _pageControlModel;

  late Color _normal;
  late Color _mouseOver;
  late Color _iconNormal;
  late Color _iconMouseOver;

  bool _firstCall = true;

  @override
  void initState() {
    super.initState();
  }

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
    return MouseReactionIconButton(
      onTap: () {
        showDialog(
          context: context, 
          barrierDismissible: false,
          builder: (_) => ChangeNotifierProvider.value(
            value: _themeModel,
            child: ChangeNotifierProvider.value(
              value: _userInfoModel,
              child: ChangeNotifierProvider.value(
                value: _pageControlModel,
                child: const PreferenceDialog(),
              )
            ),
          )
        );
      },
      width: 40,
      height: 30,
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(8)),
      duration: colorChangeDuration,
      curve: colorChangeCurve,
      normal: _normal,
      mouseOver: _mouseOver,
      icon: Icons.settings,
      iconSize: 20,
      iconNormal: _iconNormal,
      iconMouseOver: _iconMouseOver,
      tooltip: "설정",
    );
  }

  void onThemeModelChanged() {
    var themeType = _themeModel.getThemeType();
    _normal = ColorManager.getBackgroundColor(themeType);
    _mouseOver = ColorManager.getTitleBarButtonMouseOverBackgroundColor(themeType);
    _iconNormal = ColorManager.getTitleBarButtonIconColor(themeType);
    _iconMouseOver = ColorManager.getTitleBarButtonIconMouseOverColor(themeType);
  }
}