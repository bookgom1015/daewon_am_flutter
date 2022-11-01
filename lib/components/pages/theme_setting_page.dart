import 'package:daewon_am/components/helpers/color_manager.dart';
import 'package:daewon_am/components/globals/global_theme_settings.dart';
import 'package:daewon_am/components/helpers/setting_manager.dart';
import 'package:daewon_am/components/helpers/widget_helper.dart';
import 'package:daewon_am/components/models/theme_setting_model.dart';
import 'package:daewon_am/components/enums/theme_types.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeSettingPage extends StatefulWidget {
  const ThemeSettingPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ThemeSettingPageState();
}

class _ThemeSettingPageState extends State<ThemeSettingPage> with SingleTickerProviderStateMixin {
  late ThemeSettingModel _themeModel;

  late Color _backgroundColor;
  late Color _backgroundTransparentColor;

  late AnimationController _controller;
  late Animation<double> _curveAnimation;
  late Animation<double> _animation;

  bool _firstCall = true;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400)
    );
    _curveAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.ease
    );
    _animation = Tween<double>(
      begin: 0, 
      end: 1
    ).animate(_curveAnimation);
    _controller.forward();
  }

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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Column(
              children: [            
                themeBoxWidget(
                  EThemeTypes.eDark,
                  darkBackgroundColor, 
                  darkIdentityColor,
                  darkLayerBackgroundColor, 
                  darkWidgetBackgroundColor
                ),
                themeBoxWidget(
                  EThemeTypes.eLight,
                  lightBackgroundColor, 
                  lightIdentityColor, 
                  lightLayerBackgroundColor, 
                  lightWidgetBackgroundColor
                ),
                //themeBoxWidget(
                //  EThemeTypes.ePinkBlue,
                //  pinkBlueBackgroundColor, 
                //  pinkBlueIdentityColor, 
                //  pinkBlueLayerBackgroundColor, 
                //  pinkBlueWidgetBackgroundColor
                //),
              ],
            )
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: WidgetHelper.fadeOutWidget(
            length: 30,
            fromColor: _backgroundColor,
            toColor: _backgroundTransparentColor
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: WidgetHelper.fadeOutWidget(
            length: 30,
            fromColor: _backgroundTransparentColor,
            toColor: _backgroundColor
          ),
        ),
      ],
    );
  }

  void onThemeModelChanged() {
    var themeType = _themeModel.getThemeType();
    _backgroundColor = ColorManager.getPreferenceBackgroundColor(themeType);
    _backgroundTransparentColor = ColorManager.getPreferenceBackgroundTransparentColor(themeType);
  }

  void onPressed(EThemeTypes themeType) {
    if (_pressed || _themeModel.getThemeType() == themeType) return;
    _pressed = true;
    final finished = SettingManager.setThemeSetting(themeType);
    _themeModel.changeTheme(themeType);
    _controller.reset();
    _controller.forward();
    finished.then((value) {
      _pressed = false;
    });
  }

  Widget themeBoxWidget(EThemeTypes themeType, Color backgroundColor, Color identityColor, Color layerColor, Color widgetColor) {
    bool matched = _themeModel.getThemeType() == themeType;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => onPressed(themeType),
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return Container(              
                  margin: const EdgeInsets.all(26),
                  width: 264,
                  height: 264,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: identityColor,
                  ),
                  child: Visibility(
                    visible: matched,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 16 * _animation.value,
                            spreadRadius: 4 * _animation.value,
                            color: identityColor
                          )
                        ]
                      ),
                    ),
                  ),  
                );
              },
            ),   
            Container(
              margin: const EdgeInsets.all(30),
              width: 256,
              height: 256,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(8)
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: identityColor
                      ),
                    ),                    
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: layerColor
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          themeButtonWidget(widgetColor),
                          themeButtonWidget(widgetColor),
                          themeButtonWidget(widgetColor),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget themeButtonWidget(Color widgetColor) {
    return Container(
      margin: const EdgeInsets.only(left: 5, right: 5),
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: widgetColor
      ),
    );
  }
}