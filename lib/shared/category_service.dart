import 'dart:convert';

import 'package:nukang_fe/environment.dart';
import 'package:http/http.dart' as http;
import 'package:nukang_fe/shared/category_model.dart';

class CategoryService {
  static CategoryService? service;
  String url = Environment.apiUrl;

  static getInstance() {
    service ??= CategoryService();
    return service;
  }

  Future<List<CategoryModel>> getAll() async {
    var uri = Uri.http(url, "/api/v1/category");
    List<CategoryModel> category = [];

    var response = await http.get(uri);
    Iterable it = jsonDecode(response.body);
    category = it.map((e) => CategoryModel.fromJson(e)).toList();

    return Future.value(category);
  }
}
