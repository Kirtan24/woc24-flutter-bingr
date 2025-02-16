import 'package:flutter/material.dart';

class BAppTheme {
  BAppTheme._();

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    hintColor: Colors.grey,
    primaryColor: const Color.fromARGB(255, 245, 71, 32),
    iconTheme: IconThemeData(color: Colors.white),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        iconColor: WidgetStateProperty.all(Colors.white),
      ),
    ),
    appBarTheme: AppBarTheme(
      color: Colors.black,
      actionsIconTheme: IconThemeData(
        color: const Color.fromARGB(255, 245, 71, 32),
      ),
    ),
    scaffoldBackgroundColor: Colors.black,
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: const Color.fromARGB(255, 245, 71, 32),
    hintColor: Colors.black,
    iconTheme: IconThemeData(color: Colors.black),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        iconColor: WidgetStateProperty.all(Colors.black),
      ),
    ),
    appBarTheme: AppBarTheme(
      color: Colors.white,
      actionsIconTheme: IconThemeData(
        color: const Color.fromARGB(255, 245, 71, 32),
      ),
    ),
    scaffoldBackgroundColor: Colors.white,
  );
}
