import 'dart:convert';

import 'package:nukang_fe/shared/province.dart';

class UserModel {
  String? name;
  String? address;
  Province? province;
  String? phoneNo;
  String? email;

  UserModel();

  factory UserModel.fromJson(Map<String, dynamic> json) {
    UserModel model = UserModel();

    model.name = json['name'];
    model.province = json['province'];
    model.address = json['address'];
    model.phoneNo = json['phoneNo'];
    model.email = json['email'];
    return model;
  }
}
