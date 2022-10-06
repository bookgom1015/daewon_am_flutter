import 'dart:io';
import 'dart:ui';

import 'package:daewon_am/components/dialogs/ok_dialog.dart';
import 'package:daewon_am/components/entries/chart_data.dart';
import 'package:daewon_am/components/enums/privileges.dart';
import 'package:daewon_am/components/helpers/data_manager.dart';
import 'package:daewon_am/components/helpers/color_manager.dart';
import 'package:daewon_am/components/helpers/widget_helper.dart';
import 'package:daewon_am/components/models/theme_setting_model.dart';
import 'package:daewon_am/components/models/user_info_model.dart';
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

class _ChartPageState extends State<ChartPage> {
  late ThemeSettingModel _themeModel;
  late UserInfoModel _userInfoModel;

  late Color _layerBackgrondColor;
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
  
  late EPrivileges _priv;

  @override  
  void didChangeDependencies() {
    super.didChangeDependencies();
    _themeModel = context.watch<ThemeSettingModel>();
    _userInfoModel = context.watch<UserInfoModel>();

    loadColors();

    _priv = _userInfoModel.getPrivileges();

    DataManager.loadDates(
      onFinished: (dateMap) {
        if (mounted) {
          setState(() {
            _dateNavsLoaded = true;
            _dateMap = dateMap;
          });
        }
      },
      onError: (err) {
        showErrorDialog(err);
      },
      yearly: true,
    );
    DataManager.loadChartData(
      year: _selectedYear, 
      month: _selectedMonth,
      onFinished: (dataList) {
        if (mounted) {
          setState(() {
            _loadingChartData = false;
            _chartDataList = dataList;
          });
        }        
      },
      onError: (err) {
        showErrorDialog(err);
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 200,
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Colors.transparent
          ),
          child: _dateNavsLoaded ? DateNavColumn(
            dateMap: _dateMap, 
            selectedYear: _selectedYear, 
            selectedMonth: _selectedMonth,
            onTap: (year, month) => loadChartData(year, month),
            yearly: true,
          ) : const LoadingIndicator(),   
        ),
        Expanded(
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
                    child: (_priv == EPrivileges.eNone || _priv == EPrivileges.eObserver) ? 
                    const SizedBox() :
                    WidgetHelper.controlButtonWidget(
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
        )
      ],
    );
  }

  void showErrorDialog(String err) {
    if (mounted) {
      showOkDialog(
        context: context, 
        themeModel: _themeModel,
        title: "오류",
        message: err
      );   
    }
  }

  void loadColors() {
    final themeType = _themeModel.getThemeType();

    _layerBackgrondColor = ColorManager.getLayerBackgroundColor(themeType);
    _foregroundColor = ColorManager.getForegroundColor(themeType);
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
      year: _selectedYear, 
      month: _selectedMonth,
      onFinished: (dataList) {
        if (mounted) {
          setState(() {
            _loadingChartData = false;
            _chartDataList = dataList;
          });
        }        
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
      showOkDialog(
        context: context, 
        themeModel: _themeModel,
        title: "오류",
        message: e.toString()
      );      
    }
  }
}