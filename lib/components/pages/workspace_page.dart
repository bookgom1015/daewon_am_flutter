import 'package:daewon_am/components/entries/page_list.dart';
import 'package:daewon_am/components/models/page_control_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkspacePage extends StatefulWidget {
  final PageList pageList;

  const WorkspacePage({
    Key? key,
    required this.pageList}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WorkspacePageState();
}

class _WorkspacePageState extends State<WorkspacePage> {
  late PageControlModel _pageControlModel;

  late List<Widget> _pageList;

  @override
  void initState() {
    super.initState();
    _pageList = widget.pageList.getPageList();
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
          },
          onPageChanged: (index) {
            _pageControlModel.onPageChanged(index);
          },
        ),
      ),
    );
  }  
}