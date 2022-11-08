
import 'package:daewon_am/components/dialogs/ok_dialog.dart';
import 'package:daewon_am/components/entries/accounting_data.dart';
import 'package:daewon_am/components/helpers/color_manager.dart';
import 'package:daewon_am/components/models/theme_setting_model.dart';
import 'package:daewon_am/components/widgets/buttons/dialog_button.dart';
import 'package:daewon_am/components/widgets/data_grids/accounting_data_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class AccountingDataRemoveDialog extends StatefulWidget {
  final List<AccountingData> dataList;
  final void Function(List<AccountingData> dataList) onPressed;

  const AccountingDataRemoveDialog({
    Key? key,
    required this.dataList,
    required this.onPressed}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AccountingDataRemoveDialogState();
}

class _AccountingDataRemoveDialogState extends State<AccountingDataRemoveDialog> {
  late ThemeSettingModel _themeModel;

  late Color _layerBackgroundColor;
  late Color _normal;
  late Color _mouseOver;
  late Color _foregroundColor;

  final _controller = DataGridController(); 

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _themeModel = context.watch<ThemeSettingModel>();
    _themeModel.addListener(onThemeModelChanged);
    onThemeModelChanged();
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
                    "데이터 삭제",
                    style: TextStyle(                    
                      color: _foregroundColor,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: AccountingDataGrid(
                controller: _controller,
                dataList: widget.dataList,
                multiSelection: true,
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
                      if (_controller.selectedRows.isEmpty) {
                        showOkDialog(
                          context: context, 
                          themeModel: _themeModel,
                          title: "알림",
                          message: "삭제할 데이터를 선택하세요"                              
                        );
                        return;
                      }
                      List<AccountingData> dataList = [];
                      for (final row in _controller.selectedRows) {
                        final dataCell = row.getCells().firstWhere((element) => element.columnName == "data");
                        final selectedData = dataCell.value as AccountingData;
                        dataList.add(selectedData);
                      }
                      widget.onPressed(dataList);
                      Navigator.of(context).pop();
                    },
                    label: "삭제",
                    normal: _normal,
                    mouseOver: _mouseOver,                    
                    fontColor: _foregroundColor,
                  ),                  
                  const  SizedBox(width: 5),
                  DialogButton(
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

  void onThemeModelChanged() {
    var themeType = _themeModel.getThemeType();
    _layerBackgroundColor = ColorManager.getLayerBackgroundColor(themeType);
    _normal = ColorManager.getWidgetBackgroundColor(themeType);
    _mouseOver = ColorManager.getWidgetBackgroundMouseOverColor(themeType);
    _foregroundColor = ColorManager.getForegroundColor(themeType);
  }
}

void showRemoveDialog({
  required BuildContext context,
  required ThemeSettingModel themeModel, 
  required List<AccountingData> dataList,
  required void Function(List<AccountingData> dataList) onPressed,
}) {
  showDialog(
    context: context, 
    barrierDismissible: false,
    builder: (_) => ChangeNotifierProvider.value(
      value: themeModel,
      child: AccountingDataRemoveDialog(
        dataList: dataList,
        onPressed: onPressed,
      ),
    )
  );
}