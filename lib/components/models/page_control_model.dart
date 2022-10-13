import 'package:flutter/material.dart';

class PageControlModel with ChangeNotifier {
  final _pageController = PageController();
  NavigatorState? _navigatorState;
  int _index = 0;

  PageController getPageController() {
    return _pageController;    
  }

  void setNaviatorStae(NavigatorState? state) {
    _navigatorState = state;
  }

  NavigatorState? getNavigatorState() {
    return _navigatorState;
  }

  void onPageChanged(int index) {
    _index = index;
    notifyListeners();
  }

  int getCurrentPageIndex() {
    return _index;
  }
}