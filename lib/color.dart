import 'package:flutter/material.dart';

class MyColor{
  static List<String> themeName = ["ローズ", "スカイ"];
  static Map<int,MaterialColor> themeColor = {0: rose, 1: sky};

  static const int _rosePrimaryValue = 0xffe95464;
  static const MaterialColor rose = MaterialColor(
    _rosePrimaryValue,
    <int, Color>{
      50 : Color(0xfff19ca7),//ローズピンク
      100 : Color(0xfff0f6da),//ホワイトリリー
      200 : Color(0xfffcc800),//クロムイエロー
      300 : Color(0xffffffff),
      400 : Color(0xffffffff),
      500 : Color(0xffe95464),//ローズ
      600 : Color(0xffffffff),
      700 : Color(0xff9f166a),//ラズベリーレッド
      800 : Color(0xffa22041),//真紅
      900 : Color(0xff9d8e87),//ローズグレイ
    },
  );
  static const int _skyPrimaryValue = 0xff6c9bd2;
  static const MaterialColor sky = MaterialColor(
    _skyPrimaryValue,
    <int, Color>{
      50 : Color(0xffa0d8ef),//スカイブルー
      100 : Color(0xffffedab),//サンシャインイエロー
      200 : Color(0xfff08300),//蜜柑色
      300 : Color(0xffffffff),
      400 : Color(0xffffffff),
      500 : Color(0xff6c9bd2),//ヒヤシンス
      600 : Color(0xffffffff),
      700 : Color(0xff4a488e),//紺藍
      800 : Color(0xff001e43),//ミッドナイトブルー
      900 : Color(0xff719bad),//シャドウブルー
    },
  );
  static const int _BasicValue = 0xffffffff;
  static const MaterialColor basic = MaterialColor(
    _BasicValue,
    <int, Color>{
      50  : Color(0xff202020),
      100 : Color(0xffffffff),
      200 : Color(0xffaa56ff),
      300 : Color(0xff56aaff),
      400 : Color(0xff56ffff),
      500 : Color(0xff56ffaa),
      600 : Color(0xffaaff56),
      700 : Color(0xffffff38),
      800 : Color(0xffffaa56),
      900 : Color(0xffff5656),
    },
  );
}