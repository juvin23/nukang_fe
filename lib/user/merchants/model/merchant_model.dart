// ignore_for_file: unnecessary_this, prefer_collection_literals
import 'package:nukang_fe/shared/province.dart';

class MerchantModel {
  String? merchantId;
  String? merhcantName;
  double? merchantRating;
  String? merchantAddress;
  Province? merchantProvince;
  String? image;
  String? description;
  Category? merchantCategory;

  MerchantModel();

  factory MerchantModel.fromJson(Map<String, dynamic> json) {
    MerchantModel model = MerchantModel();

    model.merhcantName = json['name'];
    model.merchantProvince = json['province'];
    model.merchantRating = json['rating'];
    model.merchantAddress = json['address'];
    model.merchantCategory = json['category'];
    print(json['name'] + "ssssssssssssssssssssssssssssssssss");
    return model;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['merchantId'] = this.merchantId;
    data['merhcantName'] = this.merhcantName;
    data['merchantRating'] = this.merchantRating;
    data['merchantAddress'] = this.merchantAddress;
    if (this.merchantProvince != null) {
      data['merchantProvince'] = this.merchantProvince!.toJson();
    }
    data['image'] = this.image;
    data['category'] = this.merchantCategory;
    return data;
  }

  String getRating() {
    return merchantRating?.toStringAsFixed(1) ?? "0.0";
  }
}

class Category {
  String? categoryId;
  String? categoryName;
}
