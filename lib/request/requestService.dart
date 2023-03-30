import 'dart:convert';

import 'package:nukang_fe/environment.dart';
import 'package:http/http.dart' as http;

class RequestService {
  String apiUrl = Environment.apiUrl;

  request(Map<String, String> requestModel) async {
    var response = await http.post(
      Uri.http(apiUrl, '/api/v1/transaction/create'),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode(requestModel),
    );
    print(response.body);
  }
}
