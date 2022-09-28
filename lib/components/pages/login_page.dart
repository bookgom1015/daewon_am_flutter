import 'dart:convert';

import 'package:daewon_am/components/helpers/theme/color_manager.dart';
import 'package:daewon_am/components/dialogs/ok_dialog.dart';
import 'package:daewon_am/components/globals/global_routes.dart';
import 'package:daewon_am/components/globals/global_theme_settings.dart';
import 'package:daewon_am/components/helpers/http/http_helper.dart';
import 'package:daewon_am/components/models/theme_setting_model.dart';
import 'package:daewon_am/components/models/user_info_model.dart';
import 'package:daewon_am/components/widgets/buttons/mouse_reaction_button.dart';
import 'package:daewon_am/components/widgets/buttons/mouse_reaction_icon_button.dart';
import 'package:daewon_am/components/widgets/presets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late ThemeSettingModel _themeModel;
  late UserInfoModel _userInfoModel;

  late Color _foregroundColor;
  late Color _layerColor;
  late Color _identityColor;
  late Color _identityMouseOverColor;

  late Color _underlineColor;
  late Color _underlineFocusedColor;
  late Color _underlineInvalidColor;
  late Color _underlineInvalidFocusedColor;
  late Color _hintTextColor;

  final _idController = TextEditingController();
  final _pwdController = TextEditingController();

  bool _visible = false;

  String _userId = "";
  String _userPwd = "";

  bool _idIsValid = true;
  bool _pwdIsValid = true;

  bool _loggingIn = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _themeModel = context.watch<ThemeSettingModel>();
    _userInfoModel = context.watch<UserInfoModel>();

    _idController.text = _userId;
    _pwdController.text = _userPwd;

    loadColors();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(
          minWidth: 400,
          minHeight: 300,
          maxWidth: 800,
          maxHeight: 600
        ),
        child: _loggingIn ? const LoadingIndicator() :
        AnimatedContainer(
          duration: colorChangeDuration,
          curve: colorChangeCurve,
          margin: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: _layerColor,
            borderRadius: BorderRadius.circular(8)
          ),
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "로그인",
                  style: TextStyle(
                    color: _foregroundColor,
                    fontSize: 24
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "아이디",
                        style: TextStyle(
                          color: _foregroundColor,
                          fontSize: 14
                        ),
                      ),
                      idTextFormFieldWidget(),
                      const SizedBox(height: 40),
                      Text(
                        "비밀번호",
                        style: TextStyle(
                          color: _foregroundColor,
                          fontSize: 14
                        ),                        
                      ),
                      pwdTextFormFieldWidget(),
                      const SizedBox(height: 40),
                      loginButtonWidget()
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ),
    );
  }  

  void loadColors() {
    var themeType = _themeModel.getThemeType();

    _foregroundColor = ColorManager.getForegroundColor(themeType);
    _layerColor = ColorManager.getLayerBackgroundColor(themeType);
    _identityColor = ColorManager.getIdentityColor(themeType);
    _identityMouseOverColor = ColorManager.getIdentityMouseOverColor(themeType);

    _underlineColor = ColorManager.getTextFormFieldUnderlineColor(themeType);
    _underlineFocusedColor = ColorManager.getTextFormFieldUnderlineFocusedColor(themeType);
    _underlineInvalidColor = ColorManager.getTextFormFieldUnderlineInvalidColor(themeType);
    _underlineInvalidFocusedColor = ColorManager.getTextFormFieldUnderlineInvalidFocusedColor(themeType);
    _hintTextColor = ColorManager.getHintTextColor(themeType);
  }

  bool validate() {
    bool isValid = true;
    setState(() {
      if (_userId == "") {
      isValid = false;
      _idIsValid = false;
      }
      else {
        _idIsValid = true;
      }
      if (_userPwd == "") {
        isValid = false;
        _pwdIsValid = false;
      }
      else {
        _pwdIsValid = true;      
      }
    });
    return isValid;
  }

  void login() async {    
    if (!validate()) {
      setState(() {
        _loggingIn = false;
      });
      return;
    }

    try {
      var priv = await HttpHelper.login(_userId, _userPwd);

      _userInfoModel.login(_userId, priv);
      setState(() {
        _loggingIn = false;
      });

      Navigator.pushReplacementNamed(context, workspacePageRoute);
    }
    catch (e) {
      showOkDialog(
        context: context, 
        themeModel: _themeModel,
        title: "오류",
        message: e.toString()
      );
      setState(() {
        _loggingIn = false;
      });
      _userPwd = "";
      _pwdController.clear();
      return;      
    }
  }

  Widget idTextFormFieldWidget() {
    return TextFormField(
      controller: _idController,
      maxLength: 32,
      style: TextStyle(
        color: _foregroundColor,
        fontSize: 14
      ),
      onChanged: (text) {
        _userId = text;
      },
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: _idIsValid ? _underlineColor : _underlineInvalidColor)
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: _idIsValid ? _underlineFocusedColor : _underlineInvalidFocusedColor)
        ),
        hintText: "아이디를 입력하세요",
        hintStyle: TextStyle(
          color: _hintTextColor
        ),
        counterText: "",
      ),
    );
  }

  Widget pwdTextFormFieldWidget() {
    return TextFormField(
      controller: _pwdController,
      maxLength: 32,
      style: TextStyle(
        color: _foregroundColor,
        fontSize: 14
      ),
      onChanged: (text) {
        _userPwd = text;
      },
      obscureText: !_visible,
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: _pwdIsValid ? _underlineColor : _underlineInvalidColor)
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: _pwdIsValid ? _underlineFocusedColor : _underlineInvalidFocusedColor)
        ),
        hintText: "패스워드를 입력하세요",
        hintStyle: TextStyle(
          color: _hintTextColor
        ),
        counterText: "",
        suffixIcon: MouseReactionIconButton(
          onTap: () {
            setState(() {
              _visible = !_visible;
            });
          },
          icon: _visible ? Icons.visibility : Icons.visibility_off,
          iconNormal: _underlineColor,
          iconMouseOver: _underlineFocusedColor,
        )
      ),                        
    );
  }

  Widget loginButtonWidget() {
    return Align(
      alignment: Alignment.centerRight,
      child: MouseReactionButton(
        onTap: () {
          if (!_loggingIn) {
            _loggingIn = true;
            login();
          }
        },
        width: 100,
        height: 40,
        borderRadius: BorderRadius.circular(8),
        duration: colorChangeDuration,
        curve: colorChangeCurve,
        normal: _identityColor,
        mouseOver: _identityMouseOverColor,
        child: Center(
          child: Text(
            "로그인",
            style: TextStyle(
              color: _foregroundColor,
              fontSize: 16
            ),
          ),
        ),
      ),
    );
  }
}