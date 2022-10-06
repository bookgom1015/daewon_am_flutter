import 'package:daewon_am/components/helpers/color_manager.dart';
import 'package:daewon_am/components/globals/global_theme_settings.dart';
import 'package:daewon_am/components/models/page_control_model.dart';
import 'package:daewon_am/components/models/theme_setting_model.dart';
import 'package:daewon_am/components/widgets/buttons/mouse_reaction_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageNavButtons extends StatefulWidget {
  const PageNavButtons({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PageNavButtonsState();
}

class PageNavButton {  
  IconData icon;
  double iconSize;
  String tooltip;
  int index;

  PageNavButton(this.icon, this.iconSize, this.tooltip, this.index);
}

class _PageNavButtonsState extends State<PageNavButtons> {
  late ThemeSettingModel _themeModel;
  late PageControlModel _pageControlModel;

  late PageController _pageController;

  late Color _normal;
  late Color _mouseOver;
  late Color _foregroundColor;
  late Color _identityColor;

  int _selectedIndex = 0;
  late double _rightPad;

  final List<PageNavButton> _pageNavButtons = [
    PageNavButton(Icons.description_rounded, 18, "회계", 0),
    PageNavButton(Icons.manage_search, 20, "미수금", 1),
    PageNavButton(Icons.bar_chart, 24, "차트", 2),
  ];

  @override
  void initState() {
    super.initState();

    final even = _pageNavButtons.length % 2 == 0;
    final half = _pageNavButtons.length ~/ 2;
    if (even) {
      _rightPad = (half - 1) * 120.0;      
    }
    else {
      _rightPad = half * 80.0;
    }
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _themeModel = context.watch<ThemeSettingModel>();
    _pageControlModel = context.watch<PageControlModel>();

    _pageController = _pageControlModel.getPageController();

    loadColors();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _pageNavButtons.map((e) {
            return MouseReactionIconButton(
              onTap: () {
                setState(() {
                  _selectedIndex = e.index;
                });
                _pageController.animateToPage(
                  e.index, 
                  duration: pageTransitionDuration, 
                  curve: pageTransitionCurve,
                );
              },
              width: 30,
              height: 30,
              margin: const EdgeInsets.fromLTRB(5, 5, 5, 0),
              shape: BoxShape.circle,
              duration: colorChangeDuration,
              curve: colorChangeCurve,
              normal: _normal,
              mouseOver: _mouseOver,
              iconNormal: _foregroundColor,
              iconMouseOver: _foregroundColor,
              icon: e.icon,
              iconSize: e.iconSize,
              tooltip: e.tooltip,
            );
          }).toList(),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedContainer(
            duration: pageTransitionDuration,
            curve: pageTransitionCurve,
            width: 30,
            height: 2,
            margin: EdgeInsets.only(left: _selectedIndex * 80.0, right: _rightPad),
            decoration: BoxDecoration(
              color: _identityColor,
              borderRadius: BorderRadius.circular(2)
            ),            
          ),
        )
      ],
    );
  }

  void loadColors() {
    var themeType = _themeModel.getThemeType();

    _normal = ColorManager.getIdentityColor(themeType);
    _mouseOver = ColorManager.getIdentityMouseOverColor(themeType);
    _foregroundColor = ColorManager.getForegroundColor(themeType);
    _identityColor = ColorManager.getIdentityColor(themeType);    
  }
}