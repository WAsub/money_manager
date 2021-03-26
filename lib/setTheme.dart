import 'package:flutter/material.dart';
import 'package:money_manager/color.dart';
import 'package:money_manager/theme/dynamic_theme.dart';
import 'package:money_manager/theme/theme_type.dart';

class SetTheme extends StatefulWidget {
  @override
  _SetThemeState createState() => _SetThemeState();
}

class _SetThemeState extends State<SetTheme> {
  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(title: Text('クレジットマネージャ'),); // タイトルテキスト
    double appheight = appBar.preferredSize.height; //LayoutBuilderを使うとキーボード出した時縮む
    final double deviceHeight = MediaQuery.of(context).size.height - appheight;
    final double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: appBar,
      /******************************************************* AppBar*/
      body: ListView.builder(
        itemCount: MyColor.themeName.length,
        itemBuilder: (context, index) {
          ThemeType themeType = ThemeType.values()[index];
          String value = themeType.toString();
          return InkWell(
            child: Container(
                height: deviceHeight * 0.07,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    // テーマ名
                    Container(
                      width: deviceWidth * 0.5,
                      padding: EdgeInsets.only(left: deviceWidth * 0.01),
                      child: Text(
                        MyColor.themeName[index],
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: deviceHeight * 0.025,),
                      ),
                    ),
                    // 間埋める用
                    Container(width: deviceWidth * 0.3,),
                    // サンプル表示
                    Container(
                      width: deviceWidth * 0.2,
                      padding: EdgeInsets.only(right: deviceWidth * 0.01),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Icon(Icons.stop_circle,color: MyColor.themeColor[index][1],),
                          Icon(Icons.stop_circle,color: MyColor.themeColor[index][2],),
                          Icon(Icons.stop_circle,color: MyColor.themeColor[index][3],),
                        ],
                      ),
                    ),
                  ],
                )
            ),
            onTap: () async{
              DynamicTheme.of(context).setTheme(ThemeType.of(value));
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
