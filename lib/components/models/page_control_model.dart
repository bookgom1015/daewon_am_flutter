import 'package:flutter/material.dart';

class PageControlModel with ChangeNotifier {
  final _pageController = PageController();
  NavigatorState? _navigatorState;

  PageController getPageController() {
    return _pageController;    
  }

  void setNaviatorStae(NavigatorState? state) {
    _navigatorState = state;
  }

  NavigatorState? getNavigatorState() {
    return _navigatorState;
  }
}