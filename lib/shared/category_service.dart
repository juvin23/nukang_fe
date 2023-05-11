import 'dart:convert';
import 'package:nukang_fe/environment.dart';
import 'package:nukang_fe/helper/http_helper.dart';
import 'package:nukang_fe/shared/category_model.dart';

class CategoryService {
  static CategoryService? service;
  String url = Environment.apiUrl;

  static getInstance() {
    service ??= CategoryService();
    return service;
  }

  Future<List<CategoryModel>> getAll() async {
    var uri = Uri.https(url, "/api/v1/mst/category");
    List<CategoryModel> category = [];

    var response = await HttpHelper.get(uri);
    Iterable it = jsonDecode(response.body);
    category = it.map((e) => CategoryModel.fromJson(e)).toList();

    return category;
  }
}
