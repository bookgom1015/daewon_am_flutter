import 'package:daewon_am/components/globals/global_theme_settings.dart';
import 'package:daewon_am/components/widgets/buttons/mouse_reaction_icon_button.dart';
import 'package:flutter/material.dart';

class ControlButton extends StatelessWidget {
  final Color? normal;
  final Color? mouseOver;
  final Color? iconNormal;
  final Color? iconMouseOver;
  final void Function() onTap;
  final IconData icon;
  final String tooltip;
  const ControlButton({
    Key? key,
    this.normal,
    this.mouseOver,
    this.iconNormal,
    this.iconMouseOver,
    required this.onTap,
    required this.icon,
    this.tooltip = ""}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseReactionIconButton(
      onTap: onTap,
      width: 32,
      height: 32,
      borderRadius: BorderRadius.circular(8),
      margin: const EdgeInsets.only(top: 2, right: 10),
      duration: colorChangeDuration,
      curve: colorChangeCurve,
      normal: normal,
      mouseOver: mouseOver,
      iconNormal: iconNormal,
      iconMouseOver: iconMouseOver,
      icon: icon,
      iconSize: 24,
      tooltip: tooltip,
    );
  }
}