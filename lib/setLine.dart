import 'package:flutter/material.dart';
import 'package:money_manager/main.dart';
import 'package:money_manager/sqlite.dart';

class SetLine extends StatefulWidget {
  @override
  _SetLineState createState() => _SetLineState();
}

class _SetLineState extends State<SetLine> {
  List<TextEditingController> deadlineController = [];
  List<TextEditingController> paymentDateController = [];
  // TextEditingController myController1;
  // TextEditingController myController2;

  @override
  void dispose() {
    // myController1.dispose();
    // myController2.dispose();
    for(int i = 1; i < config.length; i++){
      deadlineController[i].dispose();
      paymentDateController[i].dispose();
    }
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    // myController1 = new TextEditingController(text: config[0].deadline.toString());
    // myController2 = new TextEditingController(text: config[0].paymentDate.toString());
    deadlineController = [null,];paymentDateController = [null,];
    for(int i = 1; i < config.length; i++){
      deadlineController.add(new TextEditingController(text: config[i].deadline.toString()));
      paymentDateController.add(new TextEditingController(text: config[i].paymentDate.toString()));
    }
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          double constraintsHeight = constraints.maxHeight;
          double constraintsWidth = constraints.maxWidth;

          return SingleChildScrollView(
            reverse: true, // キーボード表示したら(画面が足りなくなったら)スクロール
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(), // キーボード外の画面タップでキーボードを閉じる
              child: Column(
                  children: <Widget>[
                    Container(
                      height: constraintsHeight - 60,
                      child: ListView.separated(
                        itemCount: config.length,
                        itemBuilder: (context, index) {
                          if(index == 0){
                            return Container(height: 0,
                            );
                          }
                          return Column(
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
                                        controller: deadlineController[index],
                                        style: TextStyle(fontSize: deviceHeight * 0.025,),
                                        textAlign: TextAlign.right,
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                    Container(
                                      width: deviceWidth * 0.15,
                                      alignment: Alignment.centerLeft,
                                      child: Text("日締め", style: TextStyle(fontSize: deviceHeight * 0.02,),),
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
                                        controller: paymentDateController[index],
                                        style: TextStyle(fontSize: deviceHeight * 0.025,),
                                        textAlign: TextAlign.right,
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                    Container(
                                      width: deviceWidth * 0.15,
                                      alignment: Alignment.centerLeft,
                                      child: Text("日支払", style: TextStyle(fontSize: deviceHeight * 0.02,),),
                                    ),
                                  ],
                                ),

                              ]
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(height:3,);
                        },
                      ),
                    ),
                    Container(
                      height: 60,
                      padding: EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FlatButton(
                            minWidth: deviceWidth * 0.20,
                            onPressed: () async{
                              // List<Setting> setting = [null,];
                              // for(int i = 1; i < config.length; i++){
                              //   setting.add(Setting(id: config[i].id, cardName: config[i].cardName, cardOrder: config[i].cardOrder,
                              //     deadline: deadlineController[i].text == "" ? 30 : int.parse(deadlineController[i].text),
                              //     paymentDate: paymentDateController[i].text == "" ? 30 : int.parse(paymentDateController[i].text),
                              //   ));
                              // }
                              // await SQLite.updateSetting(setting);
                              // Navigator.pop(context);
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
          );
        }
        )
    );
  }
}
