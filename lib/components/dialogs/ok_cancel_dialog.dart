import 'package:daewon_am/components/helpers/color_manager.dart';
import 'package:daewon_am/components/helpers/widget_helper.dart';
import 'package:daewon_am/components/models/theme_setting_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OkCancelDialog extends StatefulWidget {
  final String title;
  final String message;
  final void Function() onPressed;

  const OkCancelDialog({
    Key? key,
    required this.title,
    required this.message,
    required this.onPressed}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OkCancelDialogState();
}

class _OkCancelDialogState extends State<OkCancelDialog> {
  late ThemeSettingModel _themeModel;

  late Color _normal;
  late Color _mouseOver;
  late Color _backgroundColor;
  late Color _foregroundColor;

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
        padding: const EdgeInsets.all(20),
        constraints: const BoxConstraints(
          maxWidth: 450,
          maxHeight: 800
        ),
        decoration: BoxDecoration(
          color: _backgroundColor,
          borderRadius: BorderRadius.circular(8)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
              child: Text(
                widget.title,
                style: TextStyle(
                  color: _foregroundColor,
                  fontSize: 24
                )
              ),
            ),
            SingleChildScrollView(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  child: Text(
                    widget.message,
                    style: TextStyle(
                      color: _foregroundColor
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  WidgetHelper.dialogButton(
                    onPressed: () {
                      widget.onPressed();
                      Navigator.of(context).pop();
                    },
                    label: "확인",
                    normal: _normal,
                    mouseOver: _mouseOver,                    
                    fontColor: _foregroundColor,
                  ),
                  const SizedBox(width: 5),
                  WidgetHelper.dialogButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    label: "취소",
                    normal: _normal,
                    mouseOver: _mouseOver,                    
                    fontColor: _foregroundColor,
                  ),
                ],
              ),
            )
          ],
        ),
      )
    );
  }

  void loadColors() {
    final themeType = _themeModel.getThemeType();

    _normal = ColorManager.getWidgetBackgroundColor(themeType);
    _mouseOver = ColorManager.getWidgetBackgroundMouseOverColor(themeType);
    _backgroundColor = ColorManager.getBackgroundColor(themeType);
    _foregroundColor = ColorManager.getForegroundColor(themeType);
  }
}

void showOkCancelDialog({
  required BuildContext context, 
  required ThemeSettingModel themeModel, 
  required void Function() onPressed,
  String title = "", 
  String message = ""}
) {
  showDialog(
    context: context, 
    barrierDismissible: false,
    builder: (_) => ChangeNotifierProvider.value(
      value: themeModel,
      child: OkCancelDialog(
        title: title,
        message: message,
        onPressed: onPressed,
      ),
    )
  );
}