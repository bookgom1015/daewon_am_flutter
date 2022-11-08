import 'package:flutter/material.dart';

class ResponsiveCheckBox extends StatelessWidget {
  final void Function(bool?) onChanged;
  final bool value;
  final Color borderColor;
  final Color? activeColor;
  final Color? checkColor;
  const ResponsiveCheckBox({
    Key? key,
    required this.onChanged,
    this.value = false,
    required this.borderColor,
    this.activeColor,
    this.checkColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      onChanged: onChanged,
      value: value,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4)
      ),
      side: BorderSide(
        color: borderColor,
        width: 2
      ),
      activeColor: activeColor,
      checkColor: checkColor,
      splashRadius: 0,
    );
  }
}