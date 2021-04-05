import 'package:flutter/material.dart';

class processing{
  static String doubleDigit(int value){ // 二桁に揃える
    String ret = "";
    if(value < 10){
      ret = '0';
    }
    return ret += value.toString();
  }

  static int legalDay(int Y, int M, int D){ // 月末の整合性をとる
    var newD = D;
    switch(M){
      case 2:case 4:case 6:case 9:case 11:
        if(M == 2){ /// 2月
          bool flg = false;
          // 閏年か判定
          if(Y % 4 == 0){
            if(Y % 100 == 0){
              if(Y % 400 == 0)
                flg = true;
            }else{
              flg = true;
            }
          }
          if(flg){ /// 閏年
            if(D > 29)
              newD = 29;
          }else{ /// 閏年じゃない
            if(D > 28)
              newD = 28;
          }
        }else{ /// 2月じゃない
          if(D > 30)
            newD = 30;
        }
        break;
      default:
        /// 31日の月
        break;
    }
    return newD;
  }

  static Future<bool> deleteAlertDialog(context) async{
    return await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("削除"),
          content: Text("削除しますか。"),
          actions: <Widget>[
            // ボタン領域
            FlatButton(
              child: Text("キャンセル"),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            FlatButton(
              child: Text("削除"),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        )
    );
  }
}