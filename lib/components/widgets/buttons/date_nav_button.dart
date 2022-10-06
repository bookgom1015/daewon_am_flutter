import 'package:daewon_am/components/globals/global_theme_settings.dart';
import 'package:daewon_am/components/helpers/color_manager.dart';
import 'package:daewon_am/components/models/theme_setting_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DateNavButton extends StatefulWidget {
  final int year;
  final int month;
  final int selectedYear;
  final int selectedMonth;

  final void Function(int year, int month) onTap;

  const DateNavButton({
    Key? key,
    required this.year,
    required this.month,
    this.selectedYear = -1,
    this.selectedMonth = -1,
    required this.onTap}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DateNavButtonState();
}

class _DateNavButtonState extends State<DateNavButton> {
  late ThemeSettingModel _themeModel;

  late Color _foregroundColor;
  late Color _widgetBackgrondColor;
  late Color _widgetBackgrondMouseOverColor;

  late Color _color;

  final double _dateNavHeight = 40;
  final double _dateNavVerticalMargin = 10;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _themeModel = context.watch<ThemeSettingModel>();

    loadColors();
  }

  @override
  Widget build(BuildContext context) {
    bool selected = widget.year == widget.selectedYear && widget.month == widget.selectedMonth;

    return Container(
      height: _dateNavHeight,
      margin: EdgeInsets.only(left: widget.month == -1 ? 0 : 20, bottom: _dateNavVerticalMargin),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8)
      ),
      child: MouseRegion(
        onEnter: (event) {
          setState(() {
            _color = _widgetBackgrondMouseOverColor;
          });
        },
        onExit: (event) {
          setState(() {
            _color = _widgetBackgrondColor;
          });        
        },
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            if (selected) return;
            widget.onTap(widget.year, widget.month);
          },
          child: AnimatedContainer(
            duration: colorChangeDuration,
            curve: colorChangeCurve,
            padding: const EdgeInsets.only(left: 20),
            color: selected ? _widgetBackgrondMouseOverColor : _color,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.year == -1 ? "연간차트" : 
                  (widget.month == -1 ? "${widget.year}년" : "${widget.year}년 ${widget.month}월"),
                style: TextStyle(
                  color: _foregroundColor
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void loadColors() {
    final themeType = _themeModel.getThemeType();

    _foregroundColor = ColorManager.getForegroundColor(themeType);
    _widgetBackgrondColor = ColorManager.getWidgetBackgroundColor(themeType);
    _widgetBackgrondMouseOverColor = ColorManager.getWidgetBackgroundMouseOverColor(themeType);

    _color = _widgetBackgrondColor;
  }
}