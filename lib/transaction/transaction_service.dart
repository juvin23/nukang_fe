import 'dart:convert';

import 'package:http/http.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:nukang_fe/environment.dart';
import 'package:nukang_fe/helper/helper.dart';
import 'package:nukang_fe/helper/http_helper.dart';
import 'package:nukang_fe/transaction/transaction_model.dart';
import 'package:nukang_fe/transaction/work_list.dart';
import 'package:nukang_fe/user/appuser/app_user.dart';

class TransactionService {
  String apiUrl = Environment.apiUrl;
  static TransactionService? transactionService;

  static TransactionService getInstance() {
    return transactionService ??= TransactionService();
  }

  Future<List<Transaction>> getList() async {
    Map<String, dynamic> data = {
      "customerId": AppUser.userId,
      "sort": "lastUpdated,desc"
    };

    Uri uri = Uri.https(apiUrl, "/api/v1/transaction", data);
    Response response = await HttpHelper.get(uri);

    if (response.statusCode == 200) {
      Iterable it = jsonDecode(response.body)['content'];
      List<Transaction> transactionList = [];
      transactionList = it.map((e) => Transaction.fromJson(e)).toList();
      return transactionList;
    } else {}
    return [];
  }

  Future<List<Transaction>> getPekerjaanList() async {
    Map<String, dynamic> data = {
      "merchantId": AppUser.userId,
      "sort": "lastUpdated,desc"
    };

    Uri uri = Uri.https(apiUrl, "/api/v1/transaction", data);
    Response response = await HttpHelper.get(uri);

    if (response.statusCode == 200) {
      Iterable it = jsonDecode(response.body)['content'];
      List<Transaction> merchantList = [];
      merchantList = it.map((e) => Transaction.fromJson(e)).toList();
      return merchantList;
    } else {}
    return [];
  }

  Future<bool> clearNotification() async {
    Uri uri = Uri.https(Environment.apiUrl, 'api/v1/transaction/clear-notif');
    Response response = await HttpHelper.put(uri);
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<Response> request(Map<String, String> requestModel) async {
    Response response;
    try {
      response = await HttpHelper.post(
          Uri.https(apiUrl, '/api/v1/transaction/create'), requestModel);
    } catch (err) {
      rethrow;
    }
    return response;
  }

  Future<Response> requestPrice(id, amount, startdate, enddate) async {
    Response response;
    try {
      response = await HttpHelper.put(
        Uri.https(
          apiUrl,
          '/api/v1/transaction/request-price/$id',
          {
            "amount": amount,
            "startdate": startdate.toString(),
            "enddate": enddate.toString(),
          },
        ),
      );
    } catch (err) {
      rethrow;
    }
    return response;
  }

  Future<Response> approvePrice(id) async {
    Response response;
    try {
      response = await HttpHelper.put(
          Uri.https(apiUrl, '/api/v1/transaction/approve/$id'));
    } catch (err) {
      rethrow;
    }
    return response;
  }

  update(Map<String, String> transaction) async {
    var response;
    try {
      response = await HttpHelper.post(
          Uri.https(apiUrl, '/api/v1/transaction/update'), transaction);
    } catch (err) {
      rethrow;
    }
    return response;
  }

  Future<Response> reject(String reason, String id) async {
    var response;
    try {
      response = await HttpHelper.put(
        Uri.https(
          apiUrl,
          '/api/v1/transaction/reject/$id',
          {"reason": reason},
        ),
      );
    } catch (err) {
      rethrow;
    }
    return response;
  }

  Future<Response> cancel(String reason, String id) async {
    var response;
    try {
      response = await HttpHelper.put(
        Uri.https(
          apiUrl,
          '/api/v1/transaction/cancel/$id',
          {"reason": reason},
        ),
      );
    } catch (err) {
      rethrow;
    }
    return response;
  }

  Future<Response> approve(String? transactionId) async {
    var response;
    try {
      response = await HttpHelper.put(
        Uri.https(apiUrl, '/api/v1/transaction/approve/$transactionId'),
      );
    } catch (err) {
      rethrow;
    }
    return response;
  }

  Future<int> getNotificationCount() async {
    Map<String, dynamic> cus = {
      "customerId": AppUser.userId,
      "isSeen": "1",
    };

    Map<String, dynamic> mch = {
      "merchantId": AppUser.userId,
      "isSeen": "2",
    };

    Uri uri = Uri.https(apiUrl, "/api/v1/transaction",
        AppUser.role == Role.customer ? cus : mch);
    Response response = await HttpHelper.get(uri);
    if (response.statusCode == 200) {
      Iterable it = jsonDecode(response.body)['content'];
      List<Transaction> transactionList = [];
      transactionList = it.map((e) => Transaction.fromJson(e)).toList();
      return transactionList.length;
    } else {}
    return 0;
  }

  Future<TransactionCount> count() async {
    Response response = await HttpHelper.get(
        Uri.https(apiUrl, "/api/v1/transaction/count/${AppUser.userId}"));
    TransactionCount transactionCount = TransactionCount();
    if (response.statusCode == 200) {
      transactionCount = TransactionCount.fromJson(jsonDecode(response.body));
    }
    return transactionCount;
  }
}
