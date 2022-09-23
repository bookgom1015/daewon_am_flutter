import 'package:daewon_am/components/models/page_control_model.dart';
import 'package:daewon_am/components/pages/accounting_page.dart';
import 'package:daewon_am/components/pages/chart_page.dart';
import 'package:daewon_am/components/pages/receivable_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkspacePage extends StatefulWidget {
  const WorkspacePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WorkspacePageState();
}

class _WorkspacePageState extends State<WorkspacePage> {
  late PageControlModel _pageControlModel;

  late List<Widget> _pageList;

  @override
  void initState() {
    super.initState();

    _pageList = [
      const AccountingPage(),
      const ReceivablePage(),
      const ChartPage()
    ];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _pageControlModel = context.watch<PageControlModel>();
  }

  @override
  Widget build(BuildContext context) {    
    return DefaultTabController(
      length: _pageList.length,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: PageView.builder(
          controller: _pageControlModel.getPageController(),
          itemCount: _pageList.length,
          itemBuilder: (_, index) {
            return _pageList[index];
          }
        ),
      ),
    );
  }  
}