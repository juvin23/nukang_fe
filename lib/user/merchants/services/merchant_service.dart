import 'dart:convert';

import 'package:nukang_fe/environment.dart';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:nukang_fe/user/merchants/model/merchant_model.dart';
import 'package:nukang_fe/user/merchants/model/merchant_params.dart';

class MerchantService {
  static MerchantService? service;
  String apiUrl = Environment.apiUrl;
  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  getMerchants(MerchantParams params) async {
    var uri = Uri.http(apiUrl, "/api/v1/merchants", params.getParam());
    List<MerchantModel> merchantList = [];
    var response = await http.get(uri);
    Iterable it = jsonDecode(response.body)['content'];
    print(it);
    merchantList = it.map((e) => MerchantModel.fromJson(e)).toList();
    // log(jsonDecode(response.body)['content'].toString());
    return merchantList;
  }

  getMerchantsByName(String name) async {
    var uri = Uri.http(apiUrl, "/api/v1/merchants", {"name": name});
    List<MerchantModel> merchantList = [];
    var response = await http.get(uri);

    Iterable it = jsonDecode(response.body)['content'];
    // print(json.decode(response.body)['content']);
    merchantList = it.map((e) => MerchantModel.fromJson(e)).toList();
    log(jsonDecode(response.body)['content'].toString());
    return merchantList;
  }

  static MerchantService getInstance() {
    return service ??= MerchantService();
  }

  create(Map<String, dynamic> data) {
    var uri = Uri.http(apiUrl, "/api/v1/merchants/create");
    var resp = http.post(uri, body: json.encode(data), headers: headers);
    // print(jsonDecode(resp.body)['merchantId'].toString());
  }

  String getMerchantProfileImage(String? merchantId) {
    return "$apiUrl/api/v1/get-profile-image/$merchantId";
  }
}
