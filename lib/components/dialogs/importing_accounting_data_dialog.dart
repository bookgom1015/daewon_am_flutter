import 'package:daewon_am/components/dialogs/accounting_data_edit_dialog.dart';
import 'package:daewon_am/components/dialogs/ok_cancel_dialog.dart';
import 'package:daewon_am/components/dialogs/ok_dialog.dart';
import 'package:daewon_am/components/entries/accounting_data.dart';
import 'package:daewon_am/components/helpers/color_manager.dart';
import 'package:daewon_am/components/helpers/widget_helper.dart';
import 'package:daewon_am/components/models/theme_setting_model.dart';
import 'package:daewon_am/components/widgets/presets/accounting_data_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ImportingAccountingDataDialog extends StatefulWidget {
  final List<AccountingData> dataList;
  final void Function() onPressed;

  const ImportingAccountingDataDialog({
    Key? key,
    required this.dataList,
    required this.onPressed}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ImportingAccountingDataDialogState();
}

class _ImportingAccountingDataDialogState extends State<ImportingAccountingDataDialog> {
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _themeModel = context.watch<ThemeSettingModel>();

    loadColors();
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
                    "데이터 입력",
                    style: TextStyle(                    
                      color: _foregroundColor,
                      fontSize: 24,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      WidgetHelper.controlButtonWidget(
                        onTap: editAccountingData, 
                        normal: _widgetBackgroundColor, 
                        mouseOver: _widgetBackgroundMouseOverColor,
                        iconNormal: _widgetForegroundColor,
                        iconMouseOver: _widgetForegroundMouseOverColor,
                        icon: Icons.edit,
                        tooltip: "수정",
                      ),
                      WidgetHelper.controlButtonWidget(
                        onTap: removeAccountingData, 
                        normal: _widgetBackgroundColor, 
                        mouseOver: _widgetBackgroundMouseOverColor,
                        iconNormal: _widgetForegroundColor,
                        iconMouseOver: _widgetForegroundMouseOverColor,
                        icon: Icons.delete,
                        tooltip: "삭제",
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
                  WidgetHelper.dialogButton(
                    onPressed: () {
                      widget.onPressed();
                      Navigator.of(context).pop();
                    },
                    label: "입력",
                    normal: _normal,
                    mouseOver: _mouseOver,                    
                    fontColor: _foregroundColor,
                  ),                  
                  const  SizedBox(width: 5),
                  WidgetHelper.dialogButton(
                    onPressed: () { Navigator.of(context).pop(); },
                    label: "취소",
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

  void loadColors() {
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
        title: "알림",
        message: "삭제할 데이터를 선택하세요"                              
      );
      return;
    }

    showOkCancelDialog(
      context: context, 
      themeModel: _themeModel, 
      title: "데이터 삭제",
      message: "정말로 삭제하시겠습니까",
      onPressed: () {
        final dataCell = row.getCells().firstWhere((element) => element.columnName == "data");
        final selectedData = dataCell.value as AccountingData;
    
        int index = widget.dataList.indexOf(selectedData);
        setState(() {
          widget.dataList.removeAt(index);
        });
      }
    );
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
      child: ImportingAccountingDataDialog(
        dataList: dataList,
        onPressed: onPressed,
      ),
    )
  );
}