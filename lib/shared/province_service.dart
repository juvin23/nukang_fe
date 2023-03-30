import 'dart:convert';

import 'package:nukang_fe/environment.dart';
import 'package:nukang_fe/shared/province.dart';
import 'package:http/http.dart' as http;

class ProvinceService {
  static ProvinceService? service;
  final url = Environment.apiUrl;

  Future<List<Province>> getProvinces() async {
    var uri = Uri.http(url, "/api/v1/provinces");
    List<Province> provinces = [];

    var response = await http.get(uri);
    Iterable it = jsonDecode(response.body);
    provinces = it.map((e) => Province.fromJson(e)).toList();
    return Future.value(provinces);
  }

  static getInstance() {
    return service ??= ProvinceService();
  }
}
