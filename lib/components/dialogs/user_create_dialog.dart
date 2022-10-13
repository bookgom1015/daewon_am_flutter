import 'package:daewon_am/components/entries/user.dart';
import 'package:daewon_am/components/enums/privileges.dart';
import 'package:daewon_am/components/helpers/color_manager.dart';
import 'package:daewon_am/components/helpers/widget_helper.dart';
import 'package:daewon_am/components/models/theme_setting_model.dart';
import 'package:daewon_am/components/widgets/buttons/mouse_reaction_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserCreateDialog extends StatefulWidget {
  final void Function(User user) onPressed;

  const UserCreateDialog({
    Key? key,
    required this.onPressed}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UserCreateDialogState();
}

class _UserCreateDialogState extends State<UserCreateDialog> {
  late ThemeSettingModel _themeModel;

  late Color _layerBackgroundColor;
  late Color _widgetBackgroundColor;
  late Color _foregroundColor;
  late Color _normal;
  late Color _mouseOver;
  late Color _underlineColor;
  late Color _underlineFocusedColor;
  late Color _underlineInvalidColor;
  late Color _underlineInvalidFocusedColor;

  late TextStyle _textStyle;

  final _userIdTextEditingController = TextEditingController();
  final _userPwdTextEditingController = TextEditingController();

  bool _userIdIsValid = true;
  bool _userPwdIsValid = true;

  late List<String> _dropdownMenumItems;
  String _selectedPriv = EPrivileges.eObserver.text;

  bool _visible = false;

  @override
  void initState() {
    super.initState();

    _dropdownMenumItems = getPrivTextList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _themeModel = context.watch<ThemeSettingModel>();

    loadColors();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 350,
        height: 300,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _layerBackgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
              child: Text(
                "유저 추가",
                style: TextStyle(
                  color: _foregroundColor,
                  fontSize: 24
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Column(
                  children: [
                    idTextformFieldWidget(),
                    pwdTextformFieldWidget(),
                    privDropdownButtonWidget(),
                  ],
                ),
              )
            ),
            SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  WidgetHelper.dialogButton(
                    onPressed: onAddButtonPressed,
                    label: "추가",
                    normal: _normal,
                    mouseOver: _mouseOver,                    
                    fontColor: _foregroundColor,
                  ),                  
                  const  SizedBox(width: 5),
                  WidgetHelper.dialogButton(
                    onPressed: onCancelButtonPressed,
                    label: "취소",
                    normal: _normal,
                    mouseOver: _mouseOver,                    
                    fontColor: _foregroundColor,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void loadColors() {
    final themeType = _themeModel.getThemeType();
    _layerBackgroundColor = ColorManager.getLayerBackgroundColor(themeType);
    _widgetBackgroundColor = ColorManager.getWidgetBackgroundColor(themeType);
    _foregroundColor = ColorManager.getForegroundColor(themeType);
    _normal = ColorManager.getWidgetBackgroundColor(themeType);
    _mouseOver = ColorManager.getWidgetBackgroundMouseOverColor(themeType);
    _underlineColor = ColorManager.getTextFormFieldUnderlineColor(themeType);
    _underlineFocusedColor = ColorManager.getTextFormFieldUnderlineFocusedColor(themeType);
    _underlineInvalidColor = ColorManager.getTextFormFieldUnderlineInvalidColor(themeType);
    _underlineInvalidFocusedColor = ColorManager.getTextFormFieldUnderlineInvalidFocusedColor(themeType);
    _textStyle = TextStyle(
      color: _foregroundColor
    );
  }

  bool validate() {
    bool valid = true;
    setState(() {
      if (_userIdTextEditingController.text.isEmpty) {
        valid = false;
        _userIdIsValid = false;
      }
      else {
        _userIdIsValid = true;
      }
      if (_userPwdTextEditingController.text.isEmpty) {
        valid = false;
        _userPwdIsValid = false;
      }
      else {
        _userPwdIsValid = true;
      }
    });
    return valid;
  }

  void onAddButtonPressed() {
    if (!validate()) return;
    final priv = textToPriv(_selectedPriv);
    final userId = _userIdTextEditingController.text;
    final userPwd = _userPwdTextEditingController.text;
    final user = User(userId, userPwd, priv);
    widget.onPressed(user);
    Navigator.of(context).pop();
  }

  void onCancelButtonPressed() {
    Navigator.of(context).pop();
  }

  Widget idTextformFieldWidget() {
    return Container(
      height: 32,
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              "아이디",
              style: _textStyle,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
              child: TextFormField(
                controller: _userIdTextEditingController,
                maxLength: 32,
                style: _textStyle,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: _userIdIsValid ? _underlineColor : _underlineInvalidColor)
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: _userIdIsValid ? _underlineFocusedColor : _underlineInvalidFocusedColor)
                  ),
                  counterText: "",
                ),
              ),
            )
          )
        ],
      ),
    );
  }

  Widget pwdTextformFieldWidget() {
    return Container(
      height: 32,
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              "패스워드",
              style: _textStyle,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
              child: TextFormField(
                controller: _userPwdTextEditingController,
                maxLength: 32,
                style: _textStyle,
                obscureText: !_visible,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: _userPwdIsValid ? _underlineColor : _underlineInvalidColor)
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: _userPwdIsValid ? _underlineFocusedColor : _underlineInvalidFocusedColor)
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
              ),
            )
          )
        ],
      ),
    );
  }

  Widget privDropdownButtonWidget() {
    return Container(
      height: 32,
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              "권한",
              style: _textStyle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: DropdownButton(
              value: _selectedPriv,
              borderRadius: BorderRadius.circular(8),
              dropdownColor: _widgetBackgroundColor,
              underline: const SizedBox(),
              icon: Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.arrow_drop_down,
                  color: _foregroundColor,
                ),
              ),
              onChanged: (String? value) {
                if (value == null) return;
                setState(() {
                  _selectedPriv = value;
                });
              },
              items: _dropdownMenumItems.map<DropdownMenuItem<String>>((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                      color: _foregroundColor,
                    ),
                  )
                );
              }).toList(), 
            )
          )
        ],
      ),
    );
  }
}

void showUserCreateDialog({
  required BuildContext context,
  required ThemeSettingModel themeModel,
  required void Function(User user) onPressed,
}) {
  showDialog(
    context: context, 
    barrierDismissible: false,
    builder: (_) => ChangeNotifierProvider.value(
      value: themeModel,
      child: UserCreateDialog(
        onPressed: onPressed,
      ),
    )
  );
}