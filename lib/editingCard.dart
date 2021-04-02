import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/main.dart';
import 'package:money_manager/sqlite.dart';

import 'editCard.dart';

class EditingCard extends StatefulWidget {
  @override
  _EditingCardState createState() => _EditingCardState();
}

class _EditingCardState extends State<EditingCard> {
  Future<void> initialize() async { // 非同期処理
    // config = await SQLite.getSetting();

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
            future: initialize(),
            builder: (context, snapshot) {
              // 非同期処理未完了 = 通信中
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator(),);
              }
              // 非同期処理完了
              return Stack(
                  children: [
                    /** ListView */
                    ListView.separated(
                      itemCount: config.length,
                      itemBuilder: (context, index){
                        /**  */
                        if(index == 0){
                          return Container(height: 0,);
                        }
                        return _swipeDeleteItem(config[index],deviceHeight,deviceWidth);
                      },
                      separatorBuilder: (context, index){
                        return Divider(height:3,);
                      },
                    ),
                    /** 追加画面へ */
                    Container(
                      alignment: Alignment.bottomRight,
                      padding: EdgeInsets.only(bottom: 34,right: 16,),
                      child: FloatingActionButton(
                        // backgroundColor: Colors.blue,
                        // onPressed: addItem,
                        child: Icon(Icons.add),
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
    // await SQLite.deleteMoneyAndImgs(id);
    // reload();
  }
  Widget _swipeDeleteItem(Setting conf, deviceHeight, deviceWidth){
    return Dismissible( // スワイプ削除
      key: Key(conf.id.toString()),
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
      onDismissed: (direction) {deleteItem(conf.id);},
      /** タップアイテム */
      child: _listItem(conf, deviceHeight, deviceWidth),
    );
  }
  // タップアイテム
  Widget _listItem(Setting conf, deviceHeight, deviceWidth){
    return InkWell(
      /** 編集画面へ */
      onTap: () {
        Navigator .of(context).push(
          MaterialPageRoute(builder: (context) {
            // 追加画面へ
            return EditCard(conf: conf);}),
        ).then((value) async{
          // reload();
        });
      },
      /** アイテム */
      child: Stack(
        children: [
          Container(
            height: 56.0,
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: cardColor[conf.cardColor], width: 11,))
            ),
          ),
          Container(
            height: 56.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 15,right: 15,),
                  child: Icon(Icons.credit_card, color: cardColor[conf.cardColor],),
                ),
                Container(
                  padding: EdgeInsets.only(left: 18,right: 15,),
                  child: Text(
                    conf.cardName,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


}
