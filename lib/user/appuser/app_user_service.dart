import 'dart:convert';

import 'package:nukang_fe/environment.dart';
import 'package:nukang_fe/helper/http_helper.dart';
import 'package:nukang_fe/user/appuser/app_user.dart';
import 'package:http/http.dart' as http;

class AppUserService {
  static AppUserService? service;
  String apiUrl = Environment.apiUrl;

  static AppUserService getInstance() {
    return service ??= AppUserService();
  }

  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    // 'Authorization': ""
  };

  register(Map<String, dynamic> appUser) async {
    var uri = Uri.https(apiUrl, "/api/auth/register");
    http.Response response;
    try {
      response =
          await http.post(uri, body: json.encode(appUser), headers: headers);
      var resBody = jsonDecode(response.body);
      AppUser.role = getRole(resBody);
      AppUser.token = resBody['accessToken'];
      AppUser.userId = resBody['uid'];
    } catch (e) {
      throw "email sudah digunakan";
    }

    if (response.statusCode == 200) {
      return response.body;
    } else {
      print(response.body);
    }
  }

  Future<String> authenticate(Map<String, dynamic> appUser) async {
    var uri = Uri.https(apiUrl, "/api/auth/authenticate");
    http.Response response;
    try {
      response = await HttpHelper.auth(uri, appUser);

      var resBody = jsonDecode(response.body);
      if (resBody['accessToken'] == null) throw "email/kata sandi salah";
      if (resBody['accessToken'].toString().trim() == "") {
        throw "email/kata sandi salah";
      }
      AppUser.token = resBody['accessToken'];
      AppUser.userId = resBody['uid'];
      AppUser.role = getRole(resBody);
    } catch (e) {
      throw e.toString();
    }

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw response.body;
    }
  }

  getRole(resBody) {
    return resBody['role'] == 'merchant' ? Role.merchant : Role.customer;
  }
}
