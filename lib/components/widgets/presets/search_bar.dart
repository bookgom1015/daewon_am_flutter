import 'package:daewon_am/components/widgets/buttons/mouse_reaction_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Color? foregroundColor;
  final Color? cursorColor;
  final Color underlineColor;
  final Color underlineFocusedColor;
  final Color? iconNormal;
  final Color? iconMouseOver;
  final void Function() onTap;

  const SearchBar({
    Key? key,
    required this.controller,
    this.foregroundColor,
    this.cursorColor,
    this.underlineColor = Colors.transparent,
    this.underlineFocusedColor = Colors.transparent,
    this.iconNormal,
    this.iconMouseOver,
    required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
        child: RawKeyboardListener(
          focusNode: FocusNode(),
          onKey: (e) {
            if (e.runtimeType == RawKeyDownEvent && e.logicalKey.keyId == LogicalKeyboardKey.enter.keyId) {
              onTap();
            }
          },
          child: TextFormField(
            controller: controller,
            maxLength: 32,
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
              ),
              counterText: "",
            ),
          ),
        ),
      ),
    );
  }
}