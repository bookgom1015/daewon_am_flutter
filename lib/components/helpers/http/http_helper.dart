import 'package:daewon_am/components/enums/privileges.dart';
import 'package:daewon_am/components/globals/global_web_api_uri.dart';
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
      if (response.statusCode != 200) throw Exception(json["errMsg"].toString());

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
      var json = jsonDecode(response.body);
      if (response.statusCode != 200) throw Exception(json["errMsg"].toString());

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
}