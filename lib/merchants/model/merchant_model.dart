// ignore_for_file: unnecessary_this, prefer_collection_literals

class MerchantModel {
  String? merchantId;
  String? merhcantName;
  double? merchantRating;
  String? merchantAddress;
  MerchantProvince? merchantProvince;
  String? imagePath;
  String? description;

  MerchantModel(this.merhcantName, this.merchantRating, this.imagePath);

  MerchantModel.fromJson(Map<String, dynamic> json) {
    merchantId = json['merchantId'];
    merhcantName = json['merhcantName'];
    merchantRating = json['merchantRating'];
    merchantAddress = json['merchantAddress'];
    merchantProvince = json['merchantProvince'] != null
        ? MerchantProvince.fromJson(json['merchantProvince'])
        : null;
    imagePath = json['imagePath'];
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
    data['imagePath'] = this.imagePath;
    return data;
  }

  String getRating() {
    return merchantRating?.toStringAsFixed(1) ?? "0.0";
  }
}

class MerchantProvince {
  String? code;
  String? name;

  MerchantProvince({this.code, this.name});

  MerchantProvince.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    return data;
  }
}
