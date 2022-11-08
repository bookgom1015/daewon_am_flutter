import 'package:daewon_am/components/globals/global_theme_settings.dart';
import 'package:daewon_am/components/helpers/color_manager.dart';
import 'package:daewon_am/components/models/theme_setting_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MouseReactionIconButton extends StatefulWidget {
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final BoxShape shape;
  final Duration duration;
  final Curve curve;
  final Color? normal;
  final Color? mouseOver;
  final Color? iconNormal;
  final Color? iconMouseOver;
  final IconData? icon;
  final double? iconSize;
  final String tooltip;
  final void Function() onTap;

  const MouseReactionIconButton({
    Key? key,
    this.width,
    this.height,
    this.margin,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
    this.duration = Duration.zero,
    this.curve = Curves.linear,
    this.normal,
    this.mouseOver,
    this.iconNormal,
    this.iconMouseOver,
    this.icon,
    this.iconSize,
    this.tooltip = "",
    required this.onTap}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MouseReactionIconButtonState();

}

class _MouseReactionIconButtonState extends State<MouseReactionIconButton> {
  late ThemeSettingModel _themeModel;

  late Color _tooltipBackgroundColor;
  late Color _tooltipForegroundColor;

  bool _hovering = false;
  bool _firstCall = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_firstCall) {
      _firstCall = false;
      _themeModel = context.watch<ThemeSettingModel>();
      _themeModel.addListener(onThemeModelChanged);
      onThemeModelChanged();
    }
  }

  @override
  void dispose() {
    _themeModel.removeListener(onThemeModelChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      margin: widget.margin,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        shape: widget.shape,
        borderRadius: widget.borderRadius,
      ),
      child: MouseRegion(
        onEnter: (event) {
          setState(() {
            _hovering = true;
          });
        },
        onExit: (event) {
          setState(() {
            _hovering = false;
          });
        },
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: colorChangeDuration,
            curve: colorChangeCurve,
            color: _hovering ? widget.mouseOver : widget.normal,
            child: Tooltip(
              message: widget.tooltip,
              waitDuration: tooltipWaitDuration,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: _tooltipBackgroundColor,
              ),
              textStyle: TextStyle(
                color: _tooltipForegroundColor,
              ),
              child: Icon(
                widget.icon,
                size: widget.iconSize,
                color: _hovering ? widget.iconMouseOver : widget.iconNormal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onThemeModelChanged() {
    final themeType = _themeModel.getThemeType();
    _tooltipBackgroundColor = ColorManager.getTooltipBackgroundColor(themeType);
    _tooltipForegroundColor = ColorManager.getTooltipForegroundColor(themeType);
  }
}