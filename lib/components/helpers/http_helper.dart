import 'package:daewon_am/components/entries/accounting_data.dart';
import 'package:daewon_am/components/entries/chart_data.dart';
import 'package:daewon_am/components/entries/user.dart';
import 'package:daewon_am/components/enums/privileges.dart';
import 'package:daewon_am/components/models/user_info_model.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

const String webApiUri = kDebugMode ? "https://localhost:5001/api/" : "https://www.stdaewon.com/api/";

Uri loginUri = Uri.parse("${webApiUri}account/login");
Uri dataUri = Uri.parse("${webApiUri}account");
Uri dataListUri = Uri.parse("${webApiUri}account/list");
Uri versionUri = Uri.parse("${webApiUri}version");
Uri userUri = Uri.parse("${webApiUri}account/user");

class HttpHelper {
  static Future<UserInfo> login(String userId, String userPwd) async {
    final response = await http.post(
      loginUri,
      headers: { "Content-Type": "application/json" },
      body: jsonEncode({
        "user_id": userId,
        "user_pwd": userPwd
      })
    );
    try {
      final json = jsonDecode(response.body);
      if (response.statusCode != 200) {
        if (kDebugMode) print(response.body.toString());
        throw Exception(json["errors"].toString());
      }      
      String token = json["token"];
      EPrivileges priv = intToPriv(json["priv"] as int);      
      return UserInfo(userId: userId, token: token, priv: priv);
    }
    catch (e) {
      rethrow;
    }
  }

  static Future<List<DateTime>> getDates({required String token, bool receivable = false}) async {
    final uri = StringBuffer();
    uri.write(webApiUri);
    uri.write("account/date");
    if (receivable) uri.write("?receivable=true");
    final response = await http.get(
      Uri.parse(uri.toString()),
      headers: { "Authorization": "Bearer $token" }
    );
    try {
      if (response.statusCode != 200) {
        if (kDebugMode) print(response.body.toString());
        throw Exception("날짜를 불러오지 못 했습니다");
      }
      final json = jsonDecode(response.body);
      final dates = json as List<dynamic>;
      List<DateTime> list = [];
      for (final date in dates) {
        final dateString = date as String;
        list.add(DateTime.parse(dateString));
      }
      return list;
    }
    catch (e) {
      rethrow;
    }
  }

  static Future<List<AccountingData>> getAccountingData({
    required String token,
    int year = -1, 
    int month = -1,
    bool receivable = false
  }) async {
    final uri = StringBuffer();
    uri.write(webApiUri);
    uri.write("account");
    if (year != -1) {
      uri.write("?year=$year");
      if (month != -1) uri.write("&month=$month");
      if (receivable) uri.write("&receivable=true");
    }
    final response = await http.get(
      Uri.parse(uri.toString()),
      headers: { "Authorization": "Bearer $token" }
    );
    try {
      if (response.statusCode != 200) {
        if (kDebugMode) print(response.body.toString());
        throw Exception("데이터를 불러오지 못 했습니다");
      }
      final json = jsonDecode(response.body);

      final dataList = json as List<dynamic>;
      List<AccountingData> list = [];

      for (final data in dataList) {
        list.add(AccountingData.fromJson(data));
      }
      return list;
    }
    catch (e) {
      rethrow;
    }
  }

  static Future<List<AccountingData>> getAccountingDataAsSearching({
    required String token,
    required DateTime begin, 
    required DateTime end, 
    required String clientName,
    bool receivable = false
  }) async {
    final uri = StringBuffer();
    uri.write(webApiUri);
    uri.write("account/search");
    uri.write("?begin="); uri.write(begin.toIso8601String());
    uri.write("&end="); uri.write(end.toIso8601String());
    uri.write("&clientName="); uri.write(clientName);
    if (receivable) uri.write("&receivable=true");    
    final response = await http.get(
      Uri.parse(uri.toString()),
      headers: { "Authorization": "Bearer $token" }
    );
    try {
      if (response.statusCode != 200) {
        if (kDebugMode) print(response.body.toString());
        throw Exception("데이터를 불러오지 못 했습니다");
      }
      final json = jsonDecode(response.body);
      final dataList = json as List<dynamic>;
      List<AccountingData> list = [];

      for (final data in dataList) {
        list.add(AccountingData.fromJson(data));
      }
      return list;
    }
    catch (e) {
      rethrow;
    }
  }

  static Future<void> addAccountingData({
    required String token,
    required AccountingData data
  }) async {
    final response = await http.post(
      dataUri,
      headers: { "Content-Type": "application/json", "Authorization": "Bearer $token" },
      body: jsonEncode(data.toJson())
    );
    try {
      if (response.statusCode != 200) {
        if (kDebugMode) print(response.body.toString());
        final json = jsonDecode(response.body);
        throw Exception(json["errors"].toString());
      }
    }
    catch (e) {
      rethrow;
    }
  }

  static Future<void> addAccountingDataList({
    required String token,
    required List<AccountingData> dataList,
  }) async {
    final response = await http.post(
      dataListUri,
      headers: { "Content-Type": "application/json", "Authorization": "Bearer $token" },
      body: jsonEncode(dataList.map((e) => e.toJson()).toList())
    );
    try {
      if (response.statusCode != 200) {
        if (kDebugMode) print(response.body.toString());
        final json = jsonDecode(response.body);
        throw Exception(json["errors"].toString());
      }
    }
    catch (e) {
      rethrow;
    }
  }

  static Future<void> editAccountingData({
    required String token,
    required AccountingData data
  }) async {
    final response = await http.put(
      dataUri,
      headers: { "Content-Type": "application/json", "Authorization": "Bearer $token" },
      body: jsonEncode(data.toJson())
    );
    try {
      if (response.statusCode != 200) {
        if (kDebugMode) print(response.body.toString());
        final json = jsonDecode(response.body);
        throw Exception(json["errors"].toString());
      }
    }
    catch (e) {
      rethrow;
    }
  }

  static Future<void> removeAccountingData({
    required String token,
    required AccountingData data,
  }) async {
    final response = await http.delete(
      dataUri,
      headers: { "Content-Type": "application/json", "Authorization": "Bearer $token" },
      body: jsonEncode(data.toJson())
    );
    try {
      if (response.statusCode != 200) {
        if (kDebugMode) print(response.body.toString());
        final json = jsonDecode(response.body);
        throw Exception(json["errors"].toString());
      }
    }
    catch (e) {
      rethrow;
    }
  }

  static Future<void> removeAccountingDataList({
    required String token,
    required List<AccountingData> dataList
  }) async {
    final response = await http.delete(
      dataListUri,
      headers: { "Content-Type": "application/json", "Authorization": "Bearer $token" },
      body: jsonEncode(dataList.map((e) => e.toJson()).toList())
    );
    try {
      if (response.statusCode != 200) {
        if (kDebugMode) print(response.body.toString());
        final json = jsonDecode(response.body);
        throw Exception(json["errors"].toString());
      }
    }
    catch (e) {
      rethrow;
    }
  }

  static Future<List<SfChartData>> getGraphData({
    required String token,
    int year = -1, 
    int month = -1
  }) async {
    final uri = StringBuffer();
    uri.write(webApiUri);
    uri.write("account/chart");
    if (year != -1) {
      uri.write("?year=$year");
      if (month != -1) uri.write("&month=$month");
    }
    final response = await http.get(
      Uri.parse(uri.toString()),
      headers: { "Authorization": "Bearer $token" }
    );
    try {
      if (response.statusCode != 200) {
        if (kDebugMode) print(response.body.toString());
        throw Exception("데이터를 불러오지 못 했습니다");
      }
      final json = jsonDecode(response.body);
      final dataList = json as List<dynamic>;
      List<SfChartData> chartDataList = [];
      for (final data in dataList) {
        final chartData = ChartData.fromJson(data);
        final sb = StringBuffer();
        sb.write(chartData.date);
        if (year == -1 && month == -1) {
          sb.write("년");
        }
        else if (year != -1 && month == -1) {
          sb.write("월");
        }
        else {
          sb.write("일");
        }
        if (chartData.dataType) {
          chartDataList.add(SfChartData(sb.toString(), null, chartData.value));
        }
        else {
          chartDataList.add(SfChartData(sb.toString(), chartData.value, null));
        }
      }
      return chartDataList;
    }
    catch (e) {
      rethrow;
    }
  }
  
  static Future<String> getLastVersion() async {
    final response = await http.get(versionUri);
    try {
      if (response.statusCode != 200) {
        if (kDebugMode) print(response.body.toString());
        throw Exception("버전 정보를 불러오지 못 했습니다");
      }
      final json = jsonDecode(response.body);
      return json["app_ver"];
    }
    catch (e) {
      rethrow;
    }
  }

  static Future<List<User>> getUsers(String token) async {
    final response = await http.get(
      userUri,
      headers: { "Authorization": "Bearer $token" }
    );
    try {
      if (response.statusCode != 200) {
        if (kDebugMode) print(response.body.toString());
        throw Exception("유저 목록을 불러오지 못 했습니다");
      }
      final json = jsonDecode(response.body);
      final userListInJson = json as List<dynamic>;
      List<User> userList = [];
      for (final userJson in userListInJson) {
        userList.add(User.fromJson(userJson));
      }
      return userList;
    }
    catch (e) {
      rethrow;
    }
  }

  static Future<void> addUser({
    required String token,
    required User user,
  }) async {
    final response = await http.post(
      userUri,
      headers: { "Content-Type": "application/json", "Authorization": "Bearer $token" },
      body: jsonEncode(user.toJson())
    );
    try {
      if (response.statusCode != 200) {
        if (kDebugMode) print(response.body.toString());
        throw Exception("유저 추가를 완료하지 못 했습니다");
      }
    }
    catch (e) {
      rethrow;
    }
  }

  static Future<void> removeUser({
    required String token,
    required User user,
  }) async {
    final response = await http.delete(
      userUri,
      headers: { "Content-Type": "application/json", "Authorization": "Bearer $token" },
      body: jsonEncode(user.toJson())
    );
    try {
      if (response.statusCode != 200) {
        if (kDebugMode) print(response.body.toString());
        throw Exception("유저 삭제를 완료하지 못 했습니다");
      }
    }
    catch (e) {
      rethrow;
    }
  }
}