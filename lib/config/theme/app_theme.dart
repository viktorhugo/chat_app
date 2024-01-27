import 'package:flutter/material.dart';

class AppTheme {
  ThemeData getTheme() => ThemeData(
    useMaterial3: true,
    // Define the default brightness and colors.
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xff2c353f),
      primary: const Color(0xff2c353f),
      secondary: Colors.amber,
      // ···
      // brightness: Brightness.dark,
    ),
  );
}