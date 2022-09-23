import 'package:daewon_am/components/dialogs/ok_dialog.dart';
import 'package:daewon_am/components/helpers/http/http_helper.dart';
import 'package:daewon_am/components/models/theme_setting_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountingPage extends StatefulWidget {
  const AccountingPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AccountingPageState();
}

class _AccountingPageState extends State<AccountingPage> {
  late ThemeSettingModel _themeModel;

  @override  
  void didChangeDependencies() {
    super.didChangeDependencies();
    _themeModel = context.watch<ThemeSettingModel>();

    loadDates();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(
        child: Text("AccountingPage"),
      ),
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

      print(dateMap.toString());
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
}