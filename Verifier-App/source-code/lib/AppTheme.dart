import 'package:flutter/material.dart';

class AppTheme {
  //
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: false,
    scaffoldBackgroundColor: const Color(0xffaec2eb),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xff05205a),
      elevation: 5,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      titleTextStyle: TextStyle(
        fontSize: 21,
        color: Colors.white,
        fontWeight: FontWeight.w400,
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: Color(0xffaec2eb),
      onPrimary: Color(0xffaec2eb),
      secondary: Colors.red,
    ),
    cardTheme: const CardTheme(
      color: Colors.indigo,
    ),
    iconTheme: const IconThemeData(
      color: Colors.white54,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        backgroundColor: const Color(0xFF00143e),
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 23,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: const TextStyle(
        fontSize: 20,
        color: Color(0xFF00143e),
        //fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
      ),
      helperStyle: TextStyle(
        fontSize: 16,
        color: const Color(0xFF00143e).withOpacity(0.6),
        fontStyle: FontStyle.italic,
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF00143e),),
      ),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Color(0xFF00143e),
      selectionColor: Colors.white,
      selectionHandleColor: Color(0xFF00143e),
    ),
    textTheme: TextTheme(
      titleLarge: const TextStyle(
        color: Color(0xFF00143e),
        fontSize: 20.0,
      ),
      titleMedium: TextStyle(
        color: const Color(0xFF00143e).withOpacity(0.8),
        fontSize: 18.0,
      ),
      displayLarge: const TextStyle(
        color: Color(0xFF00143e),
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: const TextStyle(
        color: Color(0xFF00143e),
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
      headlineLarge: const TextStyle(
        color: Color(0xFF00143e),
        fontSize: 28,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: const TextStyle(
        color: Color(0xFF00143e),
        fontSize: 20,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
      ),
      labelLarge: const TextStyle(
        color: Color(0xFF00143e),
        fontSize: 20,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: const TextStyle(
        color: Color(0xFF00143e),
        fontSize: 20,
      ),
      labelMedium: const TextStyle(
        color: Color(0xFF00143e),
        fontSize: 18,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: const TextStyle(
        color: Color(0xFF00143e),
        fontSize: 18,
      ),
      labelSmall: const TextStyle(
        color: Color(0xFF00143e),
        fontSize: 16,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
      ),
      bodySmall: const TextStyle(
        color: Color(0xFF00143e),
        fontSize: 16,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: false,
    // scaffoldBackgroundColor: const Color(0xff00143e),
    scaffoldBackgroundColor: const Color(0xFF000a1e),
    appBarTheme: const AppBarTheme(
      // backgroundColor: Colors.indigo,
      backgroundColor: Colors.white12,
      elevation: 5,
      iconTheme: IconThemeData(
        color: Colors.white,
        // color: Color(0xff00143e),
      ),
      titleTextStyle: TextStyle(
        fontSize: 23,
        color:  Colors.white,
        fontWeight: FontWeight.w400,
      ),
    ),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xff00143e),
      onPrimary: Color(0xff00143e),
      secondary: Colors.red,
    ),
    cardTheme: const CardTheme(
      color: Color(0xFFaec2eb),
    ),
    iconTheme: const IconThemeData(
      color: Colors.white54,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        backgroundColor: const Color(0xFFaec2eb),
        textStyle: const TextStyle(
          color: Color(0xFF00143e),
          fontSize: 25,
        ),
      ),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Color(0xFF00143e),
      selectionColor: Color(0xFFaec2eb),
      selectionHandleColor: Colors.white,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(
        fontSize: 20,
        color: Colors.white,
        //fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
      ),
      helperStyle: TextStyle(
        fontSize: 16,
        color: Colors.white60,
        fontStyle: FontStyle.italic,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white,),
      ),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
      ),
      titleMedium: TextStyle(
        color: Colors.white70,
        fontSize: 18.0,
      ),
      displayLarge: TextStyle(
        color: Color(0xFFaec2eb),
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        color: Color(0xFFaec2eb),
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
      headlineLarge: TextStyle(
        color: Color(0xFFaec2eb),
        fontSize: 28,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: Color(0xFFaec2eb),
        fontSize: 20,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
      ),
      labelLarge: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
      labelMedium: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: TextStyle(
        color: Colors.white,
        fontSize: 18,
      ),
      labelSmall: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
      ),
      bodySmall: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
    ),
  );
}