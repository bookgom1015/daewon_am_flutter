import 'package:daewon_am/components/globals/global_theme_settings.dart';
import 'package:daewon_am/components/helpers/color_manager.dart';
import 'package:daewon_am/components/models/theme_setting_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DateNavButton extends StatefulWidget {
  static const double dateNavHeight = 40.0;
  static const double dateNavVerticalMargin = 10.0;
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
    bool selected = widget.year == widget.selectedYear && widget.month == widget.selectedMonth;
    bool monthly = widget.month != -1;
    return Container(
      height: DateNavButton.dateNavHeight,
      margin: EdgeInsets.only(left: monthly ? 25 : 0, bottom: DateNavButton.dateNavVerticalMargin),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8)
      ),
      child: MouseRegion(
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
          onTap: () {
            if (selected) {
              widget.onTap(-1, -1);
            }
            else {
              widget.onTap(widget.year, widget.month);
            }
          },
          child: AnimatedContainer(
            duration: colorChangeDuration,
            curve: colorChangeCurve,
            padding: const EdgeInsets.only(left: 20),
            color: (selected || _hovering) ? _widgetBackgrondMouseOverColor : _widgetBackgrondColor,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.year == -1 ? "연간차트" : 
                  (widget.month == -1 ? "${widget.year}년" : "${widget.year}년 ${widget.month}월"),
                maxLines: 1,
                style: TextStyle(
                  color: _foregroundColor,
                  overflow: TextOverflow.clip,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onThemeModelChanged() {
    final themeType = _themeModel.getThemeType();
    _foregroundColor = ColorManager.getForegroundColor(themeType);
    _widgetBackgrondColor = ColorManager.getWidgetBackgroundColor(themeType);
    _widgetBackgrondMouseOverColor = ColorManager.getWidgetBackgroundMouseOverColor(themeType);
  }
}