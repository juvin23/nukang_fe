import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:nukang_fe/environment.dart';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:nukang_fe/helper/http_helper.dart';
import 'package:nukang_fe/user/merchants/model/merchant_model.dart';
import 'package:nukang_fe/user/merchants/model/merchant_params.dart';

class MerchantService {
  static MerchantService? service;
  String apiUrl = Environment.apiUrl;

  getMerchants(MerchantParams params) async {
    Uri uri = Uri.https(apiUrl, "/api/v1/merchants", params.getParam());
    var response = await HttpHelper.get(uri);
    if (response.statusCode != 200) {
      print(response.statusCode);
      print(response.body);
    }
    Iterable it = jsonDecode(response.body)['content'];

    List<MerchantModel> merchantList = [];
    merchantList = it.map((e) => MerchantModel.fromJson(e)).toList();

    return merchantList;
  }

  Future<List<MerchantModel>> getMerchantsByName(String name) async {
    var uri = Uri.https(apiUrl, "/api/v1/merchants", {"name": name});
    List<MerchantModel> merchantList = [];
    var response = await HttpHelper.get(uri);

    Iterable it = jsonDecode(response.body)['content'];
    log(json.decode(response.body)['content'].toString());
    merchantList = it.map((e) => MerchantModel.fromJson(e)).toList();
    // log(jsonDecode(response.body)['content'].toString());
    return merchantList;
  }

  Future<MerchantModel> getMerchantById(id) async {
    var uri = Uri.https(apiUrl, "/api/v1/merchants/$id");

    var response = await HttpHelper.get(uri);
    print(response.body);
    MerchantModel merchant = MerchantModel.fromJson(jsonDecode(response.body));
    return merchant;
  }

  static MerchantService getInstance() {
    return service ??= MerchantService();
  }

  Future<MerchantModel> create(Map<String, dynamic> data) async {
    var uri = Uri.https(apiUrl, "/api/v1/merchants/create");
    http.Response resp = await HttpHelper.post(uri, data);
    if (resp.statusCode != 200) {
      throw "Terjadi kesalahan. coba lagi";
    }

    return MerchantModel.fromJson(jsonDecode(resp.body));
    // print(jsonDecode(resp.body)['merchantId'].toString());
  }

  update(Map<String, String> data) async {
    Uri uri = Uri.https(apiUrl, "/api/v1/merchants/update");
    try {
      http.Response res = await HttpHelper.post(uri, data);
      if (res.statusCode == 200) {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }
}
