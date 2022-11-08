import 'package:daewon_am/components/widgets/buttons/date_picker_button.dart';
import 'package:flutter/material.dart';

class SearchingDateButton extends StatelessWidget {
  final DateTime beginDate;
  final DateTime endDate;
  final void Function(DateTime? date) onChangedBeginDate;
  final void Function(DateTime? date) onChangedEndDate;
  final Color? color;
  const SearchingDateButton({
    Key? key,
    required this.beginDate,
    required this.endDate,
    required this.onChangedBeginDate,
    required this.onChangedEndDate,
    this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          DatePickerButton(
            initialDate: beginDate,
            lastDate: endDate,
            onChangedDate: onChangedBeginDate
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Text(
              "~",
              style: TextStyle(
                color: color
              ),
            ),
          ),
          DatePickerButton(
            initialDate: endDate,
            firstDate: beginDate,
            onChangedDate: onChangedEndDate
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}