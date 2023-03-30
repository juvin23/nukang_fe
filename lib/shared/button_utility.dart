import 'package:flutter/material.dart';

class ButtonUtility {
  static moveToPage(Widget param, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => param),
    );
  }
}
