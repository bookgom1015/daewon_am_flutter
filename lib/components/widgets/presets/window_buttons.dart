
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:daewon_am/components/helpers/color_manager.dart';
import 'package:daewon_am/components/models/theme_setting_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class WindowButtons extends StatefulWidget {
  const WindowButtons({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WindowButtonsState();
}

class _WindowButtonsState extends State<WindowButtons> {  
  late ThemeSettingModel _themeModel;
  late WindowButtonColors _titleBarButtonColors;
  late WindowButtonColors _titleBarCloseButtonColors;

  bool _firstCall = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_firstCall) {
      _firstCall = false;
      _themeModel = context.watch<ThemeSettingModel>();
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
    return Align(
      alignment: Alignment.topRight,
      child: Row(
        children: [
          MinimizeWindowButton(
            colors: _titleBarButtonColors
          ),
          MaximizeWindowButton(
            colors: _titleBarButtonColors,
            onPressed: () {
              setState(() {
                appWindow.maximizeOrRestore();
              });
            },
          ),
          CloseWindowButton(
            colors: _titleBarCloseButtonColors,
          )
        ],
      ),
    );
  }

  void onThemeModelChanged() {
    var themeType = _themeModel.getThemeType();
    var backgroundColor = ColorManager.getBackgroundColor(themeType);
    var titleBarButtonIconColor = ColorManager.getTitleBarButtonIconColor(themeType);
    var titleBarButtonIconMouseOverColor = ColorManager.getTitleBarButtonIconMouseOverColor(themeType);
    var titleBarButtonIconMouseDownColor = ColorManager.getTitleBarButtonMouseDownBackgroundColor(themeType);
    _titleBarButtonColors =  WindowButtonColors(
      normal: backgroundColor,
      mouseOver: ColorManager.getTitleBarButtonMouseOverBackgroundColor(themeType),
      mouseDown: ColorManager.getTitleBarButtonMouseDownBackgroundColor(themeType),
      iconNormal: titleBarButtonIconColor,
      iconMouseOver: titleBarButtonIconMouseOverColor,
      iconMouseDown: titleBarButtonIconMouseDownColor
    );
    _titleBarCloseButtonColors =  WindowButtonColors(
      normal: backgroundColor,
      mouseOver: ColorManager.getTitleBarCloseButtonMouseOverBackgroundColor(themeType),
      mouseDown: ColorManager.getTitleBarCloseButtonMouseDownBackgroundColor(themeType),
      iconNormal: titleBarButtonIconColor,
      iconMouseOver: titleBarButtonIconMouseOverColor,
      iconMouseDown: titleBarButtonIconMouseDownColor
    );
  }
}