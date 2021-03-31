import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:money_manager/theme/dynamic_theme.dart';
import 'package:money_manager/sqlite.dart';
import 'package:money_manager/pastRecord.dart';
import 'package:money_manager/record.dart';
import 'package:money_manager/config.dart';
import 'package:money_manager/setLine.dart';
import 'package:money_manager/setTheme.dart';
import 'package:money_manager/viewImg.dart';
import 'package:money_manager/add.dart';
import 'package:money_manager/editingCard.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
      themedWidgetBuilder: (context, theme) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: theme,
          home: MoneyManagement(),
        );
      },
    );
  }
}

List<Setting> config = [Setting(id: 0,cardName: "",cardOrder: 0,deadline: 0,paymentDate: 0)];

class MoneyManagement extends StatefulWidget {
  @override
  _MoneyManagementState createState() => _MoneyManagementState();
}
class _MoneyManagementState extends State<MoneyManagement> {
  int nowView;
  var now = DateTime.now();
  List<Widget> leadingIcon;
  List<Widget> titleText;
  List<Widget> onTap;

  Future<void> initializeDrawer() async { // 非同期処理
    config = await SQLite.getSetting();
    nowView = config[1].cardOrder;

    leadingIcon = [null,];titleText = [null,];onTap = [null,];
    for(int i = 2; i < config.length; i++){
      leadingIcon.add(Icon(Icons.credit_card));
      titleText.add(Text(config[i].cardName));
      onTap.add(PastRecord(nowid: config[i].cardOrder,));
    }
    leadingIcon.addAll([Icon(Icons.my_library_add_sharp), Icon(Icons.article_sharp), Icon(Icons.format_color_fill,), Icon(Icons.settings),]);
    titleText.addAll([Text("カード追加・削除"), Text("締め日・支払日変更"), Text("テーマカラー"), Text("設定"),]);
    onTap.addAll([EditingCard(), SetLine(), SetTheme(), Config(),]);
  }
  @override
  Widget build(BuildContext context)  {
    return Scaffold(
      appBar: AppBar(title: Text('クレジットマネージャ'),), // タイトルテキスト
      drawer: FutureBuilder(
          future: initializeDrawer(),
          builder: (context, snapshot) {
            // 非同期処理未完了 = 通信中
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(),);
            }
            // 非同期処理完了
            return Drawer(
              child: ListView.builder(
                itemCount: leadingIcon.length,
                itemBuilder: (context, index) {
                  if(index == 0){
                    return DrawerHeader(
                      decoration: BoxDecoration(color: Theme.of(context).primaryColor,),
                    );
                  }else{
                    return ListTile(
                      leading:leadingIcon[index], // 左のアイコン
                      title: titleText[index], // テキスト
                      trailing: Icon(Icons.arrow_forward),
                      onTap: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
                            // 画面遷移
                            return onTap[index];
                          }),
                        ).then((value) async {
                          // 戻ったら更新(主に設定から戻った時用)
                          List<Setting> set = await SQLite.getSetting();
                          setState(() {
                            config = set;
                            nowView = config[1].cardOrder;
                          });

                        });
                      },
                    );
                  }
                },
              ),
            );

          }
      ),
      /******************************************************* AppBar*/
      body: FutureBuilder(
        future: initializeDrawer(),
        builder: (context, snapshot) {
          // 非同期処理未完了 = 通信中
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(),);
          }
          return Record(nowid: nowView,);
        }
      ),
    );
  }

}