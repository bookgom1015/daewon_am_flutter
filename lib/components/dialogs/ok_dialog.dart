import 'package:daewon_am/components/helpers/theme/color_manager.dart';
import 'package:daewon_am/components/globals/global_theme_settings.dart';
import 'package:daewon_am/components/models/theme_setting_model.dart';
import 'package:daewon_am/components/widgets/buttons/mouse_reaction_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OkDialog extends StatefulWidget {
  final String title;
  final String message;

  const OkDialog({
    Key? key,
    required this.title,
    required this.message}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OkDialogState();
}

class _OkDialogState extends State<OkDialog> {
  late ThemeSettingModel _themeModel;

  late Color _backgroundColor;
  late Color _backgroundMouseOverColor;
  late Color _foregroundColor;
  late Color _iconNormalColor;
  late Color _iconMouseOverColor;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _themeModel = context.watch<ThemeSettingModel>();

    loadColors();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(        
        margin: const EdgeInsets.all(50),
        constraints: const BoxConstraints(
          maxWidth: 600,
          maxHeight: 800
        ),
        decoration: BoxDecoration(
          color: _backgroundColor,
          borderRadius: BorderRadius.circular(8)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        widget.title,
                        style: TextStyle(
                          color: _foregroundColor,
                          fontSize: 24
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: MouseReactionIconButton(
                      onTap: onTap,
                      width: 40,                  
                      height: 30,
                      borderRadius: const BorderRadius.only(topRight: Radius.circular(8)),
                      duration: colorChangeDuration,
                      curve: colorChangeCurve,
                      normal: _backgroundColor,
                      mouseOver: _backgroundMouseOverColor,
                      iconNormal: _iconNormalColor,
                      iconMouseOver: _iconMouseOverColor,
                      icon: Icons.close,
                      iconSize: 20,
                    ),
                  )
                ],
              ),
            ),
            SingleChildScrollView(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 20, 30, 30),
                  child: Text(
                    widget.message,
                    style: TextStyle(
                      color: _foregroundColor
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      )
    );
  }

  void loadColors() {
    var themeType = _themeModel.getThemeType();

    _backgroundColor = ColorManager.getBackgroundColor(themeType);
    _backgroundMouseOverColor = ColorManager.getTitleBarCloseButtonMouseOverBackgroundColor(themeType);
    _foregroundColor = ColorManager.getForegroundColor(themeType);
    _iconNormalColor = ColorManager.getTitleBarButtonIconColor(themeType);
    _iconMouseOverColor = ColorManager.getTitleBarButtonIconMouseOverColor(themeType);
  }

  void onTap() {
    Navigator.of(context).pop();
  }
}

void showOkDialog({required BuildContext context, required ThemeSettingModel themeModel, String title = "", String message = ""}) {
  showDialog(
    context: context, 
    barrierDismissible: false,
    builder: (_) => ChangeNotifierProvider.value(
      value: themeModel,
      child: OkDialog(
        title: title,
        message: message
      ),
    )
  );
}