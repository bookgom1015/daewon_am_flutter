import 'package:daewon_am/components/globals/global_theme_settings.dart';
import 'package:daewon_am/components/widgets/buttons/mouse_reaction_button.dart';
import 'package:flutter/material.dart';

class DialogButton extends StatelessWidget {
  final String label;
  final Color? normal;
  final Color? mouseOver;
  final Color? fontColor;
  final void Function() onPressed;
  const DialogButton({
    Key? key,
    this.label = "",
    this.normal,
    this.mouseOver,
    this.fontColor,
    required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseReactionButton(
      onTap: onPressed,
      width: 100,
      height: 36,
      borderRadius: BorderRadius.circular(8),
      duration: colorChangeDuration,
      curve: colorChangeCurve,
      normal: normal,
      mouseOver: mouseOver,
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: fontColor
          ),
        ),
      ),      
    );
  }
}