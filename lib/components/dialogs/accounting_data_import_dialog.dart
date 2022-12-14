import 'package:daewon_am/components/dialogs/accounting_data_edit_dialog.dart';
import 'package:daewon_am/components/dialogs/ok_dialog.dart';
import 'package:daewon_am/components/entries/accounting_data.dart';
import 'package:daewon_am/components/helpers/color_manager.dart';
import 'package:daewon_am/components/models/theme_setting_model.dart';
import 'package:daewon_am/components/widgets/buttons/dialog_button.dart';
import 'package:daewon_am/components/widgets/data_grids/accounting_data_grid.dart';
import 'package:daewon_am/components/widgets/buttons/control_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class AccountingDataImportDialog extends StatefulWidget {
  final List<AccountingData> dataList;
  final void Function() onPressed;

  const AccountingDataImportDialog({
    Key? key,
    required this.dataList,
    required this.onPressed}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AccountingDataImportDialogState();
}

class _AccountingDataImportDialogState extends State<AccountingDataImportDialog> {
  late ThemeSettingModel _themeModel;

  late Color _layerBackgroundColor;
  late Color _widgetBackgroundColor;
  late Color _widgetBackgroundMouseOverColor;
  late Color _widgetForegroundColor;
  late Color _widgetForegroundMouseOverColor;
  late Color _normal;
  late Color _mouseOver;
  late Color _foregroundColor;

  final _controller = DataGridController();

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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: _layerBackgroundColor,
          borderRadius: BorderRadius.circular(8)
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              height: 50,
              child: Stack(
                children: [
                  Text(
                    "????????? ??????",
                    style: TextStyle(                    
                      color: _foregroundColor,
                      fontSize: 24,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ControlButton(
                        onTap: editAccountingData, 
                        normal: _widgetBackgroundColor, 
                        mouseOver: _widgetBackgroundMouseOverColor,
                        iconNormal: _widgetForegroundColor,
                        iconMouseOver: _widgetForegroundMouseOverColor,
                        icon: Icons.edit,
                        tooltip: "??????",
                      ),
                      ControlButton(
                        onTap: removeAccountingData, 
                        normal: _widgetBackgroundColor, 
                        mouseOver: _widgetBackgroundMouseOverColor,
                        iconNormal: _widgetForegroundColor,
                        iconMouseOver: _widgetForegroundMouseOverColor,
                        icon: Icons.delete,
                        tooltip: "??????",
                      )
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: AccountingDataGrid(
                controller: _controller,
                dataList: widget.dataList
              )
            ),
            Container(
              height: 50,
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  DialogButton(
                    onPressed: () {
                      widget.onPressed();
                      Navigator.of(context).pop();
                    },
                    label: "??????",
                    normal: _normal,
                    mouseOver: _mouseOver,                    
                    fontColor: _foregroundColor,
                  ),                  
                  const  SizedBox(width: 5),
                  DialogButton(
                    onPressed: () { Navigator.of(context).pop(); },
                    label: "??????",
                    normal: _normal,
                    mouseOver: _mouseOver,                    
                    fontColor: _foregroundColor,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void onThemeModelChanged() {
    var themeType = _themeModel.getThemeType();
    _layerBackgroundColor = ColorManager.getLayerBackgroundColor(themeType);
    _widgetBackgroundColor = ColorManager.getWidgetBackgroundColor(themeType);
    _widgetBackgroundMouseOverColor = ColorManager.getWidgetBackgroundMouseOverColor(themeType);
    _widgetForegroundColor = ColorManager.getWidgetIconForegroundColor(themeType);
    _widgetForegroundMouseOverColor = ColorManager.getWidgetIconForegroundMouseOverColor(themeType);
    _normal = ColorManager.getWidgetBackgroundColor(themeType);
    _mouseOver = ColorManager.getWidgetBackgroundMouseOverColor(themeType);
    _foregroundColor = ColorManager.getForegroundColor(themeType);
  }

  void editAccountingData() {
    final row = _controller.selectedRow;
    if (row == null) {
      showOkDialog(
        context: context, 
        themeModel: _themeModel,
        title: "??????",
        message: "????????? ???????????? ???????????????"                              
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
            int index = widget.dataList.indexOf(selectedData);
            setState(() {
              widget.dataList[index] = data;
            });
          },
        ),
      )
    );
  }

  void removeAccountingData() {
    final row = _controller.selectedRow;
    if (row == null) {
      showOkDialog(
        context: context, 
        themeModel: _themeModel,
        title: "??????",
        message: "????????? ???????????? ???????????????"                              
      );
      return;
    }
    final dataCell = row.getCells().firstWhere((element) => element.columnName == "data");
    final selectedData = dataCell.value as AccountingData;    
    int index = widget.dataList.indexOf(selectedData);
    setState(() {
      widget.dataList.removeAt(index);
    });
    //showOkCancelDialog(
    //  context: context, 
    //  themeModel: _themeModel, 
    //  title: "????????? ??????",
    //  message: "????????? ????????????????????????",
    //  onPressed: () {
    //    final dataCell = row.getCells().firstWhere((element) => element.columnName == "data");
    //    final selectedData = dataCell.value as AccountingData;    
    //    int index = widget.dataList.indexOf(selectedData);
    //    setState(() {
    //      widget.dataList.removeAt(index);
    //    });
    //  }
    //);
  }
}

void showImportingDialog({
  required BuildContext context,
  required ThemeSettingModel themeModel, 
  required List<AccountingData> dataList,
  required void Function() onPressed,
}) {
  showDialog(
    context: context, 
    barrierDismissible: false,
    builder: (_) => ChangeNotifierProvider.value(
      value: themeModel,
      child: AccountingDataImportDialog(
        dataList: dataList,
        onPressed: onPressed,
      ),
    )
  );
}