import 'package:flutter/material.dart';

class AppTheme {
  static const lighterGrey = Color.fromARGB(212, 223, 226, 231);

  static const buttonRed = Color.fromARGB(198, 220, 38, 38);

  static const nearlyBlueText = Color(0xFF00B6F0);

  AppTheme._();

  static const Color notWhite = Color.fromARGB(255, 240, 240, 240);
  static const Color nearlyWhite = Color.fromARGB(255, 255, 255, 255);
  static const Color nearlyBlue = Color(0xFF00B6F0);
  static const Color nearlyBlue05 = Color.fromRGBO(0, 182, 240, 0.5);
  static const Color darkerBlue = Color.fromARGB(255, 16, 124, 160);
  static const Color white = Color(0xFFFFFFFF);
  static const Color nearlyBlack = Color(0xFF213333);
  static const Color grey = Color(0xFF3A5160);
  static const Color dark_grey = Color(0xFF313A44);
  static const Color indigo = Color.fromARGB(255, 82, 49, 125);

  static const Color darkText = Color.fromARGB(255, 16, 25, 29);
  static const Color darkerText = Color(0xFF17262A);
  static const Color lightText = Color(0xFF4A6572);
  static const Color disableText = Color.fromARGB(255, 143, 155, 161);
  static const Color deactivatedText = Color(0xFF767676);
  static const Color dismissibleBackground = Color(0xFF364A54);
  static const Color chipBackground = Color(0xFFEEF1F3);
  static const Color spacer = Color(0xFFF2F2F2);
  static const String fontName = 'WorkSans';

  static const TextTheme textTheme = TextTheme(
    headline4: display1,
    headline5: headline,
    headline6: title,
    subtitle2: subtitle,
    bodyText2: body2,
    bodyText1: body1,
    caption: caption,
  );

  static const TextStyle display1 = TextStyle(
    // h4 -> display1
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 30,
    letterSpacing: 0.4,
    height: 0.9,
    color: darkerText,
  );

  static const TextStyle headline = TextStyle(
    // h5 -> headline
    fontFamily: fontName,
    fontWeight: FontWeight.w300,
    fontSize: 24,
    letterSpacing: 0.27,
    color: darkerText,
  );

  static const TextStyle title = TextStyle(
    // h6 -> title
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: 0.18,
    color: darkerText,
  );

  static const TextStyle subtitle = TextStyle(
    // subtitle2 -> subtitle
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: -0.04,
    color: darkText,
  );

  static const TextStyle body2 = TextStyle(
    // body1 -> body2
    fontFamily: fontName,
    fontWeight: FontWeight.w500,
    fontSize: 15,
    letterSpacing: 0.2,
    color: darkText,
  );

  static const TextStyle body1 = TextStyle(
    // body2 -> body1
    fontFamily: fontName,
    fontWeight: FontWeight.w700,
    fontSize: 16,
    letterSpacing: -0.05,
    color: darkText,
  );

  static const TextStyle caption = TextStyle(
    // Caption -> caption
    fontFamily: fontName,
    fontWeight: FontWeight.w500,
    fontSize: 15,
    letterSpacing: 0.2,
    color: darkText, // was lightText
  );

  static const captionDisabled = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w500,
    fontSize: 15,
    letterSpacing: 0.2,
    color: disableText, // was lightText
  );

  static const buttonTextM = TextStyle(
    // body1 -> body2
    fontFamily: fontName,
    fontWeight: FontWeight.w500,
    fontSize: 15,
    letterSpacing: 0.2,
    color: lighterGrey,
  );

  static const buttonTextDarkM = TextStyle(
    // body1 -> body2
    fontFamily: fontName,
    fontWeight: FontWeight.w500,
    fontSize: 15,
    letterSpacing: 0.2,
    color: darkText,
  );
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
