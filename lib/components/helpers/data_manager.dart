import 'package:daewon_am/components/entries/accounting_data.dart';
import 'package:daewon_am/components/entries/chart_data.dart';
import 'package:daewon_am/components/helpers/http_manager.dart';

class DataManager {
  static void loadDates({
    required void Function(Map<int, Set<int>> dateMap) onFinished,
    required void Function(String) onError,
    required String token,
    bool receivable = false,
    bool yearly = false,
  }) {
    final future = HttpManager.getDates(token: token, receivable: receivable);
    future.then((dates) {
      Map<int, Set<int>> dateMap = <int, Set<int>>{};
      if (yearly) dateMap[-1] = {};
      for (final date in dates) {
        if (!dateMap.containsKey(date.year)) {
          Set<int> monthSet = <int>{ date.month };
          dateMap[date.year] = monthSet;
        } else {
          dateMap[date.year]!.add(date.month);
        }
      }
      onFinished(dateMap);
    })
    .catchError((e) {
      onError(e.toString());
    });
  }

  static void loadAccountingData({
    required int year, 
    required int month,
    required String token,
    required void Function(List<AccountingData> dataList) onFinished,
    required void Function(String) onError,
    bool receivable = false,
  }) {
    final future = HttpManager.getAccountingData(
      token: token,
      year: year, 
      month: month, 
      receivable: receivable
    );      
    future.then((list) {
      onFinished(list);
    })
    .catchError((e) {
      onError(e.toString());
    });
  }

  static void searchAccountingData({
    required DateTime begin,
    required DateTime end,
    required String clientName,
    required String token,
    required void Function(List<AccountingData> dataList) onFinished,
    required void Function(String) onError,
    bool receivable = false,
  }) {    
    final future = HttpManager.getAccountingDataAsSearching(
      token: token,
      begin: begin, 
      end: end, 
      clientName: clientName, 
      receivable: receivable
    );
    future.then((list) {
      onFinished(list);
    })
    .catchError((e) {
      onError(e.toString());
    });
  }

  static void addAccountingData({
    required String token,
    required AccountingData data,
    required void Function() onFinised,
    required void Function(String) onError,
  }) {
    final future = HttpManager.addAccountingData(token: token, data: data);
    future.then((value) {
      onFinised();
    })
    .catchError((e) {
      onError(e.toString());
    });
  }

  static void addAccountingDataList({
    required String token,
    required List<AccountingData> dataList,
    required void Function() onFinised,
    required void Function(String) onError,
  }) {
    final future = HttpManager.addAccountingDataList(token: token, dataList: dataList);
    future.then((value) {
      onFinised();
    })
    .catchError((e) {
      onError(e.toString());
    });
  }

  static void editAccountingData({
    required AccountingData data,
    required String token,
    required void Function() onFinised,
    required void Function(String err) onError,
  }) {
    final future = HttpManager.editAccountingData(token: token, data: data);
    future.then((value) {
      onFinised();
    })
    .catchError((e) {
      onError(e.toString());
    });
  }

  static void removeAccountingData({
    required AccountingData data,
    required String token,
    required void Function() onFinised,
    required void Function(String) onError,
  }) {
    final future = HttpManager.removeAccountingData(token: token, data: data);
    future.then((value) {
      onFinised();
    })
    .catchError((e) {
      onError(e.toString());
    });
  }

  static void removeAccountingDataList({
    required List<AccountingData> dataList,
    required String token,
    required void Function() onFinised,
    required void Function(String) onError,
  }) {
    final future = HttpManager.removeAccountingDataList(token: token, dataList: dataList);
    future.then((value) {
      onFinised();
    })
    .catchError((e) {
      onError(e.toString());
    });
  }

  static void loadChartData({
    required int year, 
    required int month,
    required String token,
    required void Function(List<SfChartData> dataList) onFinished,
    required void Function(String) onError,
    bool receivable = false,
  }) {
    final future = HttpManager.getGraphData(token: token, year: year, month: month);      
    future.then((list) {
      onFinished(list);
    })
    .catchError((e) {
      onError(e.toString());
    });
  }
}