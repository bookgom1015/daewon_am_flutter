import 'package:daewon_am/components/enums/privileges.dart';
import 'package:flutter/material.dart';

class UserInfo {
  String userId;
  String token;
  EPrivileges priv;

  UserInfo({this.userId = "", this.token = "", this.priv = EPrivileges.eNone});
}

class UserInfoModel with ChangeNotifier {
  final _userInfo = UserInfo();
  bool _loggedIn = false;

  void login(UserInfo info) {
    _userInfo.userId = info.userId;
    _userInfo.token = info.token;
    _userInfo.priv = info.priv;
    _loggedIn = true;
    notifyListeners();
  }

  void logout() {
    _userInfo.userId = "";
    _userInfo.token = "";
    _userInfo.priv = EPrivileges.eNone;
    _loggedIn = false;
    notifyListeners();
  }

  String getUserId() {
    return _userInfo.userId;
  }

  String getToken() {
    return _userInfo.token;
  }

  EPrivileges getPrivileges() {
    return _userInfo.priv;
  }

  UserInfo getUserInfo() {
    return _userInfo;
  }

  bool getLoggedIn() {
    return _loggedIn;
  }
}