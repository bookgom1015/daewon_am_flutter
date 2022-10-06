
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _themeModel = context.watch<ThemeSettingModel>();
  }

  @override
  Widget build(BuildContext context) {
    var themeType = _themeModel.getThemeType();
    var backgroundColor = ColorManager.getBackgroundColor(themeType);
    var titleBarButtonIconColor = ColorManager.getTitleBarButtonIconColor(themeType);
    var titleBarButtonIconMouseOverColor = ColorManager.getTitleBarButtonIconMouseOverColor(themeType);
    var titleBarButtonIconMouseDownColor = ColorManager.getTitleBarButtonMouseDownBackgroundColor(themeType);

    WindowButtonColors titleBarButtonColors =  WindowButtonColors(
      normal: backgroundColor,
      mouseOver: ColorManager.getTitleBarButtonMouseOverBackgroundColor(themeType),
      mouseDown: ColorManager.getTitleBarButtonMouseDownBackgroundColor(themeType),
      iconNormal: titleBarButtonIconColor,
      iconMouseOver: titleBarButtonIconMouseOverColor,
      iconMouseDown: titleBarButtonIconMouseDownColor
    );

    WindowButtonColors titleBarCloseButtonColors =  WindowButtonColors(
      normal: backgroundColor,
      mouseOver: ColorManager.getTitleBarCloseButtonMouseOverBackgroundColor(themeType),
      mouseDown: ColorManager.getTitleBarCloseButtonMouseDownBackgroundColor(themeType),
      iconNormal: titleBarButtonIconColor,
      iconMouseOver: titleBarButtonIconMouseOverColor,
      iconMouseDown: titleBarButtonIconMouseDownColor
    );

    return Align(
      alignment: Alignment.topRight,
      child: Row(
        children: [
          MinimizeWindowButton(
            colors: titleBarButtonColors
          ),
          MaximizeWindowButton(
            colors: titleBarButtonColors,
            onPressed: resize,
          ),
          CloseWindowButton(
            colors: titleBarCloseButtonColors,
          )
        ],
      ),
    );
  }

  void resize() {
    setState(() {
      appWindow.maximizeOrRestore();
    });
  }
}