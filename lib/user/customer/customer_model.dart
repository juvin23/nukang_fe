import 'dart:convert';

import 'package:nukang_fe/core.dart';
import 'package:nukang_fe/shared/province.dart';

class CustomerModel {
  String? name;
  String? address;
  Province? province;
  String? number;
  String? email;
  City? city;
  DateTime? birthdate;

  CustomerModel();

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    CustomerModel model = CustomerModel();
    print(1);
    model.name = json['name'];
    print(2);
    model.province = Province.fromJson(json['province']);
    print(3);
    model.address = json['address'];
    model.number = json['number'];
    model.email = json['email'];
    model.city = City.fromJson(json['city']);
    model.birthdate = DateTime.parse(json['birthdate']);
    return model;
  }
}
