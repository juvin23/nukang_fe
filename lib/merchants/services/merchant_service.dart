import 'dart:math';

import 'package:nukang_fe/merchants/model/merchant_model.dart';

class MerchantService {
  String url = 'http:/localhost:8080/api/v1/user';
  Future<List<MerchantModel>> getMerchants() async {
    Future.delayed(const Duration(milliseconds: 1500));
    var merchantList = <MerchantModel>[];
    for (int i = 0; i < 5; i++) {
      merchantList.add(
        MerchantModel("merchant${i + 1}", Random().nextDouble() * 5.0,
            'merchants/merchant${i + 1}.png'),
      );
    }
    return merchantList;
  }
}
