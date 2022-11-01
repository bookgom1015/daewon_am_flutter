import 'dart:io';

import 'package:daewon_am/components/dialogs/ok_cancel_dialog.dart';
import 'package:daewon_am/components/dialogs/ok_dialog.dart';
import 'package:daewon_am/components/dialogs/user_create_dialog.dart';
import 'package:daewon_am/components/entries/user.dart';
import 'package:daewon_am/components/helpers/color_manager.dart';
import 'package:daewon_am/components/helpers/http_helper.dart';
import 'package:daewon_am/components/helpers/widget_helper.dart';
import 'package:daewon_am/components/models/theme_setting_model.dart';
import 'package:daewon_am/components/models/user_info_model.dart';
import 'package:daewon_am/components/widgets/presets/loading_indicator.dart';
import 'package:daewon_am/components/widgets/presets/user_data_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  late ThemeSettingModel _themeModel;
  late UserInfoModel _userInfoModel;

  late Color _layerBackgroundColor;
  late Color _widgetBackgroundColor;
  late Color _widgetBackgroundMouseOverColor;
  late Color _widgetForegroundColor;
  late Color _widgetForegroundMouseOverColor;
  late Color _foregroundColor;

  List<User> _userList = [];
  bool _loaded = false;

  final _dataGridController = DataGridController();

  bool _firstCall = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_firstCall) {
      _firstCall = false;
      _themeModel = context.watch<ThemeSettingModel>();
      _userInfoModel = context.watch<UserInfoModel>();
      _themeModel.addListener(onThemeModelChanged);
      onThemeModelChanged();
      loadUsers();
    }
  }

  @override
  void dispose() {
    _themeModel.removeListener(onThemeModelChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.fromLTRB(10, 10, 5, 10),
            decoration: BoxDecoration(
              color: _layerBackgroundColor,
              borderRadius: BorderRadius.circular(8)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                  child: Text(
                    "유저 관리",
                    style: TextStyle(
                      color: _foregroundColor,
                      fontSize: 18
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      WidgetHelper.controlButtonWidget(
                        onTap: addUser,
                        normal: _widgetBackgroundColor, 
                        mouseOver: _widgetBackgroundMouseOverColor,
                        iconNormal: _widgetForegroundColor,
                        iconMouseOver: _widgetForegroundMouseOverColor,
                        icon: Icons.add,
                        tooltip: "추가",
                      ),
                      WidgetHelper.controlButtonWidget(
                        onTap: removeUser,
                        normal: _widgetBackgroundColor, 
                        mouseOver: _widgetBackgroundMouseOverColor,
                        iconNormal: _widgetForegroundColor,
                        iconMouseOver: _widgetForegroundMouseOverColor,
                        icon: Icons.delete,
                        tooltip: "삭제",
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      UserDataGrid(
                        userList: _userList, 
                        controller: _dataGridController,
                      ),
                      _loaded ? const SizedBox() : const LoadingIndicator()
                    ],
                  )
                )
              ],
            ),
          )
        ),
        Container(
          width: 240,
          margin: const EdgeInsets.fromLTRB(5, 10, 10, 10),
          decoration: BoxDecoration(
            color: _layerBackgroundColor,
            borderRadius: BorderRadius.circular(8)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,            
            children: [
              Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                child: Text(
                  "접속 중인 유저 목록",
                  style: TextStyle(
                    color: _foregroundColor,
                    fontSize: 18
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _widgetBackgroundColor,
                    borderRadius: BorderRadius.circular(8)
                  ),
                ),
              )
            ],
          ),
        )
      ]
    );
  }

  void showErrorDialog(String err) {
    if (!mounted) return;
    showOkDialog(
      context: context, 
      themeModel: _themeModel,
      title: "오류",
      message: err
    );
  }

  void onThemeModelChanged() {
    var themeType = _themeModel.getThemeType();
    _layerBackgroundColor = ColorManager.getLayerBackgroundColor(themeType);
    _widgetBackgroundColor = ColorManager.getWidgetBackgroundColor(themeType);
    _widgetBackgroundMouseOverColor = ColorManager.getWidgetBackgroundMouseOverColor(themeType);
    _widgetForegroundColor = ColorManager.getWidgetIconForegroundColor(themeType);
    _widgetForegroundMouseOverColor = ColorManager.getWidgetIconForegroundMouseOverColor(themeType);
    _foregroundColor = ColorManager.getForegroundColor(themeType);
  }

  void invalidate() {
    setState(() {
      _loaded = false;
      _userList.clear();
    });
  }

  void loadUsers() {
    final userListFuture = HttpHelper.getUsers(_userInfoModel.getToken());
    userListFuture.then((userList) {
      _userList = userList; 
      if (!mounted) return;
      setState(() {
        _loaded = true;
      });
    });
  }

  void addUser() {
    showUserCreateDialog(
      context: context, 
      themeModel: _themeModel, 
      onPressed: (user) {
        invalidate();
        final future = HttpHelper.addUser(token: _userInfoModel.getToken(), user: user);
        future.then((value) {
          loadUsers();
        })
        .catchError((e) {
          showErrorDialog(e.toString());
        });
      }
    );
  }

  void removeUser() {
    final row = _dataGridController.selectedRow;
    if (row == null) {
      showOkDialog(
        context: context, 
        themeModel: _themeModel,
        title: "알림",
        message: "삭제할 유저를 선택하세요"                              
      );
      return;
    }
    showOkCancelDialog(
      context: context, 
      themeModel: _themeModel, 
      onPressed: () {
        invalidate();
        final dataCell = row.getCells().firstWhere((element) => element.columnName == "user");
        final selectedUser = dataCell.value as User;
        final future = HttpHelper.removeUser(token: _userInfoModel.getToken(), user: selectedUser);
        future.then((value) {
          loadUsers();
        })
        .catchError((e) {
          showErrorDialog(e.toString());
        });
      },
      title: "알림",
      message: "정말로 삭제하시겠습니까"      
    );
  }
}