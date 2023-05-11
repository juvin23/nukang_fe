import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:nukang_fe/environment.dart';
import 'package:nukang_fe/helper/helper.dart';
import 'package:nukang_fe/helper/http_helper.dart';

class RatingService {
  static RatingService? ratingService;
  String endpoint = "api/v1/rating";

  static RatingService getInstance() {
    return ratingService ??= RatingService();
  }

  Future<Response> giveRating(Map<String, String> requestModel) async {
    Uri uri = Uri.https(Environment.apiUrl, '/api/v1/rating');
    try {
      Response response = await HttpHelper.post(uri, requestModel);

      if (response.statusCode == 200) {
        return response;
      } else {
        throw "";
      }
    } catch (e) {
      log(e.toString());
      Helper.toast("terjadi kesalahan. silahkan coba lagi.", 250,
          MotionToastPosition.top, 300);
      return Response("terjadi kesalahan. silahkan coba lagi.", 500);
    }
  }

  Future<List<RatingModel>> getRating(
      String transactionId, String merchantId) async {
    Map<String, String> param = {};
    transactionId == ""
        ? param = {"merchantId": merchantId}
        : param = {"transactionId": transactionId};
    Uri uri = Uri.https(Environment.apiUrl, '/api/v1/rating', param);
    try {
      Response response = await HttpHelper.get(uri);
      Iterable it = jsonDecode(response.body)['content'];
      List<RatingModel> results = [];
      results = it
          .map(
            (e) => RatingModel.fromJson(e),
          )
          .toList();
      if (response.statusCode == 200) {
        return results;
      } else {
        throw "";
      }
    } catch (e) {
      log(e.toString());
      Helper.toast("terjadi kesalahan. silahkan coba lagi.", 250,
          MotionToastPosition.top, 300);
      return [];
    }
  }
}

// {"id":"3648d06eeb6b47f4b6fe25a7d3f51316","rating":5,"review":"Mantap Kang Ace kerjanya cepat detail dan bersih. datang tepat waktu. JOSS","merchantId":"c400a88f400845559a8b2363aa578a4f","transactionId":"d18deda267014c18b39151b48fab57a7","createdBy":null,"createDate":null}
class RatingModel {
  double? rating;
  String? review;
  String? transactionId;
  String? merchantId;

  RatingModel.fromJson(Map<String, dynamic> e) {
    rating = double.parse(e['rating'].toString());
    review = e['review'];
    // print("SAMPE SINI");
    transactionId = e['transactionId'];
  }
}
