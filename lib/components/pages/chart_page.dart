import 'dart:io';
import 'dart:ui';

import 'package:daewon_am/components/dialogs/ok_dialog.dart';
import 'package:daewon_am/components/entries/chart_data.dart';
import 'package:daewon_am/components/enums/privileges.dart';
import 'package:daewon_am/components/globals/global_theme_settings.dart';
import 'package:daewon_am/components/helpers/data_manager.dart';
import 'package:daewon_am/components/helpers/color_manager.dart';
import 'package:daewon_am/components/models/theme_setting_model.dart';
import 'package:daewon_am/components/models/user_info_model.dart';
import 'package:daewon_am/components/widgets/buttons/mouse_reaction_icon_button.dart';
import 'package:daewon_am/components/widgets/buttons/control_button.dart';
import 'package:daewon_am/components/widgets/presets/date_nav_column.dart';
import 'package:daewon_am/components/widgets/presets/loading_indicator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChartPageState();
}

class SimpleData {
  SimpleData(this.label, this.value);

  String label;
  int value;
}

class _ChartPageState extends State<ChartPage> with SingleTickerProviderStateMixin {
  late ThemeSettingModel _themeModel;
  late UserInfoModel _userInfoModel;

  late Color _layerBackgrondColor;
  late Color _backgroundColor;
  late Color _foregroundColor;
  late Color _chartLabelColor;
  late Color _chartXAxisColor;
  late Color _chartYAxisColor;
  late Color _chartOutcomeColor;
  late Color _chartIncomeColor;
  late Color _widgetBackgroundColor;
  late Color _widgetBackgroundMouseOverColor;
  late Color _widgetForegroundColor;
  late Color _widgetForegroundMouseOverColor;

  late Map<int, Set<int>> _dateMap;
  bool _dateNavsLoaded = false;

  int _selectedYear = -1;
  int _selectedMonth = -1;

  List<SfChartData> _chartDataList = [];
  bool _loadingChartData = true;

  late TextStyle _foregrundTextStyle;
  late TextStyle _chartLabelTextStyle;

  String _title = "연간차트";

  final GlobalKey<SfCartesianChartState> _chartKey = GlobalKey();

  bool _firstCall = true;

  late AnimationController _controller;
  late Animation<double> _curveAnimation;
  late Animation<double> _animation;

  bool _forward = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300)
    );
    _curveAnimation = CurvedAnimation(
      parent: _controller, 
      curve: Curves.easeOutQuart
    );
    _animation = Tween<double>(
      // 
      begin: 0.0,
      end: 200.0
    ).animate(_curveAnimation);
    _controller.addStatusListener((status) { 
      if (status.name == "completed") {
        _forward = false;
      }
      else if (status.name == "dismissed") {
        _forward = true;
      }
    });
  }

  @override  
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_firstCall) {
      _firstCall = false;
      _themeModel = context.watch<ThemeSettingModel>();
      _userInfoModel = context.watch<UserInfoModel>();
      _themeModel.addListener(onThemeModelChanged);
      onThemeModelChanged();
      DataManager.loadDates(
        token: _userInfoModel.getToken(),
        onFinished: (dateMap) {
          if (!mounted) return;
          setState(() {
            _dateNavsLoaded = true;
            _dateMap = dateMap;
          });
        },
        onError: (err) {
          showErrorDialog(err);
        },
        yearly: true,
      );
      DataManager.loadChartData(
        token: _userInfoModel.getToken(),
        year: _selectedYear, 
        month: _selectedMonth,
        onFinished: (dataList) {
          if (!mounted) return;
          setState(() {
            _loadingChartData = false;
            _chartDataList = dataList;
          });
        },
        onError: (err) {
          showErrorDialog(err);
        }
      );
    }    
  }

  @override
  void dispose() {
    _themeModel.removeListener(onThemeModelChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 1200) {
          return AnimatedBuilder(
            animation: _controller, 
            builder: (context, _) {
              return Stack(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        width: _animation.value,
                        clipBehavior: Clip.hardEdge,
                        decoration: const BoxDecoration(),
                        child: datePanelWidget(),
                      ),
                      chartPanelWidget(),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Transform.translate(
                      offset: Offset(_animation.value, 0),
                      child: Opacity(
                        opacity: 0.8,
                        child: MouseReactionIconButton(
                          onTap: () {
                            if (_forward) {
                              _controller.forward();
                            }
                            else {
                              _controller.reverse();
                            }
                          },
                          width: 45,
                          height: 45,
                          shape: BoxShape.circle,
                          margin: const EdgeInsets.only(left: 15),
                          duration: colorChangeDuration,
                          curve: colorChangeCurve,
                          normal: _widgetBackgroundColor,
                          mouseOver: _widgetBackgroundMouseOverColor,
                          iconNormal: _widgetForegroundColor,
                          iconMouseOver: _widgetForegroundMouseOverColor,
                          icon: _forward ? Icons.keyboard_arrow_right : Icons.keyboard_arrow_left,
                          iconSize: 45,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          );
        }
        else {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              datePanelWidget(),
              chartPanelWidget(),
            ],
          );
        }
      }
    );
  }

  void showErrorDialog(String err) {
    if (!mounted) return;
    showOkDialog(
      context: context, 
      themeModel: _themeModel,
      title: "오류",
      message: err
    );
  }

  void onThemeModelChanged() {
    final themeType = _themeModel.getThemeType();
    _layerBackgrondColor = ColorManager.getLayerBackgroundColor(themeType);
    _foregroundColor = ColorManager.getForegroundColor(themeType);
    _backgroundColor = ColorManager.getBackgroundColor(themeType);
    _chartLabelColor = ColorManager.getChartLabelColor(themeType);
    _chartXAxisColor = ColorManager.getChartXAxisColor(themeType);
    _chartYAxisColor = ColorManager.getChartYAxisColor(themeType);
    _chartOutcomeColor = ColorManager.getChartOutcomeColumnColor(themeType);
    _chartIncomeColor = ColorManager.getChartIncomeColumnColor(themeType);
    _widgetBackgroundColor = ColorManager.getWidgetBackgroundColor(themeType);
    _widgetBackgroundMouseOverColor = ColorManager.getWidgetBackgroundMouseOverColor(themeType);
    _widgetForegroundColor = ColorManager.getWidgetIconForegroundColor(themeType);
    _widgetForegroundMouseOverColor = ColorManager.getWidgetIconForegroundMouseOverColor(themeType);
    _foregrundTextStyle = TextStyle(
      color: _foregroundColor
    );
    _chartLabelTextStyle = TextStyle(
      color: _chartLabelColor
    );
  }

  void loadChartData(int year, int month) {    
    if (!_dateMap.containsKey(year) || (month != -1 && !_dateMap[year]!.contains(month))) {
      setState(() {
        _selectedYear = -1;
        _selectedMonth = -1;
        _chartDataList.clear();
      });
      return;
    }
    String title;
    if (year == -1 && month == -1) {
      title = "연간차트";
    }
    else if (year != -1 && month  == -1) {
      title = "$year년 월간차트";
    }
    else {
      title = "$year년 $month월 일간차트";
    }
    setState(() {
      _selectedYear = year;
      _selectedMonth = month;
      _loadingChartData = true;
      _chartDataList.clear();
      _title = title;
    });
    DataManager.loadChartData(
      token: _userInfoModel.getToken(),
      year: _selectedYear, 
      month: _selectedMonth,
      onFinished: (dataList) {
        if (!mounted) return;
        setState(() {
          _loadingChartData = false;
          _chartDataList = dataList;
        });       
      },
      onError: (err) {
        showErrorDialog(err);
      }
    );
  }

  void exportChartImage() async {
    try {
      var fileName = await FilePicker.platform.saveFile(
        type: FileType.custom,
        allowedExtensions: ["png"],
        fileName: "차트.png",
        lockParentWindow: true
      );
      if (fileName == null) return;
      if (!fileName.contains(".png")) fileName = "$fileName.png";
      final imageData = await _chartKey.currentState!.toImage(pixelRatio: 3);
      final bytes = await imageData.toByteData(format: ImageByteFormat.png);
      final File file = File(fileName);
      await file.writeAsBytes(bytes!.buffer.asInt8List(), flush: true);
    }
    catch (e) {
      showErrorDialog(e.toString());
    }
  }

  Widget datePanelWidget() {
    return Container(
      width: 200,
      padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
      decoration: BoxDecoration(
        color: _backgroundColor,
      ),
      child: _dateNavsLoaded ? DateNavColumn(
        dateMap: _dateMap, 
        selectedYear: _selectedYear, 
        selectedMonth: _selectedMonth,
        onTap: (year, month) {
          if (_loadingChartData) return;
          loadChartData(year, month);
        }
      ) : const LoadingIndicator(),   
    );
  }

  Widget chartPanelWidget() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8)
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            SfCartesianChart(
              key: _chartKey,
              backgroundColor: _layerBackgrondColor,
              plotAreaBorderWidth: 0,
              primaryXAxis: CategoryAxis(
                labelStyle: _chartLabelTextStyle,
                axisLine: AxisLine(
                  color: _chartYAxisColor
                ),
                majorGridLines: MajorGridLines(
                  width: 1,
                  color: _chartXAxisColor
                ),
                majorTickLines: MajorTickLines(
                  color: _chartXAxisColor
                )
              ),
              primaryYAxis: NumericAxis(
                numberFormat: NumberFormat.simpleCurrency(locale: "ko_KR"),
                labelStyle: _chartLabelTextStyle,
                axisLine: const AxisLine(
                  color: Colors.transparent
                ),
                majorGridLines: MajorGridLines(
                  width: 1,
                  color: _chartYAxisColor
                ),
                majorTickLines: MajorTickLines(
                  color: _chartYAxisColor
                )
              ),
              title: ChartTitle(
                text: _title,
                textStyle: TextStyle(
                  color: _foregroundColor
                )
              ),
              legend: Legend(
                isVisible: true,
                position: LegendPosition.top,
                textStyle: TextStyle(
                  color: _foregroundColor
                )
              ),
              tooltipBehavior: TooltipBehavior(
                enable: true,
                tooltipPosition: TooltipPosition.pointer
              ),
              series: <ChartSeries<SfChartData, String>> [
                ColumnSeries(
                  dataSource: _chartDataList, 
                  xValueMapper: (SfChartData data, _) => data.date, 
                  yValueMapper: (SfChartData data, _) => data.income, 
                  name: "매출",
                  dataLabelSettings: DataLabelSettings(
                    isVisible:  true,
                    textStyle: _foregrundTextStyle
                  ),
                  width: 1,
                  spacing: 0.5,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight:  Radius.circular(8)),                      
                  color: _chartOutcomeColor,
                ),
                ColumnSeries(
                  dataSource: _chartDataList, 
                  xValueMapper: (SfChartData data, _) => data.date, 
                  yValueMapper: (SfChartData data, _) => data.outcome, 
                  name: "매입",
                  dataLabelSettings: DataLabelSettings(
                    isVisible:  true,
                    textStyle: _foregrundTextStyle
                  ),
                  width: 1,
                  spacing: 0.5,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight:  Radius.circular(8)),
                  color: _chartIncomeColor,
                )
              ],
            ),
            Align(                  
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: _userInfoModel.getPrivileges() == EPrivileges.eNone ? 
                const SizedBox() :
                ControlButton(
                  onTap: exportChartImage, 
                  normal: _widgetBackgroundColor, 
                  mouseOver: _widgetBackgroundMouseOverColor,
                  iconNormal: _widgetForegroundColor,
                  iconMouseOver: _widgetForegroundMouseOverColor,
                  icon: Icons.print,
                  tooltip: "출력",
                ),
              ),
            ),
            _loadingChartData ? const LoadingIndicator() : const SizedBox()
          ],
        )
      )
    );
  }
}