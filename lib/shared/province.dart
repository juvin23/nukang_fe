class Province {
  String? provinceCode;
  String? provinceName;

  Province({this.provinceCode, this.provinceName});

  Province.fromJson(json) {
    provinceCode = json['provinceCode'];
    provinceName = json['provinceName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['provinceCode'] = provinceCode;
    data['provinceName'] = provinceName;
    return data;
  }
}
