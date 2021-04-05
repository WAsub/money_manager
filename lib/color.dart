import 'package:flutter/material.dart';

class MyColor{
  static List<String> themeName = ["ローズ", "スカイ","木の葉", "ダーク"];
  static Map<int,MaterialColor> themeColor = {0: rose, 1: sky, 2: konoha, 3: dark};

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
  static const int _konohaPrimaryValue = 0xff9fc24d;
  static const MaterialColor konoha = MaterialColor(
    _konohaPrimaryValue,
    <int, Color>{
      50 : Color(0xffe3e548),//シャルトルーズイエロー
      100 : Color(0xfffdd35c),//ネープルスイエロー
      200 : Color(0xffe17b34),//ローシェンナ
      300 : Color(0xffffffff),
      400 : Color(0xffffffff),
      500 : Color(0xff9fc24d),//リーフグリーン
      600 : Color(0xffffffff),
      700 : Color(0xff578a3d),//アイビーグリーン
      800 : Color(0xff866629),//ローアンバー
      900 : Color(0xff54917f),//アンティークグリーン
    },
  );
  static const int _darkPrimaryValue = 0xff9fa09e;
  static const MaterialColor dark = MaterialColor(
    _darkPrimaryValue,
    <int, Color>{
      50 : Color(0xff9fa09e),//アッシュグレイ
      100 : Color(0xff8d93c8),//ウイスタリア
      200 : Color(0xff25b7c0),//ケンブリッジブルー
      300 : Color(0xffffffff),
      400 : Color(0xffffffff),
      500 : Color(0xff9fa09e),//アッシュグレイ
      600 : Color(0xffffffff),
      700 : Color(0xfffff462),//ミモザ
      800 : Color(0xffea5550),//ポピーレッド
      900 : Color(0xffd4d9dc),//ローズグレイ
    },
  );
  static List<Color> basic = [
    Color(0xffff5656),
    Color(0xffffaa56),
    Color(0xffffff38),
    Color(0xffaaff56),
    Color(0xff56ffaa),
    Color(0xff56ffff),
    Color(0xff56aaff),
    Color(0xffaa56ff),
    Color(0xffffffff),
    Color(0xff202020),
  ];

}