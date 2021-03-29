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
    leadingIcon.addAll([Icon(Icons.article_sharp), Icon(Icons.format_color_fill,), Icon(Icons.settings),]);
    titleText.addAll([Text("締め日・支払日変更"), Text("テーマカラー"), Text("設定"),]);
    onTap.addAll([SetLine(), SetTheme(), Config(),]);
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
                          // List<List<Money>> moneys = await SQLite.getMoneys(
                          //     now.year, now.month, now.day);
                          // moneys = await SQLite.getImages(moneys);
                          List<Setting> set = await SQLite.getSetting();
                          setState(() {
                            // _moneyList = moneys;
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
      //   LayoutBuilder(
      //     builder: (context, constraints) {
      //       deviceHeight = constraints.maxHeight;
      //       deviceWidth = constraints.maxWidth;
      //
      //       return FutureBuilder(
      //         future: initializeDemo(),
      //         builder: (context, snapshot) {
      //           // 非同期処理未完了 = 通信中
      //           if (snapshot.connectionState == ConnectionState.waiting) {
      //             return Center(child: CircularProgressIndicator(),);
      //           }
      //           // 非同期処理完了
      //           int correct = now.day <= config[0].deadline ? 1 : 2;
      //           int paymentMonth = DateTime(now.year,now.month+correct).month;
      //           return Column(
      //               crossAxisAlignment: CrossAxisAlignment.end,
      //               children: <Widget>[
      //                 /** 月選択 */
      //                 Container(
      //                   height: deviceHeight * 0.06,
      //                   decoration: BoxDecoration(
      //                       color: Theme.of(context).selectedRowColor,
      //                       border: Border(bottom: BorderSide(color: Colors.white, width: 1,))
      //                   ),
      //                   child: Row(
      //                     children: <Widget>[
      //                       /** 前月へ */
      //                       InkWell(
      //                         onTap: () async{
      //                           now = DateTime(now.year,now.month-1);
      //                           List<List<Money>> moneys = await SQLite.getMoneys(now.year, now.month, now.day);
      //                           // moneys = await SQLite.getImages(moneys);
      //                           setState(() {
      //                             _moneyList = moneys;
      //                           });
      //                         },
      //                         child: Row(
      //                           children: <Widget>[
      //                             Icon(Icons.arrow_left, size: deviceHeight * 0.05,),
      //                             Container(
      //                               width: deviceWidth * 0.11,
      //                               child: Text(
      //                                 "前月",
      //                                 // (DateTime(now.year,now.month-1).month).toString()+"月",
      //                                 style: TextStyle(fontSize: deviceHeight * 0.0225),
      //                                 textAlign: TextAlign.left,
      //                               ),
      //                             ),
      //                           ],
      //                         ),
      //                       ),
      //                       /** 表示中の月 */
      //                       Container(
      //                           width: deviceWidth * 0.78 - deviceHeight * 0.1,
      //                           child: Column(
      //                             mainAxisAlignment: MainAxisAlignment.center,
      //                             crossAxisAlignment: CrossAxisAlignment.center,
      //                             children: <Widget>[
      //                               Text(
      //                                 paymentMonth.toString()+"月"+config[0].paymentDate.toString()+"日支払い分",
      //                                 style: TextStyle(fontSize: deviceHeight * 0.025, fontStyle: FontStyle.italic, color: Colors.white, ),
      //                               ),
      //                               Text(
      //                                 "("+(paymentMonth-2).toString()+"月"+(config[0].deadline+1).toString()+"日〜"+
      //                                     (paymentMonth-1).toString()+"月"+(config[0].deadline).toString()+"日)",
      //                                 style: TextStyle(fontSize: deviceHeight * 0.02, fontStyle: FontStyle.italic, color: Colors.white, height: deviceHeight * 0.001),
      //                               ),
      //                             ]
      //                           ),
      //                       ),
      //                       /** 来月へ */
      //                       InkWell(
      //                           onTap: () async{
      //                             now = DateTime(now.year,now.month+1);
      //                             List<List<Money>> moneys = await SQLite.getMoneys(now.year, now.month, now.day);
      //                             // moneys = await SQLite.getImages(moneys);
      //                             setState(() {
      //                               _moneyList = moneys;
      //                             });
      //                           },
      //                           child: Row(
      //                             children: <Widget>[
      //                               Container(
      //                                 width: deviceWidth * 0.11,
      //                                 child: Text(
      //                                   "次月",
      //                                   // (DateTime(now.year,now.month+1).month).toString()+"月",
      //                                   style: TextStyle(fontSize: deviceHeight * 0.0225),
      //                                   textAlign: TextAlign.right,
      //                                 ),
      //                               ),
      //                               Icon(Icons.arrow_right, size: deviceHeight * 0.05,),
      //                             ],
      //                           )
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //                 /** 合計金額 */
      //                 Stack(
      //                     children: [
      //                       Container(
      //                           color: Theme.of(context).selectedRowColor,
      //                           alignment: Alignment.centerRight,
      //                           height: deviceHeight * 0.08,
      //                           child: Text(
      //                             totalMoney.toString() + '円',
      //                             style: TextStyle(fontSize: deviceHeight * 0.045, color: Colors.white),
      //                           )
      //                       ),
      //                       // Text(
      //                       //   (DateTime(now.year,now.month+correct).month).toString()+"月"+config[0].paymentDate.toString()+"日支払い分",
      //                       //   style: TextStyle(fontSize: deviceHeight * 0.025, fontStyle: FontStyle.italic, color: Colors.white, ),
      //                       // ),
      //                     ]
      //                 ),
      //                 /** ListView */
      //                 Container(
      //                   height: deviceHeight * 0.86,
      //                   child: ListView.separated(
      //                     itemCount: _moneyList[nowView].length,
      //                     itemBuilder: (context, index){
      //                       /** 一番初めと日付が変わるたび日付表示 */
      //                       if(index == 0){ // orにすると-1になってエラーになる
      //                         return _datedItem(_moneyList[nowView][index], deviceHeight, deviceWidth);
      //                       }else if(DateTime.parse(_moneyList[nowView][index].date) != DateTime.parse(_moneyList[nowView][index - 1].date)){
      //                         return _datedItem(_moneyList[nowView][index], deviceHeight, deviceWidth);
      //                       }else{ // 同じ日なら日付を挟まない
      //                         return _swipeDeleteItem(_moneyList[nowView][index], deviceHeight, deviceWidth);
      //                       }
      //                     },
      //                     separatorBuilder: (context, index){
      //                       return Divider(height:3,);
      //                     },
      //                   ),
      //                 ),
      //               ]
      //           );
      //         },
      //       );
      //     },
      // ),
      /** 追加画面へ */
      // floatingActionButton: FloatingActionButton(
      //   onPressed: addItem,
      //   child: Icon(Icons.add),
      // ),
    );
  }

  // void reload() async {
  //   List<List<Money>> moneys = await SQLite.getMoneys(now.year, now.month, now.day);
  //   // moneys = await SQLite.getImages(moneys);
  //   setState(() {
  //     _moneyList = moneys;
  //   });
  // }
  // 追加画面へ処理
  void addItem(){
    Navigator .of(context).push(
      MaterialPageRoute(builder: (context) {
        // 追加画面へ
        return Add(money: Money(id: 0));}),
    ).then((value) async{
      // reload();
    });
  }
  // // スワイプ処理
  // Future<bool> swipeItem() async{
  //   return await showDialog(
  //       context: context,
  //       builder: (_) => AlertDialog(
  //         title: Text("削除"),
  //         content: Text("削除しますか。"),
  //         actions: <Widget>[
  //           // ボタン領域
  //           FlatButton(
  //             child: Text("キャンセル"),
  //             onPressed: () => Navigator.of(context).pop(false),
  //           ),
  //           FlatButton(
  //             child: Text("削除"),
  //             onPressed: () => Navigator.of(context).pop(true),
  //           ),
  //         ],
  //       )
  //   );
  // }
  // // 削除処理
  // void deleteItem(int id) async{
  //   await SQLite.deleteMoneyAndImgs(id);
  //   reload();
  // }
  // /// リストアイテム
  // // 日付つきアイテム
  // Widget _datedItem(Money money, deviceHeight, deviceWidth){
  //   return Column(
  //     children: <Widget>[
  //       Container(
  //         color: Colors.grey[100],
  //         alignment: Alignment.center,
  //         child: Text(
  //           money.date,
  //           style: TextStyle(fontSize: deviceHeight * 0.025,),
  //         ),
  //       ),
  //       /** 日付なしアイテム */
  //       _swipeDeleteItem(money, deviceHeight, deviceWidth),
  //     ],
  //   );
  // }
  // // 日付なしアイテム
  // Widget _swipeDeleteItem(Money money, deviceHeight, deviceWidth){
  //   return Dismissible( // スワイプ削除
  //     key: Key(money.id.toString()),
  //     direction: DismissDirection.endToStart,
  //     background: Container(
  //       color: Colors.redAccent,
  //       alignment: Alignment.centerRight,
  //       padding: EdgeInsets.only(right: 2,),
  //       child: Icon(Icons.delete,size: deviceHeight * 0.03,),
  //     ),
  //     /** スワイプ処理 */
  //     confirmDismiss: (direction){return swipeItem();},
  //     /** 削除処理 */
  //     onDismissed: (direction) {deleteItem(money.id);},
  //     /** タップアイテム */
  //     child: _listItem(money, deviceHeight, deviceWidth),
  //   );
  // }
  // // タップアイテム
  // Widget _listItem(Money money, deviceHeight, deviceWidth){
  //   return InkWell(
  //     /** 詳細表示ダイアログ */
  //     onTap: () {_showDetails(money, deviceHeight, deviceWidth);},
  //     /** アイテム */
  //     child: Container(
  //       width: deviceWidth,
  //       height: deviceHeight * 0.07,
  //       alignment: Alignment.centerRight,
  //       child: Text(
  //         money.money.toString() + '円',
  //         style: TextStyle(fontSize: deviceHeight * 0.04,),
  //       ),
  //     ),
  //   );
  // }
  // // 詳細表示ダイアログ
  // Future<bool> _showDetails(Money money, deviceHeight, deviceWidth) async {
  //   Widget _image(){ // 画像
  //     if(money.image.length == 0){
  //       return Container(
  //         height: 200,
  //         decoration: BoxDecoration(color: Colors.grey[300],),
  //       );
  //     }else{
  //       return Image.memory(base64Decode(
  //           money.image[0]),
  //         fit: BoxFit.fitWidth,
  //       );
  //     }
  //   }
  //   return await showDialog(
  //       context: context,
  //       builder: (_) => AlertDialog(
  //         content: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           mainAxisSize: MainAxisSize.min, // 要素ができるだけ小さくなる
  //           children: <Widget>[
  //             // 写真
  //             InkWell(
  //               onTap: (){
  //                 Navigator .of(context).push(
  //                   MaterialPageRoute(builder: (context) {
  //                     /// 写真をリストで表示する画面へ
  //                     return ViewImg(imgs: money.image); }),
  //                 );
  //               },
  //               child: Container(
  //                 width: deviceWidth * 0.7,
  //                 child: _image(), // 画像
  //               ),
  //             ),
  //             // 日付
  //             Text(money.date, textAlign: TextAlign.left,),
  //             // 金額
  //             Container(
  //                 width: deviceWidth * 0.7,
  //                 child: Text(
  //                   money.money.toString()+'円',
  //                   textAlign: TextAlign.right,
  //                   style: TextStyle(fontSize: deviceHeight * 0.035),
  //                 )
  //             ),
  //           ],
  //         ),
  //         actions: <Widget>[
  //           FlatButton(
  //             child: Text("編集"),
  //             onPressed: (){
  //               Navigator .of(context).push(
  //                 MaterialPageRoute(builder: (context) {
  //                   // 編集画面へ
  //                   return Add(money: money);}),
  //               ).then((value) async{
  //                 reload();
  //                 Navigator.pop(context);
  //               });
  //             },
  //           ),
  //         ],
  //       )
  //   );
  // }

}