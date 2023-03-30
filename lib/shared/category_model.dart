class CategoryModel {
  String? name;
  String? id;

  CategoryModel.fromJson(e) {
    name = e['categoryName'];
    id = e['categoryId'];
  }
  toJson() {
    Map<String, String> ret = {};
    // print(name ?? "");
    // print(id ?? "");
    ret.putIfAbsent("categoryName", () => name!);
    ret.putIfAbsent("categoryId", () => id!);
    return ret;
  }
}
