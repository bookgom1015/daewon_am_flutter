import 'package:daewon_am/components/entries/data_column.dart';
import 'package:daewon_am/components/entries/user.dart';
import 'package:daewon_am/components/enums/privileges.dart';
import 'package:daewon_am/components/helpers/color_manager.dart';
import 'package:daewon_am/components/helpers/widget_helper.dart';
import 'package:daewon_am/components/models/theme_setting_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:collection/collection.dart';

class UserDataGrid extends StatefulWidget {
  final List<User> userList;
  final DataGridController controller;

  const UserDataGrid({
    Key? key,
    required this.userList,
    required this.controller}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UserDataGridState();
}

class _UserDataGridState extends State<UserDataGrid> {
  late ThemeSettingModel _themeModel;

  late Color _layerBackgroundColor;
  late Color _layerBackgroundTransparentColor;
  late Color _foregroundColor;
  late Color _gridLineColor;
  late Color _dataGridRowHoverColor;
  late Color _dataGridSelectionColor;

  final double _userIdMinWidth = 150;
  final double _privMinWidth = 150;

  late List<DataGridColumn> _dataColumnList; 

  String _sortedColumn = "date";
  DataGridSortDirection _sortDirection = DataGridSortDirection.ascending;

  @override
  void initState() {
    super.initState();

    _dataColumnList = [
      DataGridColumn("user", "", 0, false),
      DataGridColumn("userId", "아이디", _userIdMinWidth, true),
      DataGridColumn("priv", "권한", _privMinWidth, true),
      DataGridColumn("blank", "비고", double.nan, false),
    ];
  }

  @override  
  void didChangeDependencies() {
    super.didChangeDependencies();
    _themeModel = context.watch<ThemeSettingModel>();

    loadColors();
  }

  @override
  Widget build(BuildContext context) {
    final dataSource = UserDataSource(
      userList: widget.userList,
      foregroundColor: _foregroundColor,
    );
    dataSource.sortedColumns.add(SortColumnDetails(
      name: _sortedColumn, 
      sortDirection: _sortDirection
    ));
    dataSource.sort();
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
                var column = dataSource.sortedColumns
                    .where((element) => element.name == columnName)
                    .firstOrNull;
                if (column != null) {
                  if (column.sortDirection == DataGridSortDirection.ascending) {
                    icon = Icon(Icons.arrow_upward, size: 16, color: _foregroundColor);
                  } 
                  else if (column.sortDirection == DataGridSortDirection.descending) {
                    icon = Icon(Icons.arrow_downward, size: 16, color: _foregroundColor);
                  }
                }
                return icon ?? const SizedBox();
              },
            ),
          ),
          child: SfDataGrid(
            controller: widget.controller,
            source: dataSource,
            allowColumnsResizing: true,
            allowSorting: true,
            columnWidthMode: ColumnWidthMode.lastColumnFill,
            onColumnResizeUpdate: (details) => reduceColumnWidth(details.column.columnName, details.width),
            gridLinesVisibility: GridLinesVisibility.vertical,
            headerGridLinesVisibility: GridLinesVisibility.vertical,
            selectionMode: SelectionMode.single,
            onCellTap: (details) {
              if (details.rowColumnIndex.rowIndex == 0) {
                bool same = _sortedColumn == details.column.columnName;
                if (same) {
                  _sortDirection = _sortDirection == DataGridSortDirection.ascending ? 
                    DataGridSortDirection.descending : DataGridSortDirection.ascending;
                }
                else {
                  _sortDirection = DataGridSortDirection.ascending;
                }
                _sortedColumn = details.column.columnName;
              }
            },
            columns: _dataColumnList.map((e) {
              return WidgetHelper.gridColumnWidget(
                columnName: e.columnName, 
                label: e.label, 
                color: _foregroundColor,
                width: e.width,
                allowSorting: e.allowSorting
              );
            }).toList(),
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
    _foregroundColor = ColorManager.getForegroundColor(themeType);
    _gridLineColor = ColorManager.getDataGridLineColor(themeType);
    _dataGridRowHoverColor = ColorManager.getDataGridRowHoverColor(themeType);
    _dataGridSelectionColor = ColorManager.getDataGridSelectionColor(themeType);
  }

  bool reduceColumnWidth(String columnName, double width) {
    switch (columnName) {
      case "userId":
      if (width <= _userIdMinWidth) return false;
      break;
      case "priv": 
      if (width <= _privMinWidth) return false;
      break;
      default:
      return true;
    }
    final entry = _dataColumnList.where((element) => element.columnName == columnName).singleOrNull;
    if (entry != null) {
      setState(() {
        entry.width = width;
      });
    }
    return true;
  }
}

class UserDataSource extends DataGridSource {
  late List<DataGridRow> _userList;
  final Color foregroundColor;

  @override
  List<DataGridRow> get rows => _userList;

  UserDataSource({
    required List<User> userList,
    this.foregroundColor = Colors.black,
  }) {
    _userList = userList.map<DataGridRow>((e) => DataGridRow(
      cells: [
        DataGridCell<User>(columnName: "user", value: e),
        DataGridCell<String>(columnName: "userId", value: e.userId),
        DataGridCell<String>(columnName: "priv", value: e.priv.text),
        const DataGridCell<String>(columnName: "blank", value: ""),
      ]
    )).toList();
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((e) {
        return Container(
          alignment: Alignment.centerLeft,
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

  @override
  int compare(DataGridRow? a, DataGridRow? b, SortColumnDetails sortColumn) {
    String? value1 = a?.getCells().firstWhereOrNull((element) => element.columnName == sortColumn.name)?.value.toString();
    String? value2 = b?.getCells().firstWhereOrNull((element) => element.columnName == sortColumn.name)?.value.toString();
    bool ascen = sortColumn.sortDirection == DataGridSortDirection.ascending;
    if (value1 == null || value2 == null) return 0;
    try {
      switch (sortColumn.name) {
        case "userId":
        String userId1 = value1;
        String userId2 = value2;
        if (ascen) {
          return userId1.compareTo(userId2);
        }
        else {
          return userId2.compareTo(userId1);
        }
        case "priv":
        int priv1 = textToPriv(value1).id;
        int priv2 = textToPriv(value2).id;
        if (priv1 < priv2) {
          return ascen ? -1 : 1;
        }
        else if (priv1 > priv2) {
          return ascen ? 1 : -1;
        }
        else {
          return 0;
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