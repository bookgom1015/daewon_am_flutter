import 'package:daewon_am/components/helpers/theme/color_manager.dart';
import 'package:daewon_am/components/globals/global_theme_settings.dart';
import 'package:daewon_am/components/models/page_control_model.dart';
import 'package:daewon_am/components/models/theme_setting_model.dart';
import 'package:daewon_am/components/models/user_info_model.dart';
import 'package:daewon_am/components/widgets/buttons/mouse_reaction_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageNavButtons extends StatefulWidget {
  const PageNavButtons({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PageNavButtonsState();
}

class _PageNavButtonsState extends State<PageNavButtons> {
  late ThemeSettingModel _themeModel;
  late PageControlModel _pageControlModel;

  late PageController _pageController;

  late Color _normal;
  late Color _mouseOver;
  late Color _iconNormal;
  late Color _iconMouseOver;

  //late List<Widget> _pageNavButtons;
  
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        pageNavButtonWidget(
          icon: Icons.description_rounded, 
          iconSize: 18,
          tooltip: "회계",
          index: 0
        ),
        pageNavButtonWidget(
          icon: Icons.manage_search, 
          iconSize: 20, 
          tooltip: "미수금",
          index: 1
        ),
        pageNavButtonWidget(
          icon: Icons.bar_chart,
          iconSize: 24, 
          tooltip: "차트",
          index: 2
        ),
      ],
    );
  }

  Widget pageNavButtonWidget({required IconData icon, double? iconSize, String tooltip = "", required int index}) {
    return MouseReactionIconButton(
      onTap: () {
        _pageController.animateToPage(
          index, 
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
      iconNormal: _iconNormal,
      iconMouseOver: _iconMouseOver,
      icon: icon,
      iconSize: iconSize,
      tooltip: tooltip,
    );
  }

  void loadColors() {
    var themeType = _themeModel.getThemeType();

    _normal = ColorManager.getIdentityColor(themeType);
    _mouseOver = ColorManager.getIdentityMouseOverColor(themeType);
    _iconNormal = ColorManager.getForegroundColor(themeType);
    _iconMouseOver = ColorManager.getForegroundColor(themeType);
  }
}