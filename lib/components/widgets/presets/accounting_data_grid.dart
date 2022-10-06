import 'dart:math';

import 'package:daewon_am/components/entries/accounting_data.dart';
import 'package:daewon_am/components/helpers/color_manager.dart';
import 'package:daewon_am/components/helpers/format_manager.dart';
import 'package:daewon_am/components/helpers/widget_helper.dart';
import 'package:daewon_am/components/models/theme_setting_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:collection/collection.dart';

class AccountingDataGrid extends StatefulWidget {
  final List<AccountingData> dataList;
  final DataGridController controller;
  final bool multiSelection;

  const AccountingDataGrid({
    Key? key,
    required this.dataList,
    required this.controller,
    this.multiSelection = false}) : super(key: key);
    
  @override
  State<StatefulWidget> createState() => _AccountingDataGridState();  
}

class _AccountingDataGridState extends State<AccountingDataGrid> {
  late ThemeSettingModel _themeModel;

  late Color _layerBackgroundColor;
  late Color _layerBackgroundTransparentColor;
  late Color _foreGroundColor;
  late Color _gridLineColor;
  late Color _dataGridRowHoverColor;
  late Color _dataGridSelectionColor;

  late Map<String, double> columnWidths;

  late AccountingDataSource _dataSource;

  String _sortedColumn = "date";
  DataGridSortDirection _sortDirection = DataGridSortDirection.ascending;


  @override
  void initState() {
    super.initState();

    columnWidths = {
      "dataType": 110,
      "clientName": 120,
      "date": 110,
      "steelWeight": 110,
      "supplyPrice": 120,
      "taxAmount": 120,
      "unitPrice": 100,
      "sum": 120,
      "depositDate": 110,
    };
  }

  @override  
  void didChangeDependencies() {
    super.didChangeDependencies();
    _themeModel = context.watch<ThemeSettingModel>();

    loadColors();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override  
  Widget build(BuildContext context) {
    _dataSource = AccountingDataSource(
      dataList: widget.dataList,
      foregroundColor: _foreGroundColor,
      onSorted: (columnName, direction) {
        _sortedColumn = columnName;
        _sortDirection = direction;
      }
    );
    _dataSource.sortedColumns.add(SortColumnDetails(
      name: _sortedColumn, 
      sortDirection: _sortDirection
    ));
    _dataSource.sort();
    return Stack(
      children: [
        SfDataGridTheme(
          data: SfDataGridThemeData(
            gridLineColor: _gridLineColor,            
            columnResizeIndicatorColor: _dataGridSelectionColor,
            headerHoverColor: _dataGridRowHoverColor,
            rowHoverColor: _dataGridRowHoverColor,
            selectionColor: _dataGridSelectionColor,
            sortIcon: Builder(
              builder: (context) {
                Widget? icon;
                String columnName = '';
                context.visitAncestorElements((element) {
                  if (element is GridHeaderCellElement) columnName = element.column.columnName;
                  return true;
                });
                var column = _dataSource.sortedColumns
                    .where((element) => element.name == columnName)
                    .firstOrNull;
                if (column != null) {
                  if (column.sortDirection == DataGridSortDirection.ascending) {
                    icon = Icon(Icons.arrow_upward, size: 16, color: _foreGroundColor);
                  } 
                  else if (column.sortDirection == DataGridSortDirection.descending) {
                    icon = Icon(Icons.arrow_downward, size: 16, color: _foreGroundColor);
                  }
                }
                return icon ?? const SizedBox();
              },
            ),
          ),
          child: SfDataGrid(
            controller: widget.controller,
            source: _dataSource,
            allowColumnsResizing: true,
            allowSorting: true,
            onColumnResizeUpdate: (details) => reduceColumnWidth(details.column.columnName, details.width),
            gridLinesVisibility: GridLinesVisibility.vertical,
            headerGridLinesVisibility: GridLinesVisibility.vertical,
            selectionMode: widget.multiSelection ? SelectionMode.multiple : SelectionMode.single,
            columns: [
              GridColumn(
                width: 0,
                columnName: "data", 
                label: const Text("")
              ),
              gridColumnWidget("dataType", "매입/매출"),
              gridColumnWidget("clientName", "거래처"),
              gridColumnWidget("date", "날짜"),
              gridColumnWidget("steelWeight", "중량(t)"),
              gridColumnWidget("supplyPrice", "공급가"),
              gridColumnWidget("taxAmount", "세액"),
              gridColumnWidget("unitPrice", "단가"),   
              gridColumnWidget("sum", "합계"),   
              gridColumnWidget("depositDate", "입금날짜"),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: WidgetHelper.fadeOutWidget(
            length: 10,
            fromColor: _layerBackgroundColor,
            toColor: _layerBackgroundTransparentColor
          ),
        ),
      ],
    );
  }

  void loadColors() {
    final themeType = _themeModel.getThemeType();

    _layerBackgroundColor = ColorManager.getLayerBackgroundColor(themeType);
    _layerBackgroundTransparentColor = ColorManager.getLayerTransparentBackgroundColor(themeType);
    _foreGroundColor = ColorManager.getForegroundColor(themeType);
    _gridLineColor = ColorManager.getDataGridLineColor(themeType);
    _dataGridRowHoverColor = ColorManager.getDataGridRowHoverColor(themeType);
    _dataGridSelectionColor = ColorManager.getDataGridSelectionColor(themeType);
  }

  bool reduceColumnWidth(String columnName, double width) {
    switch (columnName) {
      case "dataType":
      if (width <= 110) return false;
      break;
      case "clientName": 
      if (width <= 120) return false;
      break;
      case "date":
      if (width <= 110) return false;
      break;
      case "steelWeight": 
      if (width <= 110) return false;
      break;
      case "supplyPrice": 
      if (width <= 120) return false;
      break;
      case "taxAmount": 
      if (width <= 120) return false;
      break;
      case "unitPrice": 
      if (width <= 100) return false;
      break;
      case "sum": 
      if (width <= 120) return false;
      break;
      case "depositDate": 
      if (width <= 110) return false;
      break;
    }
    setState(() {
      columnWidths[columnName] = width;
    });
    return true;
  }

  GridColumn gridColumnWidget(String columnName, String label) {    
    return GridColumn(
      width: columnWidths[columnName]!,
      columnName: columnName, 
      label: Container(
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: _foreGroundColor,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      )
    );
  }
}

class AccountingDataSource extends DataGridSource {
  final Color foregroundColor;
  void Function(String columnName, DataGridSortDirection direction) onSorted;

  late List<DataGridRow> _dataList;

  @override
  List<DataGridRow> get rows => _dataList;
  
  AccountingDataSource({
    required List<AccountingData> dataList, 
    this.foregroundColor = Colors.black,
    required this.onSorted
  }) {
    _dataList = dataList.map<DataGridRow>((e) => DataGridRow(
      cells: [
        DataGridCell<AccountingData>(columnName: "data", value: e),
        DataGridCell<String>(columnName: "dataType", value: e.dataType ? "매입" : "매출"),
        DataGridCell<String>(columnName: "clientName", value: e.clientName),
        DataGridCell<String>(columnName: "date", value: FormatManager.dateTimeToString(e.date)),
        DataGridCell<double>(columnName: "steelWeight", value: e.steelWeight),
        DataGridCell<String>(columnName: "supplyPrice", value: FormatManager.thousandSeperator(e.supplyPrice)),
        DataGridCell<String>(columnName: "taxAmount", value: FormatManager.thousandSeperator(e.taxAmount)),
        DataGridCell<String>(columnName: "unitPrice", value: FormatManager.thousandSeperator(e.unitPrice)),
        DataGridCell<String>(columnName: "sum", value: FormatManager.thousandSeperator(e.supplyPrice + e.taxAmount)),
        DataGridCell<String>(columnName: "depositDate", value: (!e.depositConfirmed || e.depositDate == null) ? 
          "" : FormatManager.dateTimeToString(e.depositDate!)),
      ]
    )).toList();
  }
  
  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((e) {
        return Container(
          alignment: getAlignment(e.columnName),
          padding: const EdgeInsets.all(10),
          child: Text(
            e.value.toString(),
            style: TextStyle(
              color: foregroundColor,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      }).toList()
    );
  }

  Alignment? getAlignment(String columnName) {
    if (columnName == "dataType") {
      return Alignment.center;
    }
    else if (columnName == "clientName") {
      return Alignment.center;
    } else if (columnName == "date") {
      return Alignment.center;
    }
    else if (columnName == "steelWeight") {
      return Alignment.centerRight;
    }
    else if (columnName == "supplyPrice") {
      return Alignment.centerRight;
    }
    else if (columnName == "taxAmount") {
      return Alignment.centerRight;
    }
    else if (columnName == "unitPrice") {
      return Alignment.centerRight;
    }
    else if (columnName == "sum") {
      return Alignment.centerRight;
    }
    else if (columnName == "depositDate") {
      return Alignment.center;
    }
    else {
      return null;
    }
  }

  @override
  int compare(DataGridRow? a, DataGridRow? b, SortColumnDetails sortColumn) {
    onSorted(sortColumn.name, sortColumn.sortDirection);
    String? value1 = a?.getCells().firstWhereOrNull((element) => element.columnName == sortColumn.name)?.value.toString();
    String? value2 = b?.getCells().firstWhereOrNull((element) => element.columnName == sortColumn.name)?.value.toString();
    bool ascen = sortColumn.sortDirection == DataGridSortDirection.ascending;
    if (value1 == null || value2 == null) return 0;
    try {
      switch (sortColumn.name) {
        case "dataType":
        bool dataType1 = value1 == "매입";
        bool dataType2 = value2 == "매입";
        if (dataType1 == true && dataType2 == false) {
          return ascen ? -1 : 1;
        }
        else if (dataType1 == false && dataType2 == true) {
          return ascen ? 1 : -1;
        }
        else {
          return 0;
        }
        case "clientName":
        String clientName1 = value1;
        String clientName2 = value2;
        if (ascen) {
          return clientName1.compareTo(clientName2);
        }
        else {
          return clientName2.compareTo(clientName1);
        }
        case "date":
        DateTime date1 = DateTime.parse(value1);
        DateTime date2 = DateTime.parse(value2);
        if (ascen) {
          return date1.compareTo(date2);
        }
        else {
          return date2.compareTo(date1);
        }
        case "steelWeight": 
        double steelWeight1 = double.parse(value1);
        double steelWeight2 = double.parse(value2);
        if (steelWeight1 < steelWeight2) {
          return ascen ? -1 : 1;
        }
        else if (steelWeight1 > steelWeight2) {
          return ascen ? 1 : -1;
        }
        else {
          return 0;
        }
        case "supplyPrice": 
        int supplyPrice1 = int.parse(value1.replaceAll(",", ""));
        int supplyPrice2 = int.parse(value2.replaceAll(",", ""));
        if (supplyPrice1 < supplyPrice2) {
          return ascen ? -1 : 1;
        }
        else if (supplyPrice1 > supplyPrice2) {
          return ascen ? 1 : -1;
        }
        else {
          return 0;
        }
        case "taxAmount": 
        int taxAmount1 = int.parse(value1.replaceAll(",", ""));
        int taxAmount2 = int.parse(value2.replaceAll(",", ""));
        if (taxAmount1 < taxAmount2) {
          return ascen ? -1 : 1;
        }
        else if (taxAmount1 > taxAmount2) {
          return ascen ? 1 : -1;
        }
        else {
          return 0;
        }
        case "unitPrice": 
        int unitPrice1 = int.parse(value1.replaceAll(",", ""));
        int unitPrice2 = int.parse(value2.replaceAll(",", ""));
        if (unitPrice1 < unitPrice2) {
          return ascen ? -1 : 1;
        }
        else if (unitPrice1 > unitPrice2) {
          return ascen ? 1 : -1;
        }
        else {
          return 0;
        }
        case "sum": 
        int sum1 = int.parse(value1.replaceAll(",", ""));
        int sum2 = int.parse(value2.replaceAll(",", ""));
        if (sum1 < sum2) {
          return ascen ? -1 : 1;
        }
        else if (sum1 > sum2) {
          return ascen ? 1 : -1;
        }
        else {
          return 0;
        }
        case "depositDate": 
        DateTime defDate = DateTime(ascen ? 2999 : 1999);
        DateTime date1 = DateTime.tryParse(value1) ?? defDate;
        DateTime date2 = DateTime.tryParse(value2) ?? defDate;
        if (ascen) {
          return date1.compareTo(date2);
        }
        else {
          return date2.compareTo(date1);
        }
        default:
        return 0;
      }
    }
    catch (e) {
      return 0;
    }
  }
}