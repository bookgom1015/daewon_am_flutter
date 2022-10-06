import 'package:daewon_am/components/globals/global_theme_settings.dart';
import 'package:daewon_am/components/helpers/color_manager.dart';
import 'package:daewon_am/components/helpers/widget_helper.dart';
import 'package:daewon_am/components/models/theme_setting_model.dart';
import 'package:daewon_am/components/widgets/buttons/mouse_reaction_button.dart';
import 'package:daewon_am/components/widgets/date_pickers/simple_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountingDataConfirmDialog extends StatefulWidget {
  final void Function(DateTime date) onDateChagned;

  const AccountingDataConfirmDialog({
    Key? key,
    required this.onDateChagned}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AccountingDataConfirmDialogState();
}

class _AccountingDataConfirmDialogState extends State<AccountingDataConfirmDialog> {
  late ThemeSettingModel _themeModel;

  late Color _layerBackgroundColor;
  late Color _normal;
  late Color _mouseOver;
  late Color _foregroundColor;

  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();

    _selectedDate = DateTime.now();
  }

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
        width: 350,
        height: 200,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _layerBackgroundColor,
          borderRadius: BorderRadius.circular(8)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
              child: Text(
                "입금확인",
                style: TextStyle(
                  color: _foregroundColor,
                  fontSize: 24
                ),
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  SizedBox(
                    width: 60,
                    child: Text(
                      "날짜",
                      style: TextStyle(
                        color: _foregroundColor
                      ),
                    ),
                  ),
                  Expanded(
                    child: SimpleDatePicker(
                      initialDate: _selectedDate,
                      onChangedDate: (date) {
                        if (date == null) return;
                        setState(() {
                          _selectedDate = date;
                        });                        
                      },
                    )
                  )
                ],
              )
            ),
            SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  WidgetHelper.dialogButton(
                    onPressed: () {
                      widget.onDateChagned(_selectedDate);
                      Navigator.of(context).pop();
                    },
                    label: "확인",
                    normal: _normal,
                    mouseOver: _mouseOver,                    
                    fontColor: _foregroundColor,
                  ),                  
                  const  SizedBox(width: 5),
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
      ),
    );
  }

  void loadColors() {
    final themeType = _themeModel.getThemeType();

    _layerBackgroundColor = ColorManager.getLayerBackgroundColor(themeType);
    _normal = ColorManager.getWidgetBackgroundColor(themeType);
    _mouseOver = ColorManager.getWidgetBackgroundMouseOverColor(themeType);
    _foregroundColor = ColorManager.getForegroundColor(themeType);
  }
}