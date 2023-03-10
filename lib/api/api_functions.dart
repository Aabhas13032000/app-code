import 'dart:io';

import 'package:flutter/foundation.dart';

import '../services/mysql_db_service.dart';

class ApiFunctions {
  //Get request
  static Future<Map<String, dynamic>> getApiResult(
      String url, String savedToken,
      {String version = ''}) async {
    Map<String, dynamic> getResult = await MySqlDBService().runQuery(
      requestType: RequestType.GET,
      url: url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Charset': 'utf-8',
        'token': savedToken,
        'app_version': version,
        'platform': Platform.isAndroid
            ? 'ANDROID'
            : kIsWeb
                ? 'WEB'
                : 'IOS'
      },
    );

    return getResult;
  }

  //Post request
  static Future<Map<String, dynamic>> postApiResult(
      String url, String savedToken, Map<String, String> params) async {
    Map<String, dynamic> postResult = await MySqlDBService().runQuery(
      requestType: RequestType.POST,
      body: params,
      url: url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Charset': 'utf-8',
        'token': savedToken,
        'platform': Platform.isAndroid
            ? 'ANDROID'
            : kIsWeb
                ? 'WEB'
                : 'IOS'
      },
    );

    return postResult;
  }
}
