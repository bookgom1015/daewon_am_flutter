import 'package:daewon_am/components/entries/accounting_data.dart';
import 'package:daewon_am/components/helpers/theme/color_manager.dart';
import 'package:daewon_am/components/models/theme_setting_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class AccountingDataGrid extends StatefulWidget {
  final List<AccountingData> dataList;
  final DataGridController controller;

  const AccountingDataGrid({
    Key? key,
    required this.dataList,
    required this.controller}) : super(key: key);
    
  @override
  State<StatefulWidget> createState() => _AccountingDataGridState();  
}

class _AccountingDataGridState extends State<AccountingDataGrid> {
  late ThemeSettingModel _themeModel;

  late Color _foreGroundColor;

  late Map<String, double> columnWidths;

  @override
  void initState() {
    super.initState();

    columnWidths = {
      "dataType": 90,
      "clientName": 120,
      "date": 110,
      "steelWeight": 90,
      "supplyPrice": 120,
      "taxAmount": 120,
      "unitPrice": 100,
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
    var dataSource = AccountingDataSource(
      dataList: widget.dataList,
      foregroundColor: _foreGroundColor
    );
    return SfDataGridTheme(
      data: SfDataGridThemeData(),
      child: SfDataGrid(
        controller: widget.controller,
        source: dataSource,
        allowColumnsResizing: true,
        onColumnResizeUpdate: (details) {
          if (details.width <= 120) return false;
          setState(() {
            columnWidths[details.column.columnName] = details.width;
          });
          return true;
        },
        gridLinesVisibility: GridLinesVisibility.vertical,
        headerGridLinesVisibility: GridLinesVisibility.both,
        selectionMode: SelectionMode.single,
        columns: [
          gridColumnWidget("dataType", "매입/매출"),
          gridColumnWidget("clientName", "거래처"),
          gridColumnWidget("date", "날짜"),
          gridColumnWidget("steelWeight", "중량(t)"),
          gridColumnWidget("supplyPrice", "공급가"),
          gridColumnWidget("taxAmount", "세액"),
          gridColumnWidget("unitPrice", "단가"),   
          gridColumnWidget("depositDate", "입금확인"),
        ],
      ),
    );
  }

  void loadColors() {
    var themeType = _themeModel.getThemeType();

    _foreGroundColor = ColorManager.getForegroundColor(themeType);
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

  late List<DataGridRow> _dataList;

  static final _integerFormatter = NumberFormat("###,###,###,##0");

  @override
  List<DataGridRow> get rows => _dataList;
  
  AccountingDataSource({required List<AccountingData> dataList, this.foregroundColor = Colors.black}) {
    _dataList = dataList.map<DataGridRow>((e) => DataGridRow(
      cells: [
        DataGridCell<String>(columnName: "dataType", value: e.dataType ? "매입" : "매출"),
        DataGridCell<String>(columnName: "clientName", value: e.clientName),
        DataGridCell<String>(columnName: "date", value: DateFormat("yyyy-MM-dd").format(e.date)),
        DataGridCell<double>(columnName: "steelWeight", value: e.steelWeight),
        DataGridCell<String>(columnName: "supplyPrice", value: _integerFormatter.format(e.supplyPrice.toInt())),
        DataGridCell<String>(columnName: "taxAmount", value: _integerFormatter.format(e.taxAmount.toInt())),
        DataGridCell<String>(columnName: "unitPrice", value: _integerFormatter.format(e.unitPrice.toInt())),
        DataGridCell<String>(columnName: "depositDate", value: (!e.depositConfirmed || e.depositDate == null) ? "" : DateFormat("yyyy-MM-dd").format(e.depositDate!)),
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
    else if (columnName == "depositDate") {
      return Alignment.center;
    }
    else {
      return null;
    }
  }
}