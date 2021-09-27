import 'package:flutter/material.dart';

// const primaryColor = Color.fromRGBO(184, 119, 93, 1);
const primaryColor = Color.fromRGBO(131, 84, 66, 1);

const secondaryColor = Color.fromRGBO(255, 205, 159, 1);
const tertiaryColor = Color.fromRGBO(255, 242, 222, 1);
const beigeColor = Color.fromRGBO(255, 242, 222, 1);
const primaryButtonColor = Color.fromRGBO(242, 92, 1, 1);

ThemeData appTheme(BuildContext context) {
  return ThemeData(
    accentColor: primaryColor,
    primaryColor: primaryColor,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          primaryColor,
        ), //button color
        foregroundColor: MaterialStateProperty.all<Color>(
          Color(0xffffffff),
        ),
      ),
    ),
  );
}
