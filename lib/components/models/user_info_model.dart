import 'package:daewon_am/components/enums/privileges.dart';
import 'package:flutter/material.dart';

class UserInfoModel with ChangeNotifier {
  String _userId = "";
  bool _loggedIn = false;
  EPrivileges _privileges = EPrivileges.eObserver;

  bool getLoggedIn() {
    return _loggedIn;
  }

  EPrivileges getPrivileges() {
    return _privileges;
  }

  void login(String userId, EPrivileges privilege) {
    _userId = userId;
    _loggedIn = true;
    _privileges = privilege;
    notifyListeners();
  }

  void logout() {
    _userId = "";
    _loggedIn = false;
    _privileges = EPrivileges.eObserver;
    notifyListeners();    
  }

  String getUserId() {
    return _userId;
  }
}