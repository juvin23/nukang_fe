// ignore_for_file: curly_braces_in_flow_control_structures

class MerchantParams {
  String name = "";
  String merchantProvince = "";
  String merchantCategory = "";
  String merchantRating = "";
  MerchantParams();

  factory MerchantParams.of(String prop, String val) {
    MerchantParams params = MerchantParams();
    switch (prop) {
      case "name":
        params.name = val;
        break;
      case "category":
        params.merchantCategory = val;
        break;
      case "merchantProvince":
        params.merchantProvince = val;
        break;
      case "merchantRating":
        params.merchantRating = val;
    }

    return params;
  }

  MerchantParams.create(
      {required this.name,
      required this.merchantProvince,
      required this.merchantCategory,
      required this.merchantRating});
  getParam() {
    var map = <String, String>{};

    if (name != "") addValueToMap(map, 'merchantName', name);
    if (merchantProvince != "")
      addValueToMap(map, 'merchantProvince', merchantProvince);
    if (merchantCategory != "")
      addValueToMap(map, 'findCategory', merchantCategory);
    if (merchantRating != "")
      addValueToMap(map, 'merchantRating', merchantRating);

    addValueToMap(map, 'sort', 'rating,desc');
    return map;
  }

  void addValueToMap<K, V>(Map<K, V> map, K key, V value) =>
      map.update(key, (curr) => curr = value, ifAbsent: () => value);
}
