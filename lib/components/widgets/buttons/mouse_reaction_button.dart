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
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
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
            duration: widget.duration,
            curve: widget.curve,
            color: _hovering ? widget.mouseOver : widget.normal,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}