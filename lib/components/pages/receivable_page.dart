import 'package:daewon_am/components/dialogs/accounting_data_confirm_dialog.dart';
import 'package:daewon_am/components/dialogs/ok_dialog.dart';
import 'package:daewon_am/components/entries/accounting_data.dart';
import 'package:daewon_am/components/enums/privileges.dart';
import 'package:daewon_am/components/globals/global_theme_settings.dart';
import 'package:daewon_am/components/helpers/data_manager.dart';
import 'package:daewon_am/components/helpers/color_manager.dart';
import 'package:daewon_am/components/helpers/excel_manager.dart';
import 'package:daewon_am/components/models/theme_setting_model.dart';
import 'package:daewon_am/components/models/user_info_model.dart';
import 'package:daewon_am/components/widgets/buttons/mouse_reaction_icon_button.dart';
import 'package:daewon_am/components/widgets/data_grids/accounting_data_grid.dart';
import 'package:daewon_am/components/widgets/data_grids/accounting_data_grid_summary.dart';
import 'package:daewon_am/components/widgets/buttons/control_button.dart';
import 'package:daewon_am/components/widgets/presets/date_nav_column.dart';
import 'package:daewon_am/components/widgets/presets/loading_indicator.dart';
import 'package:daewon_am/components/widgets/presets/search_bar.dart';
import 'package:daewon_am/components/widgets/buttons/searching_date_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ReceivablePage extends StatefulWidget {
  const ReceivablePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ReceivablePageState();
}

class _ReceivablePageState extends State<ReceivablePage> with SingleTickerProviderStateMixin {
  late ThemeSettingModel _themeModel;
  late UserInfoModel _userInfoModel;

  late Color _foregroundColor;
  late Color _backgroundColor;
  late Color _layerBackgrondColor;
  late Color _widgetBackgroundColor;
  late Color _widgetBackgroundMouseOverColor;
  late Color _widgetForegroundColor;
  late Color _widgetForegroundMouseOverColor;
  late Color _underlineColor;
  late Color _underlineFocusedColor;
  late Color _cursorColor;

  late Map<int, Set<int>> _dateMap;
  bool _dateNavsLoaded = false;

  List<AccountingData> _dataList = [];
  bool _loadingDataList = false;
  int _selectedYear = -1;
  int _selectedMonth = -1;

  late DateTime _beginDate;
  late DateTime _endDate;

  final _searchBarTextEditingController = TextEditingController();

  final _dataGridController = DataGridController();  

  final List<Widget> _controlButtonWidgets = [];

  bool _firstCall = true;

  late AnimationController _controller;
  late Animation<double> _curveAnimation;
  late Animation<double> _animation;

  bool _forward = true;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _beginDate = DateTime(now.year, now.month, 1);
    _endDate = now;
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
      loadDates();
    }
  }

  @override
  void dispose() {
    _themeModel.removeListener(onThemeModelChanged);
    _searchBarTextEditingController.dispose();
    _dataGridController.dispose();
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
                      dataPanelWidget(),
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
              dataPanelWidget(),
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
    // 컬러 불러오기
    final themeType = _themeModel.getThemeType();
    _foregroundColor = ColorManager.getForegroundColor(themeType);
    _backgroundColor = ColorManager.getBackgroundColor(themeType);
    _layerBackgrondColor = ColorManager.getLayerBackgroundColor(themeType);
    _widgetBackgroundColor = ColorManager.getWidgetBackgroundColor(themeType);
    _widgetBackgroundMouseOverColor = ColorManager.getWidgetBackgroundMouseOverColor(themeType);
    _widgetForegroundColor = ColorManager.getWidgetIconForegroundColor(themeType);
    _widgetForegroundMouseOverColor = ColorManager.getWidgetIconForegroundMouseOverColor(themeType);
    _underlineColor = ColorManager.getTextFormFieldUnderlineColor(themeType);
    _underlineFocusedColor = ColorManager.getTextFormFieldUnderlineFocusedColor(themeType);
    _cursorColor = ColorManager.getCursorColor(themeType);
    // 컨트롤 버튼 빌드
    _controlButtonWidgets.clear();
    switch (_userInfoModel.getPrivileges()) {
      case EPrivileges.eAdmin:
      case EPrivileges.eAccountant:
      case EPrivileges.eManager:
      _controlButtonWidgets.add(controlButtonWidget(exportAccountingData, Icons.print,"출력"));
      _controlButtonWidgets.add(controlButtonWidget(confirmAccountingData, Icons.check, "확인"));
      break;
      case EPrivileges.eObserver:
      _controlButtonWidgets.add(controlButtonWidget(exportAccountingData, Icons.print,"출력"));
      break;
      default:
      break;
    }
  }

  void invalidate() {
    setState(() {
      _loadingDataList = true;
      _dataList.clear();
    });    
  }

  void loadDates() {
    DataManager.loadDates(
      token: _userInfoModel.getToken(),
      onFinished: (dateMap) {
        if (!mounted) return;
        setState(() {
          _dateNavsLoaded = true;
          _dateMap = dateMap;
        });
        loadAccountingData(_selectedYear, _selectedMonth);
      },
      onError: (err) {
        showErrorDialog(err);
      },
      receivable: true,
    );
  }

  void loadAccountingData(int year, int month) {
    if (year == -1 || !_dateMap.containsKey(year)) {
      setState(() {
        _selectedYear = -1;
        _selectedMonth = -1;
        _loadingDataList = false;
        _dataList.clear();
      });
      return;
    }
    setState(() {
      _selectedYear = year;
      _selectedMonth = _dateMap[year]!.contains(month) ? month : -1;
      _loadingDataList = true;
      _dataList.clear();
    });
    DataManager.loadAccountingData(
      token: _userInfoModel.getToken(),
      year: _selectedYear, 
      month: _selectedMonth,
      onFinished: (dataList) {
        if (!mounted) return;
        setState(() {
          _loadingDataList = false;
          _dataList = dataList;
        });
      },
      onError: (err) {
        showErrorDialog(err);        
      },
      receivable: true,
    );
  }

  void searchAccountingData() {
    if (_loadingDataList) return;
    if (_searchBarTextEditingController.text.isEmpty) {
      showOkDialog(
        context: context, 
        themeModel: _themeModel,
        title: "알림",
        message: "검색어를 입력하세요"                              
      );
      return;
    }
    setState(() {
      _selectedYear = -1;
      _selectedMonth = -1;
      _loadingDataList = true;
      _dataList.clear();
    });
    DataManager.searchAccountingData(
      token: _userInfoModel.getToken(),
      begin: _beginDate, 
      end: _endDate, 
      clientName: _searchBarTextEditingController.text, 
      onFinished: (dataList) {        
        if (!mounted) return;
        setState(() {
          _loadingDataList = false;
          _dataList = dataList;
        });
      },
      onError: (err) {
        showErrorDialog(err);        
      },
      receivable: true,
    );
  }

  void confirmAccountingData() {
    final row = _dataGridController.selectedRow;
    if (row == null) {
      showOkDialog(
        context: context, 
        themeModel: _themeModel,
        title: "알림",
        message: "확인할 데이터를 선택하세요"                              
      );
      return;
    }
    final dataCell = row.getCells().firstWhere((element) => element.columnName == "data");
    final selectedData = dataCell.value as AccountingData;
    if (selectedData.dataType == false && _userInfoModel.getPrivileges() == EPrivileges.eManager ) {
      showOkDialog(
        context: context, 
        themeModel: _themeModel,
        title: "경고",
        message: "매출 데이터를 확인할 권한이 없습니다"                              
      );
      return;
    }
    showDialog(
      context: context, 
      builder: (_) => ChangeNotifierProvider.value(
        value: _themeModel,
        child: AccountingDataConfirmDialog(
          onDateChagned: (date) {
            final dataCell = row.getCells().firstWhere((element) => element.columnName == "data");
            final selectedData = dataCell.value as AccountingData;
            selectedData.depositConfirmed = true;
            selectedData.depositDate = date;
            invalidate();
            DataManager.editAccountingData(
              token: _userInfoModel.getToken(),
              data: selectedData,
              onFinised: () {
                loadDates();              
              },
              onError: (err) {
                showErrorDialog(err);        
              }
            );
          },
        ),
      )
    );
  }

  void exportAccountingData() async {
    if (_dataList.isEmpty) {
      showOkDialog(
        context: context, 
        themeModel: _themeModel,
        title: "알림",
        message: "출력할 데이터를 선택하세요"                              
      );
      return;
    }
    try {
      await ExcelManager.exportAccountingData(
        dataList: _dataList,
        title: "미수금"
      );        
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
          if (_loadingDataList) return;
          loadAccountingData(year, month);
        }
      ) : const LoadingIndicator(),   
    );
  }

  Widget dataPanelWidget() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: _layerBackgrondColor,
          borderRadius: BorderRadius.circular(8)
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          children: [
            SearchBar(
              controller: _searchBarTextEditingController, 
              foregroundColor: _foregroundColor,
              cursorColor: _cursorColor,
              underlineColor: _underlineColor,
              underlineFocusedColor: _underlineFocusedColor,
              iconNormal: _widgetForegroundColor,
              iconMouseOver: _widgetForegroundMouseOverColor,
              onTap: searchAccountingData
            ),
            SearchingDateButton(
              beginDate: _beginDate,
              endDate: _endDate,
              onChangedBeginDate: (date) {
                if (date == null) return;
                setState(() {
                  _beginDate = date;
                });
              },
              onChangedEndDate: (date) {
                if (date == null) return;
                setState(() {
                  _endDate = date;
                });
              },
              color: _widgetForegroundColor,
            ),
            Container(
              height: 40,
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: _controlButtonWidgets,
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  AccountingDataGrid(
                    dataList: _dataList,
                    controller: _dataGridController,
                  ),
                  _loadingDataList ? const LoadingIndicator() : const SizedBox()
                ],
              ),
            ),
            Container(
              height: 40,
              color: _widgetBackgroundColor,
              child: AccountingDataGridSummary(dataList: _dataList),
            ),
          ],
        ),
      )
    );
  }

  Widget controlButtonWidget(void Function() onTap, IconData icon, String tooltip) {
    return ControlButton(
      onTap: onTap,
      normal: _widgetBackgroundColor, 
      mouseOver: _widgetBackgroundMouseOverColor,
      iconNormal: _widgetForegroundColor,
      iconMouseOver: _widgetForegroundMouseOverColor,
      icon: icon,
      tooltip: tooltip,
    );
  }
}