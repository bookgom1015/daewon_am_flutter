import 'package:flutter/material.dart';

class MouseReactionButton extends StatefulWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Duration duration;
  final Curve curve;
  final Color? normal;
  final Color? mouseOver;
  final Widget? child;
  final void Function() onTap;

  const MouseReactionButton({
    Key? key,
    this.width,
    this.height,
    this.borderRadius,
    this.duration = Duration.zero,
    this.curve = Curves.linear,
    this.normal,
    this.mouseOver,
    this. child,
    required this.onTap}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MouseReactionButtonState();

}

class _MouseReactionButtonState extends State<MouseReactionButton> {
  late Color? _color;

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
          _hovering = true;
        });
      },
      onExit: (event) {
        setState(() {
          _color = widget.normal;
          _hovering = false;
        });
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: widget.duration,
          curve: widget.curve,
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            color: _color
          ),
          child: widget.child,
        ),
      ),
    );
  }

  void loadColors() {
    _color = _hovering ? widget.mouseOver : widget.normal;
  }
}