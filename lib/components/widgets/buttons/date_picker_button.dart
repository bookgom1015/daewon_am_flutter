import 'package:daewon_am/components/helpers.dart';
import 'package:daewon_am/components/helpers/color_manager.dart';
import 'package:daewon_am/components/models/theme_setting_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DatePickerButton extends StatefulWidget {
  final void Function(DateTime? date) onChangedDate;
  final DateTime initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const DatePickerButton({
    Key? key,
    required this.onChangedDate,
    required this.initialDate,
    this.firstDate,
    this.lastDate}) : super(key: key);
    
  @override
  State<StatefulWidget> createState() => _DatePickerButtonState();
}

class _DatePickerButtonState extends State<DatePickerButton> {
  late ThemeSettingModel _themeModel;

  late Color _foregroundColor;
  late Color _iconForegroundColor;
  late Color _iconForegroundMouseOverColor;
  late Color _dialogBackgroundColor;

  late ColorScheme _colorScheme;

  bool _hovering = false;
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
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          _hovering = true;
        });
      },
      onExit: (event) {
        setState(() {
          _hovering = false;
        });
      },
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          final selectedDate = await showDatePickerExt(
            context: context, 
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: _colorScheme,
                  dialogBackgroundColor: _dialogBackgroundColor,
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      foregroundColor: _foregroundColor
                    )
                  )
                ),
                child: child!,
              );
            },
            initialDate: widget.initialDate, 
            firstDate: widget.firstDate ?? DateTime(2000, 1, 1), 
            lastDate: widget.lastDate ?? DateTime(2999, 12, 31),
            locale: const Locale("ko", "KR"),
          );
          widget.onChangedDate(selectedDate);
        },
        child: Row(
          children: [
            SizedBox(
              width: 32,
              height: 32,
              child: Icon(
                Icons.calendar_today,
                color: _hovering ? _iconForegroundMouseOverColor : _iconForegroundColor,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              DateFormat("yyyy-MM-dd").format(widget.initialDate),
              style: TextStyle(
                color: _foregroundColor
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onThemeModelChanged() {
    final themeType = _themeModel.getThemeType();
    _foregroundColor = ColorManager.getForegroundColor(themeType);
    _iconForegroundColor = ColorManager.getWidgetIconForegroundColor(themeType);
    _iconForegroundMouseOverColor = ColorManager.getWidgetIconForegroundMouseOverColor(themeType);
    _dialogBackgroundColor = ColorManager.getDatePickerDialogBackgroundColor(themeType);
    _colorScheme = ColorManager.getDatePickerColorScheme(themeType);
  }
}