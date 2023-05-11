class Transaction {
  String? transactionId;
  String? customerId;
  String? merchantId;
  DateTime? startDate;
  DateTime? endDate;
  String? province;
  String? address;
  String? city;
  String? recordStatus;
  DateTime? lastUpdate;
  String? updateBy;
  DateTime? createdDate;
  String? deniedReason;
  double? amount;
  int? extraDayCharges;
  String? description;
  bool? isSeen;

  Transaction(
      {this.transactionId,
      this.customerId,
      this.merchantId,
      this.startDate,
      this.endDate,
      this.province,
      this.recordStatus,
      this.lastUpdate,
      this.createdDate,
      this.deniedReason,
      this.amount,
      this.description,
      this.isSeen,
      this.address});

  factory Transaction.fromJson(Map<String, dynamic> json) {
    Transaction trans = Transaction();
    trans.transactionId = json['transactionId'];
    trans.customerId = json['customerId'];
    trans.merchantId = json['merchantId'];
    trans.startDate = DateTime.parse(json['startDate']);
    trans.endDate = DateTime.parse(json['endDate']);
    // print(1);
    trans.province = json['provinceCode'];
    // print(2);
    trans.city = json['cityCode'];
    // print(3);
    trans.recordStatus = json['recordStatus'];
    // print(4);
    String lastUpdate = json['lastUpdated'];
    trans.lastUpdate = DateTime.parse(lastUpdate.replaceAll("T", " "));
    // print(5);
    trans.createdDate = DateTime.parse(json['createdDate']);
    // print(6);
    trans.deniedReason = json['deniedReason'] ?? "";
    // print("DENIED" + trans.deniedReason!);
    trans.amount = json['amount'];
    // print(8);
    trans.description = json['description'];
    trans.address = json['address'];
    // print(9);
    trans.updateBy = json['updateBy'];
    // print(10);
    return trans;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['transactionId'] = transactionId;
    data['customerId'] = customerId;
    data['merchantId'] = merchantId;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['recordStatus'] = recordStatus;
    data['lastUpdate'] = lastUpdate;
    data['createdDate'] = createdDate;
    data['deniedReason'] = deniedReason;
    data['amount'] = amount;
    data['extraDayCharges'] = extraDayCharges;
    data['description'] = description;
    return data;
  }
}
