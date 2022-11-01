import 'package:daewon_am/components/globals/global_theme_settings.dart';
import 'package:daewon_am/components/helpers/color_manager.dart';
import 'package:daewon_am/components/helpers/widget_helper.dart';
import 'package:daewon_am/components/models/theme_setting_model.dart';
import 'package:daewon_am/components/widgets/buttons/date_nav_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DateNavColumn extends StatefulWidget {
  final Map<int, Set<int>> dateMap;
  final int selectedYear;
  final int selectedMonth;
  final void Function(int year, int month) onTap;
  final bool yearly;

  const DateNavColumn({
    Key? key,
    required this.dateMap,
    this.selectedYear = -1,
    this.selectedMonth = -1,
    required this.onTap,
    this.yearly = false}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DateNavColumnState();
}

class _DateNavColumnState extends State<DateNavColumn> {
  late ThemeSettingModel _themeModel;

  late Color _backgroundColor;
  late Color _backgroundTransparentColor;

  final double _fadeLength = 10;
  final double _dateNavHeight = 40;
  final double _dateNavVerticalMargin = 10;  

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
    return Stack(
      children: [
        ListView.builder(
          padding: EdgeInsets.only(top: _fadeLength),
          itemCount: widget.dateMap.keys.length,
          itemBuilder: (_, index) {
            final year = widget.dateMap.keys.elementAt(index);
            return dateNavsWidget(year);
          }
        ),
        WidgetHelper.fadeOutWidget(
          length: _fadeLength, 
          fromColor: _backgroundColor, 
          toColor: _backgroundTransparentColor
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: WidgetHelper.fadeOutWidget(
            length: _fadeLength, 
            fromColor: _backgroundTransparentColor, 
            toColor: _backgroundColor
          ),
        )
      ],
    );
  }

  void onThemeModelChanged() {
    final themeType = _themeModel.getThemeType();
    _backgroundColor = ColorManager.getBackgroundColor(themeType);
    _backgroundTransparentColor = ColorManager.getBackgroundTransparentColor(themeType);
  }

  Widget dateNavsWidget(int year) {
    final monthSet = widget.dateMap[year]!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DateNavButton(
          year: year, 
          month: -1, 
          selectedYear: widget.selectedYear,
          selectedMonth: widget.selectedMonth,
          onTap: widget.onTap
        ),
        AnimatedContainer(
          duration: dateNavSizeChangeDuration,
          curve: dateNavSizeChangeCurve,
          height: widget.selectedYear == year ? monthSet.length * (_dateNavHeight + _dateNavVerticalMargin) : 0,
          decoration: const BoxDecoration(),
          clipBehavior: Clip.hardEdge,
          child: Stack(
            children: [
              ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false), 
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: monthSet.length,
                  itemBuilder: (_, index) {
                    return DateNavButton(
                      year: year, 
                      month: monthSet.elementAt(index),
                      selectedYear: widget.selectedYear,
                      selectedMonth: widget.selectedMonth,
                      onTap: widget.onTap,
                    );
                  }
                )
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: WidgetHelper.fadeOutWidget(
                  length: _dateNavVerticalMargin,
                  fromColor: _backgroundTransparentColor,
                  toColor: _backgroundColor
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}