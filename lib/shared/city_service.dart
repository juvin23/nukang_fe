import 'dart:convert';

import 'package:nukang_fe/environment.dart';
import 'package:nukang_fe/helper/http_helper.dart';
import 'package:nukang_fe/shared/city.dart';
import 'package:http/http.dart' as http;

class CityService {
  final url = Environment.apiUrl;
  static CityService? cityService;

  static getInstance() {
    cityService ??= CityService();
    return cityService;
  }

  Future<List<City>> getCities(String? province) async {
    if (province == null || province == "") province = "0";
    var uri = Uri.https(
      url,
      "/api/v1/mst/cities",
      {"cityCode": province},
    );
    List<City> cities = [];

    var response = await HttpHelper.get(uri);
    Iterable it = jsonDecode(response.body);
    cities = it.map((e) => City.fromJson(e)).toList();

    return Future.value(cities);
  }
}
