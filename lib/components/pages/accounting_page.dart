import 'package:daewon_am/components/dialogs/accounting_data_edit_dialog.dart';
import 'package:daewon_am/components/dialogs/ok_dialog.dart';
import 'package:daewon_am/components/entries/accounting_data.dart';
import 'package:daewon_am/components/entries/date_nav.dart';
import 'package:daewon_am/components/globals/global_theme_settings.dart';
import 'package:daewon_am/components/helpers.dart';
import 'package:daewon_am/components/helpers/http/http_helper.dart';
import 'package:daewon_am/components/helpers/theme/color_manager.dart';
import 'package:daewon_am/components/models/theme_setting_model.dart';
import 'package:daewon_am/components/widgets/buttons/mouse_reaction_icon_button.dart';
import 'package:daewon_am/components/widgets/date_pickers/simple_date_picker.dart';
import 'package:daewon_am/components/widgets/presets/accounting_data_grid.dart';
import 'package:daewon_am/components/widgets/presets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class AccountingPage extends StatefulWidget {
  const AccountingPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AccountingPageState();
}

class _AccountingPageState extends State<AccountingPage> {
  late ThemeSettingModel _themeModel;

  late Color _backgroundColor;
  late Color _backgroundTransparentColor;
  late Color _foregroundColor;

  late Color _layerBackgrondColor;
  late Color _widgetBackgroundColor;
  late Color _widgetBackgroundMouseOverColor;
  late Color _widgetForegroundColor;
  late Color _widgetForegroundMouseOverColor;

  late Color _underlineColor;
  late Color _underlineFocusedColor;

  final List<DateNav> _dateNavs = [];
  bool _dateNavsLoaded = false;

  late Map<int, Set<int>> _dataMap;

  final double _fadeLength = 10;

  late List<AccountingData> _dataList;
  bool _loadingDataList = false;
  bool _dataListLoaded = false;

  late DateTime _beginDate;
  late DateTime _endDate;

  final _searchBarController = TextEditingController();

  final _controller = DataGridController();

  int _selectedIndex = -1;

  @override
  void initState() {
    super.initState();

    var now = DateTime.now();
    _beginDate = DateTime(now.year, now.month, 1);
    _endDate = now;

    loadDates();
  }

  @override  
  void didChangeDependencies() {
    super.didChangeDependencies();
    _themeModel = context.watch<ThemeSettingModel>();

    loadColors();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: 200,
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Colors.transparent
          ),
          child: _dateNavsLoaded ? Stack(
            children: [
              ListView.builder(
                padding: EdgeInsets.only(top: _fadeLength),
                itemCount: _dateNavs.length,
                itemBuilder: (_, index) {
                  return dateNavWidget(index);
                }
              ),
              createFadeOut(length: _fadeLength, fromColor: _backgroundColor, toColor: _backgroundTransparentColor),
              Align(
                alignment: Alignment.bottomCenter,
                child: createFadeOut(length: _fadeLength, fromColor: _backgroundTransparentColor, toColor: _backgroundColor),
              )
            ],
          ) : const LoadingIndicator(),   
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _layerBackgrondColor,
              borderRadius: BorderRadius.circular(8)
            ),
            child: Column(
              children: [
                searchBarWidget(),
                selectSearchingDateWidget(),
                controlButtonsWidget(),
                Expanded(
                  child: _dataListLoaded ? 
                  AccountingDataGrid(
                    dataList: _dataList,
                    controller: _controller,
                  ) : (_loadingDataList ? const LoadingIndicator() : const SizedBox()),
                )
              ],
            ),
          )
        )
      ],
    );
  }

  void loadDates() async {
    try {
      var dates = await HttpHelper.getDates();
      
      Map<int, Set<int>> dateMap = <int, Set<int>>{};
      for (var date in dates) {
        if (!dateMap.containsKey(date.year)) {
          Set<int> monthSet = <int>{ date.month };
          dateMap[date.year] = monthSet;
        } else {
          dateMap[date.year]!.add(date.month);
        }
      }

      for (var year in dateMap.keys) {
        _dateNavs.add(DateNav(year, -1, true));

        var months = dateMap[year]!;
        for (var month in months) {
          _dateNavs.add(DateNav(year, month, false));
        }
      }

      setState(() {
        _dateNavsLoaded = true;
        _dataMap = dateMap;
      });
    }
    catch (e) {
      showOkDialog(
        context: context, 
        themeModel: _themeModel,
        title: "오류",
        message: e.toString()
      );
    }
  }

  void loadColors() {
    var themeType = _themeModel.getThemeType();

    _backgroundColor = ColorManager.getBackgroundColor(themeType);
    _backgroundTransparentColor = ColorManager.getBackgroundTransparentColor(themeType);
    _foregroundColor = ColorManager.getForegroundColor(themeType);

    _layerBackgrondColor = ColorManager.getLayerBackgroundColor(themeType);
    _widgetBackgroundColor = ColorManager.getWidgetBackgroundColor(themeType);
    _widgetBackgroundMouseOverColor = ColorManager.getWidgetBackgroundMouseOverColor(themeType);
    _widgetForegroundColor = ColorManager.getWidgetIconForegroundColor(themeType);
    _widgetForegroundMouseOverColor = ColorManager.getWidgetIconForegroundMouseOverColor(themeType);

    _underlineColor = ColorManager.getTextFormFieldUnderlineColor(themeType);
    _underlineFocusedColor = ColorManager.getTextFormFieldUnderlineFocusedColor(themeType);
  }

  void loadAccountData(int index) async {
    if (index == -1) return;
    try {
      var dateNav = _dateNavs[index];
      var list = await HttpHelper.getAccountingData(dateNav.year, dateNav.month);
      
      setState(() {
        _loadingDataList = false;
        _dataListLoaded = true;
        _dataList = list;
      });
    }
    catch (e) {
      showOkDialog(
        context: context, 
        themeModel: _themeModel,
        title: "오류",
        message: e.toString()
      );
    }    
  }

  void addAccountingData() {
    showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (_) => ChangeNotifierProvider.value(
        value: _themeModel,
        child: AccountingDataEditDialog(
          onPressed: (data) async {
            try {
              await HttpHelper.addAccountingData(data);
              loadAccountData(_selectedIndex);
            }
            catch(e) {
              showOkDialog(
                context: context, 
                themeModel: _themeModel,
                title: "오류",
                message: e.toString()
              );
              return;
            }
          },
        ),
      )
    );
  }

  void editAccountingData() {
    if (_controller.selectedIndex == -1) {
      showOkDialog(
        context: context, 
        themeModel: _themeModel,
        title: "알림",
        message: "수정할 데이터를 선택하세요"                              
      );
      return;
    }
    var data = _dataList[_controller.selectedIndex];
    showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (_) => ChangeNotifierProvider.value(
        value: _themeModel,
        child: AccountingDataEditDialog(
          data: data,
          onPressed: (data) async {
            try {
              await HttpHelper.editAccountingData(data);
              loadAccountData(_selectedIndex);
            }
            catch(e) {
              showOkDialog(
                context: context, 
                themeModel: _themeModel,
                title: "오류",
                message: e.toString()
              );
              return;
            }
          },
        ),
      )
    );
  }

  void removeAccountingData() async {
    if (_controller.selectedIndex == -1) {
      showOkDialog(
        context: context, 
        themeModel: _themeModel,
        title: "알림",
        message: "삭제할 데이터를 선택하세요"                              
      );
      return;
    }
    try {
      var data = _dataList[_controller.selectedIndex];
      await HttpHelper.removeAccountingData(data);
      loadAccountData(_selectedIndex);
    }
    catch(e) {
      showOkDialog(
        context: context, 
        themeModel: _themeModel,
        title: "오류",
        message: e.toString()
      );
      return;
    }
  }

  void search() async {
    if (_searchBarController.text == "") {
      showOkDialog(
        context: context, 
        themeModel: _themeModel,
        title: "알림",
        message: "검색어를 입력하세요"                              
      );
      return;
    }
    
    try {
      var list = await HttpHelper.getAccountingDataAsSearching(_beginDate, _endDate, _searchBarController.text);

      setState(() {
        _loadingDataList = false;
        _dataListLoaded = true;
        _dataList = list;
      });
    }
    catch (e) {
      showOkDialog(
        context: context, 
        themeModel: _themeModel,
        title: "오류",
        message: e.toString()
      );
      return;
    }
  }

  Widget dateNavWidget(int index) {
    return MouseRegion(
      onEnter: (event) {},
      onExit: (event) {},
      child: GestureDetector(
        onTap: () {
          _loadingDataList = true;
          _selectedIndex = index;
          loadAccountData(index);
        },
        child: Container(
          height: 40,
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.only(left: 20),
          decoration: BoxDecoration(
            color: _layerBackgrondColor,
            borderRadius: BorderRadius.circular(8)
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              _dateNavs[index].year.toString() + "년 " + 
              (_dateNavs[index].yearly ? "" : _dateNavs[index].month.toString() + "월"),
              style: TextStyle(
                color: _foregroundColor
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget altDateNavWidget() {
    return MouseRegion(
      onEnter: (event) {},
      onExit: (event) {},
      child: GestureDetector(
        onTap: () {
          _loadingDataList = true;
          _selectedIndex = index;
          loadAccountData(index);
        },
        child: Container(
          height: 40,
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.only(left: 20),
          decoration: BoxDecoration(
            color: _layerBackgrondColor,
            borderRadius: BorderRadius.circular(8)
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              _dateNavs[index].year.toString() + "년 " + 
              (_dateNavs[index].yearly ? "" : _dateNavs[index].month.toString() + "월"),
              style: TextStyle(
                color: _foregroundColor
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget searchBarWidget() {
    return Container(
      height: 50,
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
        child: TextFormField(
          controller: _searchBarController,
          style: TextStyle(
            color: _foregroundColor
          ),
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: _underlineColor)
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: _underlineFocusedColor)
            ),
            suffixIcon: MouseReactionIconButton(
              onTap: search,
              iconNormal: _widgetForegroundColor,
              iconMouseOver: _widgetForegroundMouseOverColor,
              icon: Icons.search,
            )
          ),
        ),
      ),
    );
  }

  Widget selectSearchingDateWidget() {
    return Container(
      height: 40,
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SimpleDatePicker(
            initialDate: _beginDate,
            lastDate: _endDate,
            onChangedDate: (date) {
              if (date == null) return;
              setState(() {
                _beginDate = date;
              });
            }
          ),
          const Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Text("~"),
          ),
          SimpleDatePicker(
            initialDate: _endDate,
            firstDate: _beginDate,
            onChangedDate: (date) {
              if (date == null) return;
              setState(() {
                _endDate = date!;
              });
            }
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget controlButtonWidget({required void Function() onTap, required IconData icon}) {
    return MouseReactionIconButton(
      onTap: onTap,
      width: 32,
      height: 32,
      borderRadius: BorderRadius.circular(8),
      margin: const EdgeInsets.only(top: 2, right: 10),
      duration: colorChangeDuration,
      curve: colorChangeCurve,
      normal: _widgetBackgroundColor,
      mouseOver: _widgetBackgroundMouseOverColor,
      iconNormal: _foregroundColor,
      iconMouseOver: _foregroundColor,
      icon: icon,
      iconSize: 24,
    );
  }

  Widget controlButtonsWidget() {
    return Container(
      height: 40,
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          controlButtonWidget(
            onTap: addAccountingData, 
            icon: Icons.add
          ),
          controlButtonWidget(
            onTap: editAccountingData, 
            icon: Icons.edit
          ),
          controlButtonWidget(
            onTap: removeAccountingData, 
            icon: Icons.delete
          ),
        ],
      ),
    );
  }
}