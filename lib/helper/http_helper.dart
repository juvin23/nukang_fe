import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nukang_fe/authentication/login_page.dart';
import 'package:nukang_fe/helper/helper.dart';
import 'package:nukang_fe/user/appuser/app_user.dart';

class HttpHelper {
  static Future<http.Response> get(uri) async {
    log("REQUEST BEGIN");
    log("---------------------------------");
    log(uri.toString());
    log(uri.queryParametersAll.toString());
    log("---------------------------------");
    log("REQUEST END");

    http.Response res = await http.get(uri, headers: getHeader());
    log("Status    : ${res.statusCode}");

    if (res.statusCode == 200) {
      log("RESPONSE BEGIN");
      log("---------------------------------");
      log(res.body);
      log("---------------------------------");
      log("RESPONSE END");
      return res;
    }
    if (res.statusCode == 403 || res.statusCode == 401) {
      Helper.logout();
    }

    throw "Terjadi kesalahan coba lagi.";
  }

  static Future<Response> dioPost(String url, formData) async {
    Dio dio = new Dio();
    dio.options.headers["Authorization"] = "Bearer ${AppUser.token}";
    print(dio.options.headers);
    Response response = await dio.post(
      url,
      data: formData,
      options: Options(
        headers: <String, String>{
          'Authorization': 'Bearer ${AppUser.token}',
        },
      ),
    );
    print(response);

    return response;
  }

  static Future<http.Response> post(Uri uri, Map<String, dynamic> data) async {
    log("REQUEST BEGIN");
    log("---------------------------------");
    log(uri.toString());
    log(uri.queryParametersAll.toString());
    log("---------------------------------");
    log("REQUEST END");
    http.Response res =
        await http.post(uri, body: json.encode(data), headers: getPostHeader());
    log("Status    : ${res.statusCode}");
    if (res.statusCode == 200) {
      log("RESPONSE BEGIN");
      log("---------------------------------");
      log(res.body);
      log("---------------------------------");
      log("RESPONSE END");
      return res;
    }
    if (res.statusCode == 403 || res.statusCode == 401) {
      Helper.logout();
    }
    throw "Terjadi kesalahan coba lagi.";
  }

  static Future<http.Response> auth(Uri uri, Map<String, dynamic> data) async {
    log("REQUEST BEGIN");
    log("---------------------------------");
    log(uri.toString());
    log(uri.queryParametersAll.toString());
    log("---------------------------------");
    log("REQUEST END");
    http.Response res = await http.post(uri, body: json.encode(data), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    });
    log("Status    : ${res.statusCode}");
    if (res.statusCode == 200) {
      log("RESPONSE BEGIN");
      log("---------------------------------");
      log(res.body);
      log("---------------------------------");
      log("RESPONSE END");
      return res;
    }
    if (res.statusCode == 403 || res.statusCode == 401) {
      Helper.logout();
    }
    throw "Terjadi kesalahan coba lagi.";
  }

  static Future<http.Response> put(Uri uri) async {
    log("REQUEST BEGIN");
    log("---------------------------------");
    log(uri.toString());
    log(uri.queryParametersAll.toString());
    log("---------------------------------");
    log("REQUEST END");
    http.Response res = await http.put(uri, headers: getPostHeader());
    log("Status    : ${res.statusCode}");
    if (res.statusCode == 200) {
      log("RESPONSE BEGIN");
      log("---------------------------------");
      log(res.body);
      log("---------------------------------");
      log("RESPONSE END");
      return res;
    }
    if (res.statusCode == 403 || res.statusCode == 401) {
      Helper.logout();
    }
    throw "Terjadi kesalahan coba lagi.";
  }

  static Future<http.Response> putWithBody(
      Uri uri, Map<String, dynamic> data) async {
    log("REQUEST BEGIN");
    log("---------------------------------");
    log(uri.toString());
    log(uri.queryParametersAll.toString());
    log("---------------------------------");
    log("REQUEST END");
    http.Response res =
        await http.put(uri, headers: getPostHeader(), body: data);
    log("Status    : ${res.statusCode}");
    if (res.statusCode == 200) {
      log("RESPONSE BEGIN");
      log("---------------------------------");
      log(res.body);
      log("---------------------------------");
      log("RESPONSE END");
      return res;
    }
    if (res.statusCode == 403 || res.statusCode == 401) {
      Helper.logout();
    }
    throw "Terjadi kesalahan coba lagi.";
  }

  static getHeader() {
    Map<String, String> header = (AppUser.token != "" && AppUser.token != null)
        ? {
            'Authorization': 'Bearer ${AppUser.token}',
          }
        : {};
    return header;
  }

  static getPostHeader() {
    return {
      'Authorization': 'Bearer ${AppUser.token}',
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
  }
}
