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
    double deviceHeight;
    double deviceWidth;

    return Scaffold(
      appBar: AppBar(title: Text('クレジットマネージャ'),),
      /******************************************************* AppBar*/
      body: LayoutBuilder(
        builder: (context, constraints) {
          deviceHeight = constraints.maxHeight;
          deviceWidth = constraints.maxWidth;

          return ListView.separated(
            itemCount: MyColor.themeName.length,
            itemBuilder: (context, index) {
              ThemeType themeType = ThemeType.values()[index];
              String value = themeType.toString();
              return InkWell(
                child: Container(
                  height: 56.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 15,right: 15,),
                        child: Text(
                          MyColor.themeName[index],
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 16,),
                        ),
                      ),
                      Expanded(child: Container(),), // 隙間いっぱい埋める
                      Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(left: 18,right: 15,),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Icon(Icons.stop_circle,color: MyColor.themeColor[index][900],),
                            Icon(Icons.stop_circle,color: MyColor.themeColor[index][500],),
                            Icon(Icons.stop_circle,color: MyColor.themeColor[index][50],),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () async{
                  DynamicTheme.of(context).setTheme(ThemeType.of(value));
                  Navigator.pop(context);
                },
              );
            },
            separatorBuilder: (context, index){
              return Divider(height:3,);
            },
          );
        }
      ),
    );
  }
}
