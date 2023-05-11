class Province {
  String? provinceCode;
  String? provinceName;

  Province({this.provinceCode, this.provinceName});

  Province.fromJson(Map<String, dynamic> json) {
    // print(json);
    provinceCode = json['provinceCode'];
    provinceName = json['provinceName'];
    print(provinceCode);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['provinceCode'] = provinceCode;
    data['provinceName'] = provinceName;
    return data;
  }
}
