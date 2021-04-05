import 'package:flutter/material.dart';
import 'package:money_manager/sqlite.dart';
import 'package:money_manager/main.dart';

class EditCard extends StatefulWidget {
  Setting conf;
  EditCard({Key key, this.conf}) : super(key: key);
  @override
  _EditCardState createState() => _EditCardState();
}

class _EditCardState extends State<EditCard> {
  var cardnameController = TextEditingController();
  var deadlineController = TextEditingController();
  var paymentDateController = TextEditingController();
  @override
  void dispose() {
    cardnameController.dispose();
    deadlineController.dispose();
    paymentDateController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    if(widget.conf.id != 0){
      cardnameController = TextEditingController(text: widget.conf.cardName);
      deadlineController = TextEditingController(text: widget.conf.deadline.toString());
      paymentDateController = TextEditingController(text: widget.conf.paymentDate.toString());
    }else{
      cardnameController = TextEditingController(text: "マイカード");
      deadlineController = TextEditingController(text: "25");
      paymentDateController = TextEditingController(text: "10");
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(title: Text('クレジットマネージャ'),); // タイトルテキスト
    double appheight = appBar.preferredSize.height; //LayoutBuilderを使うとキーボード出した時縮む
    final double deviceHeight = MediaQuery.of(context).size.height - appheight;
    final double deviceWidth = MediaQuery.of(context).size.width;

    List<List<Widget>> selectColor = [[],[]];
    for(int i = 0; i < cardColor.length; i++){
      var borderColor = i == widget.conf.cardColor ?  Colors.grey[600] : Colors.transparent;
      Widget circleButton = Container(
        width: deviceWidth / 8,
        child: FlatButton(
          color: cardColor[i],
          minWidth: 16,
          shape: CircleBorder(
              side: BorderSide(
                color: borderColor,
                width: 3,
              )
          ),
          onPressed: () async{
            setState(() {
              widget.conf.cardColor = i;
            });
          },
        ),
      );
      if(i < 8){
        selectColor[0].add(circleButton);
      }else{
        selectColor[1].add(circleButton);
      }
    }

    return Scaffold(
      appBar: appBar,
      /******************************************************* AppBar*/
      body: SingleChildScrollView(
        reverse: true, // キーボード表示したら(画面が足りなくなったら)スクロール
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(), // キーボード外の画面タップでキーボードを閉じる
          child: Container(
            color: Colors.transparent, // なぜかcolorを指定しておかないとFocusScope.of(context).unfocus()が機能しない
            height: deviceHeight,
            child: Column(
              children: <Widget>[
                /** カードカラー選択 */
                Container(
                  height: 121.0,
                  color: Colors.grey[300],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("カードカラー選択 :"),
                      Row(mainAxisAlignment: MainAxisAlignment.center,children: selectColor[0],),
                      Row(mainAxisAlignment: MainAxisAlignment.center,children: selectColor[1],),
                    ],
                  ),
                ),
                /** カード名入力 */
                Stack(
                  children: [
                    Container(
                      height: 88.0,
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: cardColor[widget.conf.cardColor], width: 11,))
                      ),
                    ),
                    Container(
                      height: 88.0,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("カード名 :"),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(left: 15,right: 15,),
                                  child: Icon(Icons.credit_card, color: cardColor[widget.conf.cardColor],),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 18,right: 15,),
                                  width: deviceWidth * 0.8,
                                  child: TextField(
                                    controller: cardnameController,
                                    decoration: new InputDecoration(labelText: "カードの名前を入力してください。", labelStyle: TextStyle(fontSize: 15,),),
                                    style: TextStyle(fontSize: 20,),
                                    textAlign: TextAlign.left,
                                    keyboardType: TextInputType.text,
                                  ),
                                ),
                              ],
                            ),
                          ]
                      ),
                    ),
                  ]
                ),
                /** 締め日 */
                Container(
                  height: 56.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 15,right: 15,),
                        child: Text("締め日 :", style: TextStyle(fontSize: 16,)),
                      ),
                      Expanded(child: Container(),), // 隙間いっぱい埋める
                      Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(left: 18,right: 15,),
                        width: 65,
                        child: TextField(
                          controller: deadlineController,
                          style: TextStyle(fontSize: 16,),
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 15,),
                        child: Text("日締め", style: TextStyle(fontSize: 16,),),
                      ),
                    ],
                  ),
                ),
                /** 支払日 */
                Container(
                  height: 56.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 15,right: 15,),
                        child: Text("支払日 :", style: TextStyle(fontSize: 16,)),
                      ),
                      Expanded(child: Container(),), // 隙間いっぱい埋める
                      Container(
                        padding: EdgeInsets.only(left: 18,right: 15,),
                        width: 65,
                        child: TextField(
                          controller: paymentDateController,
                          style: TextStyle(fontSize: 16,),
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 15,),
                        child: Text("日支払", style: TextStyle(fontSize: 16,),),
                      ),
                    ],
                  ),
                ),
                /** 確定ボタン */
                Container(
                  height: 56.0,
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    color: Theme.of(context).accentColor,
                    padding: EdgeInsets.all(10),
                    minWidth: deviceWidth * 0.20,
                    child: Icon(Icons.check),
                    onPressed: () async {
                      Setting set = Setting(
                        cardName: cardnameController.text == "" ? "マイカード" : cardnameController.text,
                        cardColor: widget.conf.cardColor,
                        deadline: deadlineController.text == "" ||
                            (int.parse(deadlineController.text) < 1 || int.parse(deadlineController.text) > 28)
                            ? 25 : int.parse(deadlineController.text),
                        paymentDate: paymentDateController.text == "" ||
                            (int.parse(paymentDateController.text) < 1 || int.parse(paymentDateController.text) > 28)
                            ? 10 : int.parse(paymentDateController.text),
                      );
                      if(widget.conf.id == 0){
                        await SQLite.insertSetting(set);
                      }else{
                        set.id = widget.conf.id;
                        set.cardOrder = widget.conf.cardOrder;
                        await SQLite.updateSetting(set);
                      }
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),

        ),
      ),
    );
  }
}
