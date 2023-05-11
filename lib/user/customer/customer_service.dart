import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:nukang_fe/environment.dart';
import 'package:http/http.dart' as http;
import 'package:nukang_fe/helper/http_helper.dart';
import 'package:nukang_fe/user/customer/customer_model.dart';

class CustomerService {
  static CustomerService? service;
  final apiUrl = Environment.apiUrl;

  static CustomerService getInstance() {
    return service ??= CustomerService();
  }

  Future<bool> create(Map<String, dynamic> data) async {
    Uri uri = Uri.https(apiUrl, "/api/v1/customer/create");
    print(uri.toString());
    try {
      Response res = await HttpHelper.post(uri, data);
      if (res.statusCode == 200) {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  Future<CustomerModel> getCustomerById(id) async {
    var uri = Uri.https(apiUrl, "/api/v1/customer/$id");
    try {
      Response res = await HttpHelper.get(uri);
      return CustomerModel.fromJson(jsonDecode(res.body));
    } catch (e) {
      log(e.toString());
      throw "terjadi kesalahan coba lagi.";
    }
  }

  update(Map<String, String> data) async {
    Uri uri = Uri.https(apiUrl, "/api/v1/customer/update");
    try {
      Response res = await HttpHelper.post(uri, data);
      if (res.statusCode == 200) {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }
}
