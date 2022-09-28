import 'package:daewon_am/components/entries/accounting_data.dart';
import 'package:daewon_am/components/enums/privileges.dart';
import 'package:daewon_am/components/globals/global_web_api_uri.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class HttpHelper {
  static Future<EPrivileges> login(String userId, String userPwd) async {
    var response = await http.post(
      loginUri,
      headers: { "Content-Type": "application/json" },
      body: jsonEncode({
        "user_id": userId,
        "user_pwd": userPwd
      })
    );

    try {
      var json = jsonDecode(response.body);
      if (response.statusCode != 200) {
        if (kDebugMode) print(response.body.toString());
        throw Exception(json["errors"].toString());
      }

      EPrivileges priv = EPrivileges.values[json["priv"] as int];
      return priv;
    }
    catch (e) {
      rethrow;
    }
  }

  static Future<List<DateTime>> getDates() async {
    var response = await http.get(
      getDatesUri,
    );

    try {
      if (response.statusCode != 200) {
        if (kDebugMode) print(response.body.toString());
        throw Exception("데이터를 불러오지 못 했습니다");
      }
      var json = jsonDecode(response.body);

      var dates = json as List<dynamic>;
      List<DateTime> list = [];

      for (var date in dates) {
        var dateString = date as String;
        list.add(DateTime.parse(dateString));
      }

      return list;
    }
    catch (e) {
      rethrow;
    }
  }

  static Future<List<AccountingData>> getAccountingData(int year, int month) async {
    var uri = StringBuffer();
    uri.write(webApiUri);
    uri.write("account");
    if (year != -1) {
      uri.write("?year=$year");
      if (month != -1) uri.write("&month=$month");
    }
    var response = await http.get(
      Uri.parse(uri.toString())      
    );

    try {
      if (response.statusCode != 200) {
        if (kDebugMode) print(response.body.toString());
        throw Exception("데이터를 불러오지 못 했습니다");
      }
      var json = jsonDecode(response.body);

      var dataList = json as List<dynamic>;
      List<AccountingData> list = [];

      for (var data in dataList) {
        list.add(AccountingData.fromJson(data));
      }

      return list;
    }
    catch (e) {
      rethrow;
    }
  }

  static Future<List<AccountingData>> getAccountingDataAsSearching(DateTime begin, DateTime end, String clientName) async {
    var uri = StringBuffer();
    uri.write(webApiUri);
    uri.write("account/search");
    uri.write("?begin="); uri.write(begin.toIso8601String());
    uri.write("&end="); uri.write(end.toIso8601String());
    uri.write("&clientName="); uri.write(clientName);
    var response = await http.get(
      Uri.parse(uri.toString())
    );

    try {
      if (response.statusCode != 200) {
        if (kDebugMode) print(response.body.toString());
        throw Exception("데이터를 불러오지 못 했습니다");
      }
      var json = jsonDecode(response.body);

      var dataList = json as List<dynamic>;
      List<AccountingData> list = [];

      for (var data in dataList) {
        list.add(AccountingData.fromJson(data));
      }

      return list;
    }
    catch (e) {
      rethrow;
    }
  }

  static Future<void> addAccountingData(AccountingData data) async {
    var response = await http.post(
      dataUri,
      headers: { "Content-Type": "application/json" },
      body: jsonEncode(data.toJson())
    );

    try {
      if (response.statusCode != 200) {
        if (kDebugMode) print(response.body.toString());
        var json = jsonDecode(response.body);
        throw Exception(json["errors"].toString());
      }
    }
    catch (e) {
      rethrow;
    }
  }

  static Future<void> editAccountingData(AccountingData data) async {
    var response = await http.put(
      dataUri,
      headers: { "Content-Type": "application/json" },
      body: jsonEncode(data.toJson())
    );

    try {
      if (response.statusCode != 200) {
        if (kDebugMode) print(response.body.toString());
        var json = jsonDecode(response.body);
        throw Exception(json["errors"].toString());
      }
    }
    catch (e) {
      rethrow;
    }
  }

  static Future<void> removeAccountingData(AccountingData data) async {
    var response = await http.delete(
      dataUri,
      headers: { "Content-Type": "application/json" },
      body: jsonEncode(data.toJson())
    );

    try {
      if (response.statusCode != 200) {
        if (kDebugMode) print(response.body.toString());
        var json = jsonDecode(response.body);
        throw Exception(json["errors"].toString());
      }
    }
    catch (e) {
      rethrow;
    }
  }
}