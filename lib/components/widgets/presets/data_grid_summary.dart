import 'package:daewon_am/components/entries/accounting_data.dart';
import 'package:daewon_am/components/helpers/color_manager.dart';
import 'package:daewon_am/components/helpers/format_manager.dart';
import 'package:daewon_am/components/models/theme_setting_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DataGridSummary extends StatefulWidget {
  final List<AccountingData> dataList;

  const DataGridSummary({
    Key? key,
    required this.dataList}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DataGridSummaryState();
}

class _DataGridSummaryState extends State<DataGridSummary> {
  late ThemeSettingModel _themeModel;

  late Color _foregroundColor;
  late TextStyle _textStyle;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _themeModel = context.watch<ThemeSettingModel>();

    loadColors();
  }

  @override
  Widget build(BuildContext context) {
    int incomeSum = 0;
    int outcomeSum = 0;
    for (final data in widget.dataList) {
      if (data.dataType) {
        incomeSum += data.supplyPrice + data.taxAmount;
      }
      else {
        outcomeSum += data.supplyPrice + data.taxAmount;
      }
    }
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "매입:",
            style: _textStyle,
          ),
          const SizedBox(width: 10),
          Text(
            FormatManager.thousandSeperator(incomeSum),
            style: _textStyle,
          ),
          const SizedBox(width: 40),
          Text(
            "매출:",
            style: _textStyle,
          ),
          const SizedBox(width: 10),
          Text(
            FormatManager.thousandSeperator(outcomeSum),
            style: _textStyle,
          ),
        ],
      )
    );
  }

  void loadColors() {
    final themeType = _themeModel.getThemeType();
    _foregroundColor = ColorManager.getForegroundColor(themeType);
    _textStyle = TextStyle(
      color: _foregroundColor
    );
  }
}