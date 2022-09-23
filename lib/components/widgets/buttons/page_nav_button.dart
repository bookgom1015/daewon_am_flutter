import 'package:daewon_am/components/helpers/theme/color_manager.dart';
import 'package:daewon_am/components/globals/global_theme_settings.dart';
import 'package:daewon_am/components/models/theme_setting_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageNavButton extends StatefulWidget {
  final IconData icon;
  final double? iconSize;
  final String? tooltip;
  final void Function()? onTap;

  const PageNavButton({
    Key? key, 
    required this.icon,
    this.iconSize,
    this.tooltip,
    this.onTap}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PageNavButtonState();
}

class _PageNavButtonState extends State<PageNavButton> {
  late ThemeSettingModel _themeModel;

  late Color _normal;
  late Color _mouseOver;
  late Color _iconNormal;
  late Color _iconMouseOver;

  late Color _tooltipBackgroundColor;
  late Color _tooltipForegroundColor;

  late Color _color;
  late Color _iconColor;

  bool _hovering = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _themeModel = context.watch<ThemeSettingModel>();

    loadColors();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(    
      onEnter: (event) {
        setState(() {
          _color = _mouseOver;
          _iconColor = _iconMouseOver;
          _hovering = true;
        });
      },
      onExit: (event) {
        setState(() {
          _color = _normal;
          _iconColor = _iconNormal;
          _hovering = false;
        });
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: Tooltip(
          message: widget.tooltip,
          waitDuration: const Duration(milliseconds: 800),          
          textStyle: TextStyle(
            color: _tooltipForegroundColor,
            backgroundColor: _tooltipBackgroundColor
          ),          
          child: AnimatedContainer(
            duration: colorChangeDuration,
            curve: colorChangeCurve,
            decoration: BoxDecoration(
              color: _color,
              shape: BoxShape.circle
            ),
            margin: const EdgeInsets.fromLTRB(5, 5, 5, 0),
            width: 30,
            height: 30,
            child: Icon(
              widget.icon,
              color: _iconColor,
              size: widget.iconSize,
            ),
          ),
        ),
      ),
    );
  }

  void loadColors() {
    var themeType = _themeModel.getThemeType();

    _normal = ColorManager.getIdentityColor(themeType);
    _mouseOver = ColorManager.getIdentityMouseOverColor(themeType);
    _iconNormal = ColorManager.getForegroundColor(themeType);
    _iconMouseOver = ColorManager.getForegroundColor(themeType);
    
    _tooltipBackgroundColor = ColorManager.getTooltipBackgroundColor(themeType);
    _tooltipForegroundColor = ColorManager.getTooltipForegroundColor(themeType);

    _color = _hovering ? _mouseOver : _normal;
    _iconColor = _hovering ? _iconMouseOver : _iconNormal;
  }  
}