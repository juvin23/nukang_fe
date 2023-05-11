import 'dart:convert';

import 'package:http/http.dart';
import 'package:nukang_fe/environment.dart';
import 'package:nukang_fe/faq/qa_model.dart';
import 'package:nukang_fe/helper/http_helper.dart';

class FaqService {
  static FaqService? ratingService;
  String endpoint = "api/v1/rating";

  static FaqService getInstance() {
    return ratingService ??= FaqService();
  }

  Future<List<QaModel>> getFaqList() async {
    Uri uri = Uri.https(Environment.apiUrl, "/api/v1/faq");
    Response response = await HttpHelper.get(uri);

    if (response.statusCode == 200) {
      Iterable it = jsonDecode(response.body)['content'];
      List<QaModel> merchantList = [];
      merchantList = it.map((e) => QaModel.fromJson(e)).toList();
      return merchantList;
    } else {}
    return [];
  }
}
