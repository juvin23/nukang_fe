import 'dart:convert';

import 'package:nukang_fe/environment.dart';
import 'package:http/http.dart' as http;

class UserService {
  static UserService? service;
  final apiUrl = Environment.apiUrl;

  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  static UserService getInstance() {
    return service ??= UserService();
  }

  void create(Map<String, dynamic> data) {
    var uri = Uri.http(apiUrl, "/api/v1/users/create");
    http.post(uri, body: json.encode(data), headers: headers);
  }
}
