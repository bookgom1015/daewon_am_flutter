
import 'package:daewon_am/components/globals/global_theme_settings.dart';
import 'package:daewon_am/components/widgets/buttons/mouse_reaction_button.dart';
import 'package:daewon_am/components/widgets/buttons/mouse_reaction_icon_button.dart';
import 'package:daewon_am/components/widgets/date_pickers/simple_date_picker.dart';
import 'package:flutter/material.dart';

class WidgetHelper {
  static Widget fadeOutWidget({
    double length = 0, 
    Color fromColor = Colors.transparent, 
    Color toColor = Colors.transparent, 
    bool horizontal = false
  }) {
    return Container(
      width: horizontal ? length : null,
      height: horizontal ? null : length,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: horizontal ? Alignment.centerLeft : Alignment.topCenter,
          end: horizontal ? Alignment.centerRight : Alignment.bottomCenter,
          colors: [
            fromColor,
            toColor,
          ]
        )
      )
    );
  }

  static Widget searchBarWidget({
    required TextEditingController textEditingController,
    Color? foregroundColor,
    Color? cursorColor,
    Color underlineColor = Colors.transparent,
    Color underlineFocusedColor = Colors.transparent,
    Color? iconNormal,
    Color? iconMouseOver,
    required void Function() onTap,
  }) {
    return Container(
      height: 50,
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
        child: TextFormField(
          controller: textEditingController,
          style: TextStyle(
            color: foregroundColor
          ),
          cursorColor: cursorColor,
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: underlineColor)
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: underlineFocusedColor)
            ),
            suffixIcon: MouseReactionIconButton(
              onTap: onTap,
              iconNormal: iconNormal,
              iconMouseOver: iconMouseOver,
              icon: Icons.search,
            )
          ),
        ),
      ),
    );
  }

  static Widget controlButtonWidget({
    Color? normal,
    Color? mouseOver,
    Color? iconNormal,
    Color? iconMouseOver,
    required void Function() onTap, 
    required IconData icon,
    String tooltip = "",
  }) {
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

  static Widget searchingDateWidget({
    required DateTime beginDate,
    required DateTime endDate,
    required void Function(DateTime? date) onChangedBeginDate,
    required void Function(DateTime? date) onChangedEndDate,
    Color? color,
  }) {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SimpleDatePicker(
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
          SimpleDatePicker(
            initialDate: endDate,
            firstDate: beginDate,
            onChangedDate: onChangedEndDate
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  static Widget dialogButton({
    String label = "",
    Color? normal,
    Color? mouseOver,
    Color? fontColor,
    required void Function() onPressed,
  }) {
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

  static Widget checkBoxWidget({
    required void Function(bool?) onChanged, 
    required bool value,
    Color borderColor = Colors.blue,
    Color? activeColor,
    Color? checkColor,
  }) {
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