import 'dart:io';

import 'package:daewon_am/components/dialogs/accounting_data_edit_dialog.dart';
import 'package:daewon_am/components/dialogs/accounting_data_remove_dialog.dart';
import 'package:daewon_am/components/dialogs/importing_accounting_data_dialog.dart';
import 'package:daewon_am/components/dialogs/ok_cancel_dialog.dart';
import 'package:daewon_am/components/dialogs/ok_dialog.dart';
import 'package:daewon_am/components/entries/accounting_data.dart';
import 'package:daewon_am/components/enums/privileges.dart';
import 'package:daewon_am/components/helpers/data_manager.dart';
import 'package:daewon_am/components/helpers/excel_manager.dart';
import 'package:daewon_am/components/helpers/color_manager.dart';
import 'package:daewon_am/components/helpers/widget_helper.dart';
import 'package:daewon_am/components/models/theme_setting_model.dart';
import 'package:daewon_am/components/models/user_info_model.dart';
import 'package:daewon_am/components/widgets/presets/accounting_data_grid.dart';
import 'package:daewon_am/components/widgets/presets/date_nav_column.dart';
import 'package:daewon_am/components/widgets/presets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class AccountingPage extends StatefulWidget {
  const AccountingPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AccountingPageState();
}

class _AccountingPageState extends State<AccountingPage> {
  late ThemeSettingModel _themeModel;
  late UserInfoModel _userInfoModel;

  late Color _foregroundColor;
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

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    _beginDate = DateTime(now.year, now.month, 1);
    _endDate = now;
  }

  @override  
  void didChangeDependencies() {
    super.didChangeDependencies();
    _themeModel = context.watch<ThemeSettingModel>();
    _userInfoModel = context.watch<UserInfoModel>();

    loadColors();        
    buildControlButtonWidgets();

    loadDates();    
  }

  @override
  void dispose() {
    _searchBarTextEditingController.dispose();
    _dataGridController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
            onTap: (year, month) => loadAccountingData(year, month)
          ) : const LoadingIndicator(),   
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _layerBackgrondColor,
              borderRadius: BorderRadius.circular(8)
            ),
            clipBehavior: Clip.hardEdge,
            child: Column(
              children: [
                WidgetHelper.searchBarWidget(
                  textEditingController: _searchBarTextEditingController, 
                  foregroundColor: _foregroundColor,
                  cursorColor: _cursorColor,
                  underlineColor: _underlineColor,
                  underlineFocusedColor: _underlineFocusedColor,
                  iconNormal: _widgetForegroundColor,
                  iconMouseOver: _widgetForegroundMouseOverColor,
                  onTap: searchAccountingData
                ),
                WidgetHelper.searchingDateWidget(
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
                )
              ],
            ),
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

  Widget controlButtonWidget(void Function() onTap, IconData icon, String tooltip) {
    return WidgetHelper.controlButtonWidget(
      onTap: onTap,
      normal: _widgetBackgroundColor, 
      mouseOver: _widgetBackgroundMouseOverColor,
      iconNormal: _widgetForegroundColor,
      iconMouseOver: _widgetForegroundMouseOverColor,
      icon: icon,
      tooltip: tooltip,
    );
  }

  void buildControlButtonWidgets() {
    final priv = _userInfoModel.getPrivileges();
    _controlButtonWidgets.clear();
    switch (priv) {
      case EPrivileges.eAdmin:
      _controlButtonWidgets.add(controlButtonWidget(importAccountingData, Icons.input, "입력"));
      _controlButtonWidgets.add(controlButtonWidget(exportAccountingData, Icons.print,"출력"));
      _controlButtonWidgets.add(controlButtonWidget(addAccountingData, Icons.add, "추가"));
      _controlButtonWidgets.add(controlButtonWidget(editAccountingData, Icons.edit, "수정"));
      _controlButtonWidgets.add(controlButtonWidget(removeAccountingData, Icons.delete, "삭제"));
      break;
      case EPrivileges.eAccountant:
      _controlButtonWidgets.add(controlButtonWidget(importAccountingData, Icons.input, "입력"));
      _controlButtonWidgets.add(controlButtonWidget(exportAccountingData, Icons.print,"출력"));
      _controlButtonWidgets.add(controlButtonWidget(addAccountingData, Icons.add, "추가"));
      _controlButtonWidgets.add(controlButtonWidget(editAccountingData, Icons.edit, "수정"));
      _controlButtonWidgets.add(controlButtonWidget(removeAccountingData, Icons.delete, "삭제"));
      break;
      case EPrivileges.eManager:
      _controlButtonWidgets.add(controlButtonWidget(exportAccountingData, Icons.print,"출력"));
      break;
      case EPrivileges.eObserver:
      default:
      break;
    }
  }

  void loadColors() {
    final themeType = _themeModel.getThemeType();

    _foregroundColor = ColorManager.getForegroundColor(themeType);
    _layerBackgrondColor = ColorManager.getLayerBackgroundColor(themeType);
    _widgetBackgroundColor = ColorManager.getWidgetBackgroundColor(themeType);
    _widgetBackgroundMouseOverColor = ColorManager.getWidgetBackgroundMouseOverColor(themeType);
    _widgetForegroundColor = ColorManager.getWidgetIconForegroundColor(themeType);
    _widgetForegroundMouseOverColor = ColorManager.getWidgetIconForegroundMouseOverColor(themeType);
    _underlineColor = ColorManager.getTextFormFieldUnderlineColor(themeType);
    _underlineFocusedColor = ColorManager.getTextFormFieldUnderlineFocusedColor(themeType);
    _cursorColor = ColorManager.getCursorColor(themeType);
  }

  void invalidate() {
    setState(() {
      _loadingDataList = true;
      _dataList.clear();
    });    
  }

  void loadDates() {
    DataManager.loadDates(
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
      }
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
      year: _selectedYear, 
      month: _selectedMonth,
      onFinished: (dataList) {
        if (mounted) {
          setState(() {
            _loadingDataList = false;
            _dataList = dataList;
          });
        }
      },
      onError: (err) {
        showErrorDialog(err);        
      }
    );
  }

  void searchAccountingData() {
    if (_loadingDataList) return;
    if (_searchBarTextEditingController.text == "") {
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
      begin: _beginDate, 
      end: _endDate, 
      clientName: _searchBarTextEditingController.text, 
      onFinished: (dataList) {
        if (mounted) {
          setState(() {
            _loadingDataList = false;
            _dataList = dataList;
          });
        }
      },
      onError: (err) {
        showErrorDialog(err);        
      }
    );
  }

  void addAccountingData() {
    if (_loadingDataList) return;
    showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (_) => ChangeNotifierProvider.value(
        value: _themeModel,
        child: AccountingDataEditDialog(
          onPressed: (data) {
            invalidate();
            DataManager.addAccountingData(
              data: data,
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

  void editAccountingData() {
    if (_loadingDataList) return;    
    final row = _dataGridController.selectedRow;
    if (row == null) {
      showOkDialog(
        context: context, 
        themeModel: _themeModel,
        title: "알림",
        message: "수정할 데이터를 선택하세요"                              
      );
      return;
    }
    final dataCell = row.getCells().firstWhere((element) => element.columnName == "data");
    final selectedData = dataCell.value as AccountingData;
    showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (_) => ChangeNotifierProvider.value(
        value: _themeModel,
        child: AccountingDataEditDialog(
          data: selectedData,
          onPressed: (data) {
            invalidate();
            DataManager.editAccountingData(
              data: data,
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

  void removeAccountingData() {
    if (_loadingDataList) return;
    if (_dataList.isEmpty) {
      showOkDialog(
        context: context, 
        themeModel: _themeModel,
        title: "알림",
        message: "불러온 데이터가 없습니다"
      );
      return;
    }
    showRemoveDialog(
      context: context, 
      themeModel: _themeModel,
      dataList: _dataList,
      onPressed: (dataList) {
        invalidate();
        DataManager.removeAccountingDataList(
          dataList: dataList, 
          onFinised: () {
            loadDates();
          }, 
          onError: (err) {
            showErrorDialog(err);        
          }
        );
      }
    );  
  }

  void importAccountingData() async {
    if (_loadingDataList) return;
    try {
      await ExcelManager.importAccountingData(
        onFinised: (dataList) {          
          showImportingDialog(
            context: context, 
            themeModel: _themeModel, 
            dataList: dataList,
            onPressed: () {
              invalidate();

              DataManager.addAccountingDataList(
                dataList: dataList, 
                onFinised: () {
                  loadDates();
                }, 
                onError: (err) {
                  showErrorDialog(err);
                }
              );
            }
          );
        },
      );
    }
    catch (e) {
      showErrorDialog(e.toString());
    }
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
        title: "매출입"
      );        
    }
    catch (e) {
      showErrorDialog(e.toString());
    }
  }
}