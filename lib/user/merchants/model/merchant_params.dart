// ignore_for_file: curly_braces_in_flow_control_structures

class MerchantParams {
  String name = "";
  String merchantProvince = "";
  String merchantCategory = "";
  String merchantRatingfrom = "";
  String merchantRatingto = "";
  MerchantParams();
  MerchantParams.create(
      {required this.name,
      required this.merchantProvince,
      required this.merchantCategory,
      required this.merchantRatingfrom,
      required this.merchantRatingto});
  getParam() {
    final map = <String, List<String>>{};

    if (name != "") addValueToMap(map, 'merchantName', name);
    if (merchantProvince != "")
      addValueToMap(map, 'merchantProvince', merchantProvince);
    if (merchantCategory != "")
      addValueToMap(map, 'merchantCategory', merchantCategory);
    if (merchantRatingfrom != "")
      addValueToMap(map, 'merchantRating', merchantRatingfrom);
    if (merchantRatingto != "")
      addValueToMap(map, 'merchantRating', merchantRatingto);

    return map;
  }

  void addValueToMap<K, V>(Map<K, List<V>> map, K key, V value) =>
      map.update(key, (list) => list..add(value), ifAbsent: () => [value]);
}
