import 'package:daewon_am/components/entries/accounting_data.dart';
import 'package:daewon_am/components/helpers/color_manager.dart';
import 'package:daewon_am/components/models/theme_setting_model.dart';
import 'package:daewon_am/components/widgets/buttons/date_picker_button.dart';
import 'package:daewon_am/components/widgets/buttons/dialog_button.dart';
import 'package:daewon_am/components/widgets/check_boxes/responsive_check_box.dart';
import 'package:daewon_am/components/widgets/effects/fade_in_out.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AccountingDataEditDialog extends StatefulWidget {
  final AccountingData? data;
  final void Function(AccountingData) onPressed;

  const AccountingDataEditDialog({
    Key? key,
    this.data,
    required this.onPressed}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AccountingDataEditDialogState();
}

class _AccountingDataEditDialogState extends State<AccountingDataEditDialog> {
  late ThemeSettingModel _themeModel;

  late Color _backgroundColor;
  late Color _backgroundTransparentColor;
  late Color _foregroundColor;
  late Color _identityColor;
  late Color _normal;
  late Color _mouseOver;
  late Color _underlineColor;
  late Color _underlineFocusedColor;
  late Color _underlineInvalidColor;
  late Color _underlineInvalidFocusedColor;

  late TextStyle _textStyle;

  late DateTime _date;
  late DateTime _depositDate;

  bool _dataType = false;
  bool _depositConfirmed = false;

  final List<TextInputFormatter> _includesFloatingPointInputFormatter = [
    FilteringTextInputFormatter.allow(RegExp(r"^[+-]?((^(0|[1-9]\d*))+([.][0-9]*)?|[.][0-9]+)")),
  ];
  final List<TextInputFormatter> _onlyDidgitInputFormatter = [
    FilteringTextInputFormatter.allow(RegExp(r"^[+-]?([0]|([1-9]+[0-9]*))")),
  ];

  late String title;
  late String buttonLabel;

  final _clientNameTextEditingController = TextEditingController();
  final _steelWeightTextEditingController = TextEditingController();
  final _supplyPriceTextEditingController = TextEditingController();
  final _taxAmountTextEditingController = TextEditingController();
  final _unitPriceTextEditingController = TextEditingController();

  bool _isClientNameValid = true;
  bool _isSteelWeightValid = true;
  bool _isSupplyPriceValid = true;
  bool _isTaxAmountValid = true;
  bool _isUnitPriceValid = true;

  bool _firstCall = true;

  @override
  void initState() {
    super.initState();
    if (widget.data == null) {      
      title = "데이터 추가";
      buttonLabel = "추가";
      final now = DateTime.now();
      _date = now;
      _depositDate = now;
    }
    else {
      title = "데이터 수정";
      buttonLabel = "수정";
      final data = widget.data!;
      _clientNameTextEditingController.text = data.clientName;
      _steelWeightTextEditingController.text  = data.steelWeight.toString();
      _supplyPriceTextEditingController.text = data.supplyPrice.toString();
      _taxAmountTextEditingController.text = data.taxAmount.toString();
      _unitPriceTextEditingController.text = data.unitPrice.toString();
      _dataType = data.dataType;
      _depositConfirmed = data.depositConfirmed;
      _date = data.date;
      _depositDate = (!data.depositConfirmed || data.depositDate == null) ? DateTime.now() : data.depositDate!;
    }
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
    _clientNameTextEditingController.dispose();
    _steelWeightTextEditingController.dispose();
    _supplyPriceTextEditingController.dispose();
    _taxAmountTextEditingController.dispose();
    _unitPriceTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 350,
        height: 500,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _backgroundColor,
          borderRadius: BorderRadius.circular(8)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
              child: Text(
                title,
                style: TextStyle(
                  color: _foregroundColor,
                  fontSize: 24
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        dataRowWidget(
                          label: "거래처", 
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
                            child: TextFormField(
                              controller: _clientNameTextEditingController,
                              maxLength: 32,
                              style: _textStyle,
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: _isClientNameValid ? _underlineColor : _underlineInvalidColor)
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: _isClientNameValid ? _underlineFocusedColor : _underlineInvalidFocusedColor)
                                ),
                                counterText: "",
                              ),
                            ),
                          )
                        ),
                        dataRowWidget(
                          label: "날짜", 
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: DatePickerButton(
                              onChangedDate: (date) {
                                if (date == null) return;
                                setState(() {
                                  _date = date;
                                });
                              },
                              initialDate: _date,
                            ),
                          )
                        ),
                        dataRowWidget(
                          label: "중량(t)", 
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
                            child: TextFormField(
                              controller: _steelWeightTextEditingController,
                              maxLength: 9,
                              inputFormatters: _includesFloatingPointInputFormatter,
                              style: _textStyle,
                              decoration: InputDecoration(                                
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: _isSteelWeightValid ? _underlineColor : _underlineInvalidColor)
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: _isSteelWeightValid ? _underlineFocusedColor : _underlineInvalidFocusedColor)
                                ),
                                counterText: "",
                              ),
                            ),
                          )
                        ),
                        dataRowWidget(
                          label: "공급가", 
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
                            child: TextFormField(
                              controller: _supplyPriceTextEditingController,
                              maxLength: 9,
                              inputFormatters: _onlyDidgitInputFormatter,
                              style: _textStyle,
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: _isSupplyPriceValid ? _underlineColor : _underlineInvalidColor)
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: _isSupplyPriceValid ? _underlineFocusedColor : _underlineInvalidFocusedColor)
                                ),
                                counterText: "",
                              ),
                            ),
                          )
                        ),
                        dataRowWidget(
                          label: "세액", 
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
                            child: TextFormField(
                              controller: _taxAmountTextEditingController,
                              maxLength: 9,
                              inputFormatters: _onlyDidgitInputFormatter,
                              style: _textStyle,
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: _isTaxAmountValid ? _underlineColor : _underlineInvalidColor)
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: _isTaxAmountValid ? _underlineFocusedColor : _underlineInvalidFocusedColor)
                                ),
                                counterText: "",
                              ),
                            ),
                          )
                        ),
                        dataRowWidget(
                          label: "단가", 
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
                            child: TextFormField(
                              controller: _unitPriceTextEditingController,
                              maxLength: 9,
                              inputFormatters: _onlyDidgitInputFormatter,
                              style: _textStyle,
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: _isUnitPriceValid ? _underlineColor : _underlineInvalidColor)
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: _isUnitPriceValid ? _underlineFocusedColor : _underlineInvalidFocusedColor)
                                ),
                                counterText: "",
                              ),
                            ),
                          )
                        ),
                        dataRowWidget(
                          label: "입금확인", 
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Row(
                              children: [
                                checkBoxWidget(
                                  onChanged: (value) {
                                    if (value == null) return;   
                                    setState(() {
                                      _depositConfirmed = value;
                                    });    
                                  },
                                  value: _depositConfirmed,
                                ),
                                _depositConfirmed ? DatePickerButton(
                                  onChangedDate: (date) {
                                    if (date == null) return;
                                    setState(() {
                                      _depositDate = date;
                                    });                                  
                                  }, 
                                  initialDate: _depositDate
                                ) : const SizedBox()
                              ],
                            ),
                          )
                        ),
                        dataRowWidget(
                          label: "매출입", 
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Row(
                              children: [
                                ResponsiveCheckBox(
                                  onChanged: (value) {
                                    if (value == null) return;                                  
                                    setState(() {
                                      _dataType = value;
                                    });     
                                  },
                                  value: _dataType,
                                  borderColor: _foregroundColor,
                                  activeColor: _identityColor,
                                  checkColor: _foregroundColor,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  _dataType ? "매입" : "매출",
                                  style: _textStyle,
                                )
                              ],
                            ),
                          )
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: FadeInOut(
                      length: 10,
                      fromColor: _backgroundColor,
                      toColor: _backgroundTransparentColor
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: FadeInOut(
                      length: 10,
                      fromColor: _backgroundTransparentColor,
                      toColor: _backgroundColor
                    ),
                  ),
                ],
              )
            ),
            SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  DialogButton(
                    onPressed: onOkButtonPressed,
                    label: buttonLabel,
                    normal: _normal,
                    mouseOver: _mouseOver,                    
                    fontColor: _foregroundColor,
                  ),                  
                  const  SizedBox(width: 5),
                  DialogButton(
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

  void onThemeModelChanged() {
    final themeType = _themeModel.getThemeType();
    _backgroundColor = ColorManager.getLayerBackgroundColor(themeType);
    _backgroundTransparentColor = ColorManager.getLayerTransparentBackgroundColor(themeType);
    _foregroundColor = ColorManager.getForegroundColor(themeType);
    _identityColor = ColorManager.getIdentityColor(themeType);
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

  void onOkButtonPressed() {
    if (!validate()) return;
    final data = AccountingData(
      uid: widget.data == null ? null : widget.data!.uid,
      clientName: _clientNameTextEditingController.text, 
      date: _date, 
      steelWeight: double.parse(_steelWeightTextEditingController.text), 
      supplyPrice: int.parse(_supplyPriceTextEditingController.text), 
      taxAmount: int.parse(_taxAmountTextEditingController.text), 
      unitPrice: int.parse(_unitPriceTextEditingController.text),
      dataType: _dataType,
      depositConfirmed: _depositConfirmed,
      depositDate: _depositConfirmed ? _depositDate : null
    );
    widget.onPressed(data);
    Navigator.of(context).pop();
  }

  void onCancelButtonPressed() {
    Navigator.of(context).pop();
  }

  bool validate() {
    bool isValid = true;
    setState(() {
      if (_clientNameTextEditingController.text.isEmpty) {
        isValid = false;
        _isClientNameValid = false;
      }
      else {
        _isClientNameValid = true;
      }
      if (_steelWeightTextEditingController.text.isEmpty) {
        isValid = false;
        _isSteelWeightValid = false;
      }
      else {
        _isSteelWeightValid = true;
      }
      if (_supplyPriceTextEditingController.text.isEmpty) {
        isValid = false;
        _isSupplyPriceValid = false;
      }
      else {
        _isSupplyPriceValid = true;
      }
      if (_taxAmountTextEditingController.text.isEmpty) {
        isValid = false;
        _isTaxAmountValid = false;
      }
      else {
        _isTaxAmountValid = true;
      }
      if (_unitPriceTextEditingController.text.isEmpty) {
        isValid = false;
        _isUnitPriceValid = false;
      }
      else {
        _isUnitPriceValid = true;
      }
    });
    return isValid;
  }

  Widget dataRowWidget({required String label, required Widget child}) {
    return Container(
      color: Colors.transparent,
      height: 32,
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: _textStyle,
            ),
          ),
          Expanded(
            child: child
          )
        ],
      ),
    );
  }

  Widget checkBoxWidget({required void Function(bool?) onChanged, required bool value}) {
    return Checkbox(
      onChanged: onChanged,
      value: value,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4)
      ),
      side: BorderSide(
        color: _foregroundColor,
        width: 2
      ),
      activeColor: _identityColor,
      checkColor: _foregroundColor,
      splashRadius: 0,
    );
  }
}

void showEditingDialog({
  required BuildContext context,
  required ThemeSettingModel themeModel, 
  required AccountingData data,
  required void Function(AccountingData data) onPressed,
}) {
  showDialog(
    context: context, 
    barrierDismissible: false,
    builder: (_) => ChangeNotifierProvider.value(
        value: themeModel,
        child: AccountingDataEditDialog(
          data: data,
          onPressed: onPressed,
        ),
      )
  );
}