import 'package:daewon_am/components/globals/global_theme_settings.dart';
import 'package:flutter/material.dart';

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
  final Color? tooltipBackground;
  final Color? tooltopForeground; 
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
    this.tooltipBackground,
    this.tooltopForeground,
    required this.onTap}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MouseReactionIconButtonState();

}

class _MouseReactionIconButtonState extends State<MouseReactionIconButton> {
  late Color? _color;
  late Color? _iconColor;
  bool _hovering = false;

  @override
  void initState() {
    super.initState();

    loadColors();
  }

  @override
  Widget build(BuildContext context) {
    loadColors();

    return MouseRegion(
      onEnter: (event) {
        setState(() {
          _color = widget.mouseOver;
          _iconColor = widget.iconMouseOver;
          _hovering = true;
        });
      },
      onExit: (event) {
        setState(() {
          _color = widget.normal;
          _iconColor = widget.iconNormal;
          _hovering = false;
        });
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: Tooltip(
          message: widget.tooltip,
          waitDuration: tooltipWaitDuration,
          decoration: BoxDecoration(
            color: widget.tooltipBackground,
          ),
          textStyle: TextStyle(
            color: widget.tooltopForeground,
          ),
          child: AnimatedContainer(
            duration: widget.duration,
            curve: widget.curve,
            width: widget.width,
            height: widget.height,
            margin: widget.margin,
            decoration: BoxDecoration(
              shape: widget.shape,
              borderRadius: widget.borderRadius,
              color: _color
            ),
            child: Icon(
              widget.icon,
              size: widget.iconSize,
              color: _iconColor,
            ),
          ),
        ),
      ),
    );
  }

  void loadColors() {
    _color = _hovering ? widget.mouseOver : widget.normal;    
    _iconColor = _hovering ? widget.iconMouseOver : widget.iconNormal;
  }
}