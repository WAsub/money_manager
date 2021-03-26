import 'package:flutter/material.dart';
import 'package:money_manager/setLine.dart';
import 'package:money_manager/setTheme.dart';

class Config extends StatefulWidget {
  @override
  _ConfigState createState() => _ConfigState();
}

class _ConfigState extends State<Config> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // タイトルテキスト
        title: Text('クレジットマネージャ'),
      ),
      /******************************************************* AppBar*/
      body: ListView(
          children: <Widget>[
            /** 締め日・支払日変更画面へ */
            ListTile(
              leading:Icon(Icons.credit_card),
              title: Text("締め日・支払日変更"),
              trailing: Icon(Icons.arrow_forward_ios_sharp),
              onTap: (){
                Navigator .of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return SetLine();
                  }),
                );
              },
            ),
            /** テーマカラー変更画面へ */
            ListTile(
              leading:Icon(Icons.format_color_fill,),
              title: Text("テーマカラー"),
              trailing: Icon(Icons.arrow_forward_ios_sharp),
              onTap: (){
                Navigator .of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return SetTheme();
                  }),
                );
              },
            ),
          ]
      ),
    );
  }
}
