import 'package:daewon_am/components/globals/global_theme_settings.dart';
import 'package:flutter/material.dart';

class PreferenceNavBar extends StatefulWidget {
  final double width;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color underlineColor;
  final Color underlineBackgroundColor;
  final PageController controller;
  final List<String> titleList;

  const PreferenceNavBar({
    Key? key,
    this.width = 0,
    this.backgroundColor = Colors.transparent,
    this.foregroundColor = Colors.transparent,
    this.underlineColor = Colors.transparent,
    this.underlineBackgroundColor = Colors.transparent,
    required this.controller,
    required this.titleList}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PreferenceNavBarState();
}

class _PreferenceNavBarState extends State<PreferenceNavBar> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var padding = _selectedIndex * widget.width;

    return SizedBox(
      height: 50,
      child: Column(
        children: [
          // Nav bar
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.generate(
                widget.titleList.length, 
                (index) {
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onTap(index),
                      child: AnimatedContainer(
                        duration: colorChangeDuration,
                        curve: colorChangeCurve,
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        decoration: BoxDecoration(
                          color: widget.backgroundColor,
                        ),
                        child: Center(
                          child: Text(
                            widget.titleList[index],
                            style: TextStyle(
                              color: widget.foregroundColor,
                              fontSize: 16
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }
              ),
            )
          ),
          // Underline
          SizedBox(
            height: 2,
            child: Stack(
              children: [
                AnimatedContainer(
                  duration: colorChangeDuration,
                  curve: colorChangeCurve,
                  height: 2,
                  color: widget.underlineBackgroundColor,
                ),
                Row(
                  children: [
                    Flexible(
                      child: AnimatedContainer(
                        duration: colorChangeDuration,
                        curve: colorChangeCurve,
                        width: padding,
                      )
                    ),
                    SizedBox(
                      width: widget.width,
                      child: AnimatedContainer(
                        duration: colorChangeDuration,
                        curve: colorChangeCurve,
                        width: widget.width,
                        color: widget.underlineColor,
                      ),
                    )
                  ],
                )
              ],
            ),
          )          
        ],
      ),
    );
  }

  void onTap(int index) {
    widget.controller.animateToPage(
      index, 
      duration: pageTransitionDuration,
      curve: pageTransitionCurve,
    );

    _selectedIndex = index;
  }
}