import 'package:flutter/material.dart';
import 'package:money_manager/main.dart';
import 'package:money_manager/sqlite.dart';
import 'package:money_manager/processing.dart';
import 'package:money_manager/editCard.dart';

class SetCardConfig extends StatefulWidget {
  @override
  _SetCardConfigState createState() => _SetCardConfigState();
}

class _SetCardConfigState extends State<SetCardConfig> {
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

          return Stack(
              children: [
                /** ListView */
                ReorderableListView(
                  children: <Widget>[
                    for (int index = 1; index < config.length; index++)
                      _swipeDeleteItem(config[index],deviceHeight,deviceWidth)
                  ],
                  onReorder: (int oldIndex, int newIndex) async{
                    oldIndex++;
                    newIndex++;
                    if (oldIndex < newIndex)
                      newIndex -= 1;
                    setState(() {
                      final Setting item = config.removeAt(oldIndex);
                      config.insert(newIndex, item);
                      for(int i = 1; i < config.length; i++)
                        config[i].cardOrder = i;
                    });

                    for(int i = 1; i < config.length; i++)
                      await SQLite.updateSetting(config[i]);
                  },
                ),
                /** 追加画面へ */
                Container(
                  alignment: Alignment.bottomRight,
                  padding: EdgeInsets.only(bottom: 34,right: 16,),
                  child: FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () {
                      Navigator .of(context).push(
                        MaterialPageRoute(builder: (context) {
                          return EditCard(conf: Setting(id: 0, cardColor: 10,)); // カード編集画面へ
                        }),
                      ).then((value) async {reload();});
                    },
                  ),
                ),
              ]
          );
        },
      ),
    );
  }

  void reload() async {
    List<Setting> sets = await SQLite.getSetting();
    setState(() {
      config = sets;
    });
  }
  // 削除処理
  void deleteItem(int id) async{
    await SQLite.deleteSetting(id);
    reload();
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
      confirmDismiss: (direction){return processing.deleteAlertDialog(context);},
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
          reload();
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
