class CategoryModel {
  final String name;
  final String id;

  factory CategoryModel.fromJson(Map<String, dynamic> e) {
    return CategoryModel(e['categoryName'], e['categoryId']);
  }

  CategoryModel(this.name, this.id);
  toJson() {
    Map<String, dynamic> cat = {};
    cat.putIfAbsent("categoryName", () => name);
    cat.putIfAbsent("categoryId", () => id);

    Map<String, dynamic> ret = {};
    ret.putIfAbsent("category", () => cat);
    return ret;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryModel &&
          runtimeType == other.runtimeType &&
          (id == other.id || name == other.name);
}
