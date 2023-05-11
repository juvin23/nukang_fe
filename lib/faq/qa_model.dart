class QaModel {
  String? ans;
  String? tittle;

  QaModel({this.ans, this.tittle});

  QaModel.fromJson(e) {
    ans = e['answer'];
    tittle = e['question'];
  }
}
