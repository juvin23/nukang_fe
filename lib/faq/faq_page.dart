// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:nukang_fe/faq/faq_service.dart';
import 'package:nukang_fe/faq/qa_item.dart';
import 'package:nukang_fe/faq/qa_model.dart';
import 'package:nukang_fe/themes/app_theme.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({Key? key}) : super(key: key);

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  late Future<List<QaModel>> _faqs;

  @override
  void initState() {
    _faqs = getFaq();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarOpacity: 0.5,
        backgroundColor: AppTheme.nearlyWhite,
        foregroundColor: AppTheme.dark_grey,
        centerTitle: true,
        title: Text(
          "Bantuan",
          style: AppTheme.headline.copyWith(fontSize: 12),
        ),
        actions: const [],
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(10.0),
            child: FutureBuilder<List<QaModel>>(
              future: _faqs,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Column(
                      children: snapshot.data!
                          .map((e) => QaItem(title: e.tittle!, ans: e.ans!))
                          .toList());
                } else {
                  return Container();
                }
              },
            )),
      ),
    );
  }

  Future<List<QaModel>> getFaq() {
    return FaqService.getInstance().getFaqList();
  }
}
