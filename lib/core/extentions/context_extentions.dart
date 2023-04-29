import 'package:flutter/material.dart';

extension ContextExtention on BuildContext{
  ThemeData get themeData => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
  TextTheme get primarytTextTheme => Theme.of(this).primaryTextTheme;

  double dynamicHeight(double value) =>
      MediaQuery.of(this).size.height * (value / 100);
  double dynamicWidth(double value) =>
      MediaQuery.of(this).size.width * (value / 100);
}