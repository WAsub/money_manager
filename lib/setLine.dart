import 'package:flutter/material.dart';
import 'package:money_manager/main.dart';
import 'package:money_manager/sqlite.dart';

class SetLine extends StatefulWidget {
  @override
  _SetLineState createState() => _SetLineState();
}

class _SetLineState extends State<SetLine> {
  TextEditingController myController1;
  TextEditingController myController2;

  @override
  void dispose() {
    myController1.dispose();
    myController2.dispose();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    myController1 = new TextEditingController(text: config[0].deadline.toString());
    myController2 = new TextEditingController(text: config[0].paymentDate.toString());
  }
  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(title: Text('クレジットマネージャ'),); // タイトルテキスト
    double appheight = appBar.preferredSize.height; //LayoutBuilderを使うとキーボード出した時縮む
    final double deviceHeight = MediaQuery.of(context).size.height - appheight;
    final double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: appBar,
      /******************************************************* AppBar*/
      body: SingleChildScrollView(
        reverse: true, // キーボード表示したら(画面が足りなくなったら)スクロール
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(), // キーボード外の画面タップでキーボードを閉じる
          child: Column(
            children: <Widget>[
              /** 締め日 */
                Row(
                  children: <Widget>[
                    Container(
                      width: deviceWidth * 0.1125,
                      child: Icon(Icons.credit_card, color: Colors.black45,),
                    ),
                    Container(
                      width: deviceWidth * 0.6375,
                      height: deviceHeight * 0.08,
                      alignment: Alignment.centerLeft,
                      child: Text("締め日", style: TextStyle(fontSize: deviceHeight * 0.025,),
                      ),
                    ),
                    Container(
                      width: deviceWidth * 0.1,
                      height: deviceHeight * 0.035,
                      child: TextField(
                        controller: myController1,
                        style: TextStyle(fontSize: deviceHeight * 0.025,),
                        textAlign: TextAlign.right,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Container(
                      width: deviceWidth * 0.15,
                      alignment: Alignment.centerLeft,
                      child: Text("日締め", style: TextStyle(fontSize: deviceHeight * 0.025,),),
                    ),
                  ],
                ),
              /** 支払日 */
              Row(
                  children: <Widget>[
                    Container(
                      width: deviceWidth * 0.1125,
                      child: Icon(Icons.credit_card, color: Colors.black45,),
                    ),
                    Container(
                      width: deviceWidth * 0.6375,
                      height: deviceHeight * 0.08,
                      alignment: Alignment.centerLeft,
                      child: Text("支払日", style: TextStyle(fontSize: deviceHeight * 0.025,),
                      ),
                    ),
                    Container(
                      width: deviceWidth * 0.1,
                      height: deviceHeight * 0.035,
                      child: TextField(
                        controller: myController2,
                        style: TextStyle(fontSize: deviceHeight * 0.025,),
                        textAlign: TextAlign.right,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Container(
                      width: deviceWidth * 0.15,
                      alignment: Alignment.centerLeft,
                      child: Text("日支払", style: TextStyle(fontSize: deviceHeight * 0.025,),),
                    ),
                  ],
                ),
              Container(
                padding: EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FlatButton(
                      minWidth: deviceWidth * 0.20,
                      onPressed: () async{
                        Setting setting = Setting(
                            deadline: myController1.text == "" ? 0 : int.parse(myController1.text),
                            paymentDate: myController2.text == "" ? 0 : int.parse(myController2.text),
                        );
                        await SQLite.updateSetting(setting);
                        Navigator.pop(context);
                      },
                      color: Theme.of(context).accentColor,
                      padding: EdgeInsets.all(10),
                      child: Icon(Icons.check),
                    )
                  ],
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }
}
