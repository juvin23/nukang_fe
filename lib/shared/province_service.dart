import 'dart:convert';

import 'package:nukang_fe/environment.dart';
import 'package:nukang_fe/helper/http_helper.dart';
import 'package:nukang_fe/shared/province.dart';
import 'package:http/http.dart' as http;

class ProvinceService {
  static ProvinceService? service;
  final url = Environment.apiUrl;

  Future<List<Province>> getProvinces() async {
    var uri = Uri.https(url, "/api/v1/mst/province");
    List<Province> provinces = [];

    http.Response response = await HttpHelper.get(uri);
    if (response.statusCode == 200) {
      Iterable it = jsonDecode(response.body);
      provinces = it.map((e) => Province.fromJson(e)).toList();
      provinces.removeWhere((element) =>
          element.provinceCode == null || element.provinceName == null);
    } else if (response.statusCode == 404) {
      throw "URL NOT FOUND";
    } else if (response.statusCode == 403) {
      throw "UNAUTHENTICATED";
    }
    return Future.value(provinces);
  }

  static getInstance() {
    return service ??= ProvinceService();
  }
}
