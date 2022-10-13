
import 'package:daewon_am/components/widgets/presets/page_nav_buttons.dart';
import 'package:flutter/material.dart';

class PageListItem {
  Widget page;
  PageNavButton navButton;

  PageListItem(this.page, this.navButton);
}

class PageList {
  final List<Widget> _pageList = [];
  final List<PageNavButton> _buttonList = [];

  void clear() {
    _pageList.clear();
    _buttonList.clear();
  }

  void addPage(Widget page, PageNavButton button) {
    _pageList.add(page);
    _buttonList.add(button);
  }

  List<Widget> getPageList() {
    return _pageList;
  }

  List<PageNavButton> getPageNavButtonList() {
    return _buttonList;
  }
}