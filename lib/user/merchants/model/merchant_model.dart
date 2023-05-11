// ignore_for_file: unnecessary_this, prefer_collection_literals
import 'dart:convert';
import 'dart:math';

import 'package:nukang_fe/core.dart';
import 'package:nukang_fe/shared/category_model.dart';
import 'package:nukang_fe/shared/province.dart';

class MerchantModel {
  String? merchantId;
  String? merchantName;
  double? merchantRating;
  String? merchantAddress;
  String? number;
  Province? merchantProvince;
  String? description;
  List<MerchantCategories>? category;
  City? merchantCity;
  int? merchantRatingCount;

  MerchantModel();

  // {
  //           "createdBy": "System",
  //           "editedBy": null,
  //           "createdOn": [
  //               2023,5,2,0,48,1
  //           ],
  //           "editedOn": null,
  //           "status": "created",
  //           "merchantId": "c400a88f400845559a8b2363aa578a4f",
  //           "name": "Kang Ace",
  //           "description": "Menyediakan jasa service dan cuci AC untuk daerah Jakarta.",
  //           "email": null,
  //           "number": "0878454812",
  //           "address": "Jl. Keramat jati no 12",
  //           "cityCode": "0011",
  //           "rating": 5.0,
  //           "provinceCode": "001",
  //           "province": {
  //               "provinceCode": "001",
  //               "provinceName": "JAKARTA"
  //           },
  //           "city": {
  //               "cityCode": "0011",
  //               "cityName": "JAKARTA BARAT"
  //           },
  //           "lastLogin": null,
  //           "merchantCategory": null,
  //           "category": [
  //               {
  //                   "categoryId": "002",
  //                   "category": {
  //                       "categoryId": "002",
  //                       "categoryName": "Service Apartment"
  //                   }
  //               },
  //               {
  //                   "categoryId": "001",
  //                   "category": {
  //                       "categoryId": "001",
  //                       "categoryName": "Service Rumah"
  //                   }
  //               }
  //           ]
  //       },

  factory MerchantModel.fromJson(Map<String, dynamic> json) {
    MerchantModel model = MerchantModel();
    model.merchantId = json['merchantId'];
    model.merchantName = json['name'];
    model.merchantProvince = Province.fromJson(
        json['province'] ?? {"provinceCode": "001", "provinceName": "Jakarta"});
    model.merchantRating = double.parse(json['rating'].toString());
    model.merchantRatingCount = json['ratingCount'];
    model.merchantAddress = json['address'];
    model.number = json['number'];
    model.description = json['description'] ?? "";
    model.merchantRating = json['rating'] ?? 0.0;
    Iterable cat = json['category'];
    model.category = cat.map((e) => MerchantCategories.fromJson(e)).toList();
    model.merchantCity = City.fromJson(json['city']);
    return model;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['merchantId'] = this.merchantId;
    data['merhcantName'] = this.merchantName;
    data['merchantRating'] = this.merchantRating;
    data['merchantAddress'] = this.merchantAddress;
    if (this.merchantProvince != null) {
      data['merchantProvince'] = this.merchantProvince!.toJson();
    }
    data['category'] = this.category;
    return data;
  }

  String getRating() {
    return merchantRating?.toStringAsFixed(1) ?? "0.0";
  }

  int getRatingCount() {
    return merchantRatingCount ?? 0;
  }
}

class MerchantCategories {
  CategoryModel? category;

  MerchantCategories();
  factory MerchantCategories.fromJson(Map<String, dynamic> e) {
    MerchantCategories merchantCategories = MerchantCategories();
    CategoryModel cat = CategoryModel.fromJson(e['category']);
    merchantCategories.category = cat;
    return merchantCategories;
  }
}
