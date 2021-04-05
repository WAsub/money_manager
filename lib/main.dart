import 'package:flutter/material.dart';
import 'package:money_manager/theme/dynamic_theme.dart';
import 'package:money_manager/sqlite.dart';
import 'package:money_manager/setCardConfig.dart';
import 'package:money_manager/setTheme.dart';
import 'package:money_manager/color.dart';
import 'package:money_manager/subCard.dart';
import 'package:money_manager/record.dart';

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
/// 他のファイルからもアクセスする */
List<Setting> config;
List<Color> cardColor;
///*************************** */
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
  List<Widget> leadingIconConf = [null, Icon(Icons.my_library_add_sharp), Icon(Icons.format_color_fill,),];
  List<Widget> titleTextConf = [null, Text("カード編集"), Text("テーマカラー"),];
  List<Widget> onTapConf = [null, SetCardConfig(), SetTheme(),];

  Future<void> initialize() async { /// 非同期処理
    config = await SQLite.getSetting();
    nowView = config[1].cardOrder;
    cardColor = []; // 初期化
    cardColor.addAll(MyColor.basic); // 共通カラー10色
    cardColor.add(Theme.of(context).primaryColorDark); // テーマカラー[800]
    cardColor.add(Theme.of(context).backgroundColor); // テーマカラー[700]
    cardColor.add(Theme.of(context).focusColor); // テーマカラー[200]
    cardColor.add(Theme.of(context).primaryColorLight); // テーマカラー[100]

    leadingIcon = [null,]; titleText = [null,]; onTap = [null,]; // 初期化
    for(int i = 2; i < config.length; i++){ // メインカード以外を遷移アイテムを追加
      leadingIcon.add(Icon(Icons.credit_card, color: cardColor[config[i].cardColor],));
      titleText.add(Text(config[i].cardName));
      onTap.add(SubCard(nowid: config[i].cardOrder,));
    }
  }
  @override
  Widget build(BuildContext context)  {
    return Scaffold(
      appBar: AppBar(title: Text('クレジットマネージャ'),), // タイトルテキスト
      /**************************************************************** AppBar*/
      drawer: FutureBuilder(
          future: initialize(),
          builder: (context, snapshot) {
            // 非同期処理未完了 = 通信中
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator(),);
            // 非同期処理完了
            return Drawer(
              child: ListView.builder(
                itemCount: leadingIcon.length + leadingIconConf.length,
                itemBuilder: (context, index) {
                  if(index == 0){ /// 先頭はヘッダー
                    return DrawerHeader(decoration: BoxDecoration(color: Theme.of(context).primaryColor,),);
                  }else if(index < leadingIcon.length){ /// サブカード遷移アイテム
                    return ListTile(
                      leading:leadingIcon[index], // 左のアイコン
                      title: titleText[index], // テキスト
                      trailing: Icon(Icons.arrow_forward),
                      onTap: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
                            return onTap[index]; // サブカードへ
                          }),
                        );
                      },
                    );
                  }else if(index - leadingIcon.length == 0){
                    return Divider(height:8,); /// サブカード遷移アイテムと設定の間に仕切り
                  }else{
                    return ListTile(
                      leading:leadingIconConf[index-leadingIcon.length], // 左のアイコン
                      title: titleTextConf[index-leadingIcon.length], // テキスト
                      trailing: Icon(Icons.arrow_forward),
                      onTap: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
                            return onTapConf[index-leadingIcon.length]; // 各設定へ
                          }),
                        ).then((value) async {
                          // 戻ったら更新
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
      /**************************************************************** Drawer*/
      body: FutureBuilder(
        future: initialize(),
        builder: (context, snapshot) {
          // 非同期処理未完了 = 通信中
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator(),);
          // 非同期処理完了
          return Record(nowid: nowView,);
        }
      ),
      /****************************************************************** Body*/
    );
  }
}