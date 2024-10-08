import 'dart:developer';

class City {
  String? cityCode;
  String? cityName;

  City({this.cityCode, this.cityName});

  City.fromJson(e) {
    cityCode = e['cityCode'];
    cityName = e['cityName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cityCode'] = cityCode;
    data['cityName'] = cityName;
    return data;
  }
}
