import 'package:daewon_am/components/color_manager.dart';
import 'package:daewon_am/components/globals/global_theme_settings.dart';
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

  late AnimationController _controller;
  late Animation<double> _curveAnimation;
  late Animation<double> _animation;

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
    _themeModel = context.watch<ThemeSettingModel>();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
          ],
        )
      ),
    );
  }

  Widget themeBoxWidget(EThemeTypes themeType, Color backgroundColor, Color identityColor, Color layerColor, Color widgetColor) {
    Widget themeButton = Container(
      margin: const EdgeInsets.only(left: 5, right: 5),
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: widgetColor
      ),
    );

    bool matched = _themeModel.getThemeType() == themeType;

    return MouseRegion(
      onEnter: (event) {

      },
      onExit: (event) {

      },
      child: GestureDetector(
        onTap: () {
          _themeModel.changeTheme(themeType);
          _controller.reset();
          _controller.forward();
        },
        child: Stack(
          children: [        
            Visibility(
              visible: matched,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  return Container(              
                    margin: const EdgeInsets.all(25),
                    width: 266,
                    height: 266,
                    decoration: BoxDecoration(
                      color: identityColor,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 16 * _animation.value,
                          spreadRadius: 4 * _animation.value,
                          color: identityColor
                        )
                      ]
                    ),  
                  );
                },
              ),
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
                          themeButton,
                          themeButton,
                          themeButton,
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
}