import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    primaryColor: Color(0xFF8f96dd),
    primaryColorBrightness: Brightness.light,
    accentColor: Color(0xFFDDE2EC),
    accentColorBrightness: Brightness.light,
    highlightColor: Color(0xFF8F96DD),
    indicatorColor: Color(0xFF8F96DD),
    errorColor: Color(0xFFdd8f8f),
    scaffoldBackgroundColor: Colors.white,
    backgroundColor: Color(0xFFf5f6fa),
    appBarTheme: AppBarTheme(
      color: Color(0xFFdde2ec),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Color(0xFFdde2ec),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    primaryTextTheme: TextTheme(
      headline6: TextStyle(
        color: Color(0xFF252F3D),
        fontFamily: 'Quicksand',
        fontWeight: FontWeight.w600,
        fontSize: 24,
      ),
    ),
    textTheme: TextTheme(
      // Body Title
      bodyText1: TextStyle(
        fontFamily: 'Quicksand',
        fontWeight: FontWeight.w600,
        fontSize: 18,
        color: Color(0xFF373A49),
      ),
      // Body Content
      bodyText2: TextStyle(
        fontFamily: 'Quicksand',
        fontWeight: FontWeight.w500,
        fontSize: 16,
        color: Color(0xFF373A49),
      ),
      // Button Text
      button: TextStyle(
        fontFamily: 'Quicksand',
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: Color(0xFF373A49),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: Color(0xFF8f96dd),
    primaryColorBrightness: Brightness.dark,
    accentColor: Color(0xFFDDE2EC),
    accentColorBrightness: Brightness.dark,
    highlightColor: Color(0xFF8F96DD),
    indicatorColor: Color(0xFF8F96DD),
    errorColor: Color(0xFFdd8f8f),
    scaffoldBackgroundColor: Color(0xFF373a49),
    backgroundColor: Color(0xFF373a49),
    appBarTheme: AppBarTheme(
      color: Color(0xFF373a49),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
    ),
    buttonColor: Color(0xFFdde2ec),
    buttonTheme: ButtonThemeData(
      buttonColor: Color(0xFFdde2ec),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    primaryTextTheme: TextTheme(
      headline6: TextStyle(
        color: Color(0xFFdde2ec),
        fontFamily: 'Quicksand',
        fontWeight: FontWeight.w600,
        fontSize: 24,
      ),
    ),
    textTheme: TextTheme(
      // Body Title
      bodyText1: TextStyle(
        fontFamily: 'Quicksand',
        fontWeight: FontWeight.w600,
        fontSize: 18,
        color: Color(0xFFdde2ec),
      ),
      // Body Content
      bodyText2: TextStyle(
        fontFamily: 'Quicksand',
        fontWeight: FontWeight.w500,
        fontSize: 16,
        color: Color(0xFFdde2ec),
      ),
      // Button Text
      button: TextStyle(
        fontFamily: 'Quicksand',
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: Color(0xFF373A49),
      ),
    ),
  );
}
