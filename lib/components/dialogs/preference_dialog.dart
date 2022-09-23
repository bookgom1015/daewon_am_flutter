import 'package:daewon_am/components/helpers/theme/color_manager.dart';
import 'package:daewon_am/components/models/user_info_model.dart';
import 'package:daewon_am/components/pages/my_page.dart';
import 'package:daewon_am/components/widgets/buttons/mouse_reaction_icon_button.dart';
import 'package:daewon_am/components/widgets/naviation_bars/preference_nav_bar.dart';
import 'package:daewon_am/components/pages/theme_setting_page.dart';
import 'package:daewon_am/components/globals/global_theme_settings.dart';
import 'package:daewon_am/components/helpers.dart';
import 'package:daewon_am/components/models/theme_setting_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PreferenceDialog extends StatefulWidget {
  const PreferenceDialog({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PreferenceDialogState();  
}

class _PreferenceDialogState extends State<PreferenceDialog> {
  late ThemeSettingModel _themeModel;
  late UserInfoModel _userInfoModel;

  late Color _backgroundColor;
  late Color _identityColor;
  late Color _preferenceBackgroundColor;
  late Color _underlineBackgroundColor;

  late Color _normal;
  late Color _mouseOver;
  late Color _iconNormal;
  late Color _iconMouseOver;

  late Color _color;
  late Color _iconColor;

  bool _hovering = false;

  late PageController _pageController;

  final GlobalKey _dialogKey = GlobalKey();
  double _navWidth = 0;

  late List<Widget> _pageList;
  late List<String> _titleList;

  final double _titleBarHeight = 50;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _pageList = [
      const ThemeSettingPage(),
    ];

    _titleList = [
      "테마",
    ];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _themeModel = context.watch<ThemeSettingModel>();
    _userInfoModel = context.watch<UserInfoModel>();

    if (_userInfoModel.getLoggedIn() && !_titleList.contains("계정")) {
      _pageList.add(const MyPage());
      _titleList.add("계정");
    }
    else if (!_userInfoModel.getLoggedIn() && _titleList.contains("계정")) {
      _pageList.remove(const MyPage());
      _titleList.remove("계정");
    }

    loadColors();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: NotificationListener(
        onNotification: (notification) {
          setState(() {
            _navWidth = getSize(_dialogKey).width / _pageList.length;
          });
          return true;
        },
        child: Container(
          key: _dialogKey,
          constraints: const BoxConstraints(
            maxWidth: 1024,
            maxHeight: 720,
          ),
          child: Column(
            children: [
              titleBarWidget(),
              settingPagesWidget(context)
            ],
          ),
        ),
      ),
    );    
  }

  void loadColors() {
    var themeType = _themeModel.getThemeType();

    _backgroundColor = ColorManager.getBackgroundColor(themeType);
    _identityColor = ColorManager.getIdentityColor(themeType);
    _preferenceBackgroundColor = ColorManager.getPreferenceBackgroundColor(themeType);
    _underlineBackgroundColor = ColorManager.getPreferenceUnderlineBakcgroundColor(themeType);

    _normal = ColorManager.getBackgroundColor(themeType);
    _mouseOver = ColorManager.getTitleBarCloseButtonMouseOverBackgroundColor(themeType);
    _iconNormal = ColorManager.getTitleBarButtonIconColor(themeType);
    _iconMouseOver = ColorManager.getTitleBarButtonIconMouseOverColor(themeType);

    _color = _hovering ? _mouseOver : _normal;
    _iconColor = _hovering ? _iconMouseOver : _iconNormal;
  }

  Widget titleBarWidget() {    
    return AnimatedContainer(
      duration: colorChangeDuration,
      curve: colorChangeCurve,
      height: _titleBarHeight,
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8))
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,            
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                "설정",
                style: TextStyle(
                  color: _iconMouseOver,
                  fontSize: 24
                ),
              ),
            ),            
          ),
          Align(
            alignment: Alignment.topRight,
            child: MouseRegion(
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
              child: MouseReactionIconButton(
                onTap: () {
                  Navigator.of(context).pop();
                },
                width: 40,
                height: 30,
                borderRadius: const BorderRadius.only(topRight: Radius.circular(8)),
                duration: colorChangeDuration,
                curve: colorChangeCurve,
                normal: _normal,
                mouseOver: _mouseOver,
                iconNormal: _iconNormal,
                iconMouseOver: _iconMouseOver,
                icon: Icons.close,
                iconSize: 20,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget settingPagesWidget(BuildContext dialogContext) {
    return Expanded(
      child: AnimatedContainer(
        duration: colorChangeDuration,
        curve: colorChangeCurve,
        decoration: BoxDecoration(
          color: _preferenceBackgroundColor,
          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8))
        ),
        child: DefaultTabController(
          length: _pageList.length,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            extendBody: true,
            bottomNavigationBar: Align(              
              alignment: Alignment.topCenter,
              child: PreferenceNavBar(
                controller: _pageController,
                titleList: _titleList,
                backgroundColor: _preferenceBackgroundColor,
                foregroundColor: _iconMouseOver,
                underlineColor: _identityColor,
                underlineBackgroundColor: _underlineBackgroundColor,
                width: _navWidth,
              ),
            ),
            body: Padding(
              padding: EdgeInsets.only(top: _titleBarHeight),
              child: PageView.builder(
                controller: _pageController,   
                itemCount: _pageList.length,
                itemBuilder: (_, index) {
                  return _pageList[index];
                },
              )
            )
          ),
        ),
      )
    );
  }
}