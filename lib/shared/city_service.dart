import 'dart:convert';

import 'package:nukang_fe/environment.dart';
import 'package:nukang_fe/shared/city.dart';
import 'package:http/http.dart' as http;

class CityService {
  final url = Environment.apiUrl;

  Future<List<City>> getCities() async {
    var uri = Uri.http(url, "/api/v1/cities");
    List<City> cities = [];

    var response = await http.get(uri);
    Iterable it = jsonDecode(response.body);
    cities = it.map((e) => City.fromJson(e)).toList();

    return Future.value(cities);
  }
}
