import 'package:flutter/material.dart';
import 'package:nukang_fe/themes/app_theme.dart';

class QaItem extends StatelessWidget {
  const QaItem({
    Key? key,
    required this.title,
    required this.ans,
  }) : super(key: key);

  final String title;

  final String ans;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: AppTheme.white,
          border: Border.all()),
      child: ExpansionTile(
        title: Text(
          title,
          style: AppTheme.body1,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              ans,
              style: AppTheme.body2,
            ),
          )
        ],
      ),
    );
  }
}
