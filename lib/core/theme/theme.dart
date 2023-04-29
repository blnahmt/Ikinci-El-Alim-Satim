import 'package:flutter/material.dart';

import '../constants/colors.dart';

class AppTheme {
  ThemeData theme = ThemeData(
    fontFamily: "QuickSand",
    textTheme: const TextTheme(
      headlineLarge: TextStyle(color: AppColors.charCoal),
      headlineMedium: TextStyle(color: AppColors.charCoal),
      headlineSmall: TextStyle(color: AppColors.charCoal),
      bodyLarge: TextStyle(color: AppColors.charCoal),
      bodyMedium: TextStyle(color: AppColors.charCoal),
      bodySmall: TextStyle(color: AppColors.charCoal),
    ),
    primaryTextTheme: const TextTheme(
      headlineLarge: TextStyle(color: AppColors.cadetBlue),
      headlineMedium: TextStyle(color: AppColors.cadetBlue),
      headlineSmall: TextStyle(color: AppColors.cadetBlue),
      bodyLarge: TextStyle(color: AppColors.cadetBlue),
      bodyMedium: TextStyle(color: AppColors.cadetBlue),
      bodySmall: TextStyle(color: AppColors.cadetBlue),
    ),
    accentTextTheme: const TextTheme(
      headlineLarge: TextStyle(color: AppColors.fieryRose),
      headlineMedium: TextStyle(color: AppColors.fieryRose),
      headlineSmall: TextStyle(color: AppColors.fieryRose),
      bodyLarge: TextStyle(color: AppColors.fieryRose),
      bodyMedium: TextStyle(color: AppColors.fieryRose),
      bodySmall: TextStyle(color: AppColors.fieryRose),
    ),
    cardColor: AppColors.lightSilver2,
    cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
    colorScheme: const ColorScheme.light(
      primary: AppColors.fieryRose,
      background: Colors.white,
      onBackground: AppColors.cadetBlue,
    ),
    primarySwatch: AppColors.fieryRoseMaterial,
    appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: TextStyle(
            color: AppColors.charCoal,
            fontWeight: FontWeight.w400,
            fontFamily: "QuickSand",
            fontSize: 22)),
    backgroundColor: Colors.white,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.fieryRose),
    scaffoldBackgroundColor: Colors.white,
  );
}
