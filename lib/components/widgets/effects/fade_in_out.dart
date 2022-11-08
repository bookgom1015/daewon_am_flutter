
import 'package:flutter/material.dart';

class FadeInOut extends StatelessWidget {
  final bool horizontal;
  final double length;
  final Color fromColor;
  final Color toColor;

  const FadeInOut({
    Key? key,
    this.horizontal = false,
    this.length = 0,
    this.fromColor = Colors.transparent,
    this.toColor = Colors.transparent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}