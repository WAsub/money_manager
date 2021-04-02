import 'package:flutter/material.dart';
import 'package:money_manager/color.dart';

class AppTheme {
  static ThemeData theme_rose() {
    return ThemeData(
      primaryColor: MyColor.rose[900],
      accentColor: MyColor.rose[500],
      selectedRowColor: MyColor.rose[50],
      primaryColorDark: MyColor.rose[800],
      backgroundColor: MyColor.rose[700],
      primaryColorLight: MyColor.rose[100],
      focusColor: MyColor.rose[200],
      brightness: Brightness.light,
    );
  }
  static ThemeData theme_sky() {
    return ThemeData(
      primaryColor: MyColor.sky[900],
      accentColor: MyColor.sky[500],
      selectedRowColor: MyColor.sky[50],
      primaryColorDark: MyColor.sky[800],
      backgroundColor: MyColor.sky[700],
      primaryColorLight: MyColor.sky[100],
      focusColor: MyColor.sky[200],
      brightness: Brightness.light,
    );
  }

}