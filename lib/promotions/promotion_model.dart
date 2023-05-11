class Promotion {
  String? id;
  String? name;
  String? desc;
  DateTime? startDate;
  DateTime? endDate;

  Promotion();

  Promotion.fromJson(e) {
    id = e['id'];
    desc = e['description'];
    name = e['name'];
    startDate = DateTime.parse(e['startDate']);
    endDate = DateTime.parse(e['endDate']);
  }
}
