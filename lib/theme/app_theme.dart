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
  static ThemeData theme_konoha() {
    return ThemeData(
      primaryColor: MyColor.konoha[900],
      accentColor: MyColor.konoha[500],
      selectedRowColor: MyColor.konoha[50],
      primaryColorDark: MyColor.konoha[800],
      backgroundColor: MyColor.konoha[700],
      primaryColorLight: MyColor.konoha[100],
      focusColor: MyColor.konoha[200],
      brightness: Brightness.light,
    );
  }
  static ThemeData theme_dark() {
    return ThemeData(
      primaryColor: MyColor.dark[900],
      accentColor: MyColor.dark[500],
      selectedRowColor: MyColor.dark[50],
      primaryColorDark: MyColor.dark[800],
      backgroundColor: MyColor.dark[700],
      primaryColorLight: MyColor.dark[100],
      focusColor: MyColor.dark[200],
      brightness: Brightness.dark,
    );
  }

}