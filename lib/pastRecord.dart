import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:money_manager/sqlite.dart';
import 'package:money_manager/main.dart';
import 'package:money_manager/viewImg.dart';
import 'package:money_manager/add.dart';

class PastRecord extends StatefulWidget {
  @override
  _PastRecordState createState() => _PastRecordState();
}

class _PastRecordState extends State<PastRecord> {
  List<Money> _moneyList = [];
  int totalMoney = 0;
  var lastM = DateTime(DateTime.now().year, DateTime.now().month-1, DateTime.now().day);

  Future<void> initializeDemo() async { // 非同期処理(List取得)
    _moneyList = await SQLite.getMoneys(lastM.year, lastM.month, lastM.day);
    _moneyList = await SQLite.getImages(_moneyList);
    totalMoney = 0;
    for(int i = 0; i < _moneyList.length; i++){
      totalMoney += _moneyList[i].money;
    }
  }
  @override
  Widget build(BuildContext context) {
    double deviceHeight;
    double deviceWidth;

    return Scaffold(
      appBar: AppBar(title: Text('クレジットマネージャ'),), // タイトルテキスト
      /******************************************************* AppBar*/
      body: LayoutBuilder(
          builder: (context, constraints) {
            deviceHeight = constraints.maxHeight;
            deviceWidth = constraints.maxWidth;

            return FutureBuilder(
              future: initializeDemo(),
              builder: (context, snapshot) {
                // 非同期処理未完了 = 通信中
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(),);
                }
                // 非同期処理完了
                int correct = lastM.day <= config[0].deadline ? 1 : 2;
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      /** 月選択 */
                      Container(
                        height: deviceHeight * 0.05,
                        decoration: BoxDecoration(
                            color: Theme.of(context).selectedRowColor,
                            border: Border(bottom: BorderSide(color: Colors.white, width: 1,))
                        ),
                        child: Row(
                          children: <Widget>[
                            /** 前月へ */
                            InkWell(
                              onTap: () async{
                                lastM = DateTime(lastM.year,lastM.month-1);
                                List<Money> moneys = await SQLite.getMoneys(lastM.year, lastM.month, lastM.day);
                                moneys = await SQLite.getImages(moneys);
                                setState(() {
                                  _moneyList = moneys;
                                });
                              },
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.arrow_left, size: deviceHeight * 0.05,),
                                  Container(
                                    width: deviceWidth * 0.11,
                                    child: Text(
                                      (DateTime(lastM.year,lastM.month-1).month).toString()+"月",
                                      style: TextStyle(fontSize: deviceHeight * 0.025),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            /** 表示中の月 */
                            Container(
                                width: deviceWidth * 0.78 - deviceHeight * 0.1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      lastM.month.toString()+"月",
                                      style: TextStyle(fontSize: deviceHeight * 0.03, fontStyle: FontStyle.italic,),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      "("+(DateTime(lastM.year,lastM.month+correct).month).toString()+"月"+config[0].paymentDate.toString()+"日支払い分)",
                                      style: TextStyle(fontSize: deviceHeight * 0.02, fontStyle: FontStyle.italic,),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                )
                            ),
                            /** 来月へ */
                            InkWell(
                                onTap: () async{
                                  lastM = DateTime(lastM.year,lastM.month+1);
                                  List<Money> moneys = await SQLite.getMoneys(lastM.year, lastM.month, lastM.day);
                                  moneys = await SQLite.getImages(moneys);
                                  setState(() {
                                    _moneyList = moneys;
                                  });
                                },
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: deviceWidth * 0.11,
                                      child: Text(
                                        (DateTime(lastM.year,lastM.month+1).month).toString()+"月",
                                        style: TextStyle(fontSize: deviceHeight * 0.025),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                    Icon(Icons.arrow_right, size: deviceHeight * 0.05,),
                                  ],
                                )
                            ),
                          ],
                        ),
                      ),
                      /** 合計金額 */
                      Container(
                          color: Theme.of(context).selectedRowColor,
                          alignment: Alignment.centerRight,
                          height: deviceHeight * 0.08,
                          child: Text(
                            totalMoney.toString() + '円',
                            style: TextStyle(fontSize: deviceHeight * 0.045, color: Colors.white),
                          )
                      ),
                      /** ListView */
                      Container(
                        height: deviceHeight * 0.87,
                        child: ListView.separated(
                          itemCount: _moneyList.length,
                          itemBuilder: (context, index){
                            /** 一番初めと日付が変わるたび日付表示 */
                            if(index == 0){ // orにすると-1になってエラーになる
                              return _datedItem(_moneyList[index], deviceHeight, deviceWidth);
                            }else if(DateTime.parse(_moneyList[index].date) != DateTime.parse(_moneyList[index - 1].date)){
                              return _datedItem(_moneyList[index], deviceHeight, deviceWidth);
                            }else{ // 同じ日なら日付を挟まない
                              return _swipeDeleteItem(_moneyList[index], deviceHeight, deviceWidth);
                            }
                          },
                          separatorBuilder: (context, index){
                            return Divider(height:3,);
                          },
                        ),
                      ),
                    ]
                );
              },
            );
          },
      ),
    );
  }

  void reload() async {
    List<Money> moneys = await SQLite.getMoneys(lastM.year, lastM.month, lastM.day);
    moneys = await SQLite.getImages(moneys);
    setState(() {
      _moneyList = moneys;
    });
  }
  // スワイプ処理
  Future<bool> swipeItem() async{
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
  // 削除処理
  void deleteItem(int id) async{
    await SQLite.deleteMoneyAndImgs(id);
    reload();
  }
  /// リストアイテム
  // 日付つきアイテム
  Widget _datedItem(Money money, deviceHeight, deviceWidth){
    return Column(
      children: <Widget>[
        Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: Text(
            money.date,
            style: TextStyle(fontSize: deviceHeight * 0.025,),
          ),
        ),
        /** 日付なしアイテム */
        _swipeDeleteItem(money, deviceHeight, deviceWidth),
      ],
    );
  }
  // 日付なしアイテム
  Widget _swipeDeleteItem(Money money, deviceHeight, deviceWidth){
    return Dismissible( // スワイプ削除
      key: Key(money.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.redAccent,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 2,),
        child: Icon(Icons.delete,size: deviceHeight * 0.03,),
      ),
      /** スワイプ処理 */
      confirmDismiss: (direction){return swipeItem();},
      /** 削除処理 */
      onDismissed: (direction) {deleteItem(money.id);},
      /** タップアイテム */
      child: _listItem(money, deviceHeight, deviceWidth),
    );
  }
  // タップアイテム
  Widget _listItem(Money money, deviceHeight, deviceWidth){
    return InkWell(
      /** 詳細表示ダイアログ */
      onTap: () {_showDetails(money, deviceHeight, deviceWidth);},
      /** アイテム */
      child: Container(
        width: deviceWidth,
        height: deviceHeight * 0.07,
        alignment: Alignment.centerRight,
        child: Text(
          money.money.toString() + '円',
          style: TextStyle(fontSize: deviceHeight * 0.04,),
        ),
      ),
    );
  }
  // 詳細表示ダイアログ
  Future<bool> _showDetails(Money money, deviceHeight, deviceWidth) async {
    Widget _image(){ // 画像
      if(money.image.length == 0){
        return Container(
          height: 200,
          decoration: BoxDecoration(color: Colors.grey[300],),
        );
      }else{
        return Image.memory(base64Decode(
            money.image[0]),
          fit: BoxFit.fitWidth,
        );
      }
    }
    return await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // 要素ができるだけ小さくなる
            children: <Widget>[
              // 写真
              InkWell(
                onTap: (){
                  Navigator .of(context).push(
                    MaterialPageRoute(builder: (context) {
                      /// 写真をリストで表示する画面へ
                      return ViewImg(imgs: money.image); }),
                  );
                },
                child: Container(
                  width: deviceWidth * 0.7,
                  child: _image(), // 画像
                ),
              ),
              // 日付
              Text(money.date, textAlign: TextAlign.left,),
              // 金額
              Container(
                  width: deviceWidth * 0.7,
                  child: Text(
                    money.money.toString()+'円',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: deviceHeight * 0.035),
                  )
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("編集"),
              onPressed: (){
                Navigator .of(context).push(
                  MaterialPageRoute(builder: (context) {
                    // 編集画面へ
                    return Add(money: money);}),
                ).then((value) async{
                  reload();
                  Navigator.pop(context);
                });
              },
            ),
          ],
        )
    );
  }

}
