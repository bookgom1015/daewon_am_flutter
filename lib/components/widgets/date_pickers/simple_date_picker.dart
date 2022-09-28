import 'package:daewon_am/components/helpers.dart';
import 'package:daewon_am/components/helpers/theme/color_manager.dart';
import 'package:daewon_am/components/models/theme_setting_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SimpleDatePicker extends StatefulWidget {
  final void Function(DateTime? date) onChangedDate;
  final DateTime initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const SimpleDatePicker({
    Key? key,
    required this.onChangedDate,
    required this.initialDate,
    this.firstDate,
    this.lastDate}) : super(key: key);
    
  @override
  State<StatefulWidget> createState() => _SimpleDatePickerState();
}

class _SimpleDatePickerState extends State<SimpleDatePicker> {
  late ThemeSettingModel _themeModel;

  late Color _foregroundColor;
  late Color _iconColor;
  late Color _iconForegroundColor;
  late Color _iconForegroundMouseOverColor;
  late Color _dialogBackgroundColor;

  late ColorScheme _colorScheme;

  bool _hovering = false;

  @override  
  void didChangeDependencies() {
    super.didChangeDependencies();
    _themeModel = context.watch<ThemeSettingModel>();

    loadColors();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MouseRegion(
          onEnter: (event) {
            _hovering = true;
            setState(() {
              _iconColor = _iconForegroundMouseOverColor;
            });
          },
          onExit: (event) {
            _hovering = false;
            setState(() {
              _iconColor = _iconForegroundColor;
            });
          },
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () async {
              var selectedDate = await showDatePickerExt(
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
            child: SizedBox(
              width: 32,
              height: 32,
              child: Icon(
                Icons.calendar_today,
                color: _iconColor,
              ),
            ),
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
    );
  }

  void loadColors() {
    var themeType = _themeModel.getThemeType();

    _foregroundColor = ColorManager.getForegroundColor(themeType);
    _iconForegroundColor = ColorManager.getWidgetIconForegroundColor(themeType);
    _iconForegroundMouseOverColor = ColorManager.getWidgetIconForegroundMouseOverColor(themeType);
    _dialogBackgroundColor = ColorManager.getDatePickerDialogBackgroundColor(themeType);

    _colorScheme = ColorManager.getDatePickerColorScheme(themeType);

    _iconColor = _hovering ? _iconForegroundMouseOverColor : _iconForegroundColor;
  }
}