import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:money_manager/sqlite.dart';
import 'package:money_manager/processing.dart';

class Add extends StatefulWidget {
  Money money;
  Add({Key key, this.money}) : super(key: key);
  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {
  final _picker = ImagePicker();
  List<String> _images = List<String>();
  int _year;
  int _month;
  int _days;
  var myController = TextEditingController();
  String _error;

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    if(widget.money.id != 0){
      _year = int.parse(widget.money.date.split('-')[0]);
      _month = int.parse(widget.money.date.split('-')[1]);
      _days = int.parse(widget.money.date.split('-')[2]);
      _images.addAll(widget.money.image);
      myController = TextEditingController(text: widget.money.money.toString());
    }else{
      _year = DateTime.now().year;
      _month = DateTime.now().month;
      _days = DateTime.now().day;
    }
    super.initState();
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
              child: Container(
                height: deviceHeight,
                child: Column(
                  children: <Widget>[
                    Stack( // 重ねるレイアウト
                      children: <Widget>[
                        /** 写真 */
                        Container(
                          height: deviceHeight * 0.4,
                          color: Colors.grey[300],
                          child: buildGridView(context,deviceWidth, deviceHeight * 0.4),
                        ),
                        /** ボタン */
                        Container(
                          height: deviceHeight * 0.4,
                          padding: EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              FlatButton(
                                onPressed: _getImageFromCamera,
                                color: Color.fromARGB(150, 100, 100, 100),
                                height: deviceHeight * 0.4 * 0.2,
                                minWidth: deviceHeight * 0.4 * 0.25,
                                padding: EdgeInsets.all(5),
                                child: Icon(Icons.camera_alt),
                                shape: CircleBorder(),
                              ),
                              // 選択
                              FlatButton(
                                onPressed: _getImageFromGallery,
                                color: Color.fromARGB(150, 100, 100, 100),
                                height: deviceHeight * 0.4 * 0.2,
                                minWidth: deviceHeight * 0.4 * 0.25,
                                padding: EdgeInsets.all(5),
                                child: Icon(Icons.insert_photo),
                                shape: CircleBorder(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    /** 日付ドロップダウンリスト */
                    _dropdownDate(),
                    /** 金額入力 */
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: deviceWidth - deviceHeight * 0.05,
                          child: TextField(
                            controller: myController,
                            decoration: new InputDecoration(labelText: "金額を入力してください。"),
                            style: TextStyle(fontSize: deviceHeight * 0.04,),
                            textAlign: TextAlign.right,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        Container(
                          width: deviceHeight * 0.04,
                          padding: EdgeInsets.only(bottom: deviceHeight * 0.01,),
                          child: Text("円", style: TextStyle(fontSize: deviceHeight * 0.04,),),
                        ),
                      ],
                    ),
                    /** 確定ボタン */
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FlatButton(
                          onPressed: () async{
                            Money _money = Money(
                                image: _images,
                                money: myController.text == "" ? 0 : int.parse(myController.text),
                                date: _year.toString()+'-'+processing.doubleDigit(_month)+'-'+processing.doubleDigit(_days)
                            );
                            if(widget.money.id == 0){
                              await SQLite.insertMoney(_money);
                            }else{
                              _money.id = widget.money.id;
                              await SQLite.updateMoney(_money);
                            }
                            Navigator.pop(context);
                          },
                          color: Theme.of(context).accentColor,
                          padding: EdgeInsets.all(5),
                          child: Icon(Icons.check),
                        )
                      ],
                    ),
                  ],
                ),
              ),

            ),
          ),
    );
  }
  /// 写真選択(カメラなし)
  Future _getImageFromGallery() async {
    List<Asset> resultList;
    String error;
    int maximg = 5 - _images.length;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: maximg, /// 選択できる最大枚数指定
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    if (!mounted) return;

    List<String> img64 = [];

    for(int i = 0; i < resultList.length; i++){
      var bytedata = await resultList[i].getByteData();
      List<int> imageData = bytedata.buffer.asUint8List();
      img64.add(base64Encode(imageData));
    }

    setState(() {
      _images.addAll(img64);
      if (error == null) _error = 'No Error Dectected';
    });
  }
  /// 写真選択(カメラあり)
  Future _getImageFromCamera() async {
    if(_images.length == 5)
      return;

    final _pickedFile = await _picker.getImage(source: ImageSource.camera);

    var bytedata = await File(_pickedFile.path).readAsBytes();
    List<int> imageData = bytedata.buffer.asUint8List();
    String img64 = base64Encode(imageData);

    setState(() {
      if (_pickedFile != null) {
        _images.add(img64);
      }
    });
  }
  /// レイアウト割
  Widget buildGridView(con,deviceWidth, imgHeight) {
    if (_images == null || _images.length == 0) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
        ),
      );
    } else {
      return Container(
        width: deviceWidth,
        child: multiImgContainer(con,deviceWidth, imgHeight),
      );
    }
  }
  Widget multiImgContainer(con,deviceWidth, imgHeight){
    List<List<List<double>>> imgSize = [ // 枚数によってレイアウト変える
      [[1,1],],
      [[0.5,1], [0.5,1],],
      [[0.5,1], [0.5,0.5], [0.5,0.5],],
      [[0.5,1], [0.5,0.5], [0.25,0.5], [0.25,0.5],],
      [[0.5,1], [0.25,0.5], [0.25,0.5], [0.25,0.5], [0.25,0.5],],
    ];
    List<Widget> _imgItem = [];
    for(int i = 0; i < _images.length; i++){
      _imgItem.add(
          InkWell(
            onTap: () async {
              bool flg = await showDialog(
                  context: con,
                  builder: (_) => AlertDialog(
                    content: Container( // 写真
                      color: Colors.grey[300],
                      child: Image.memory(
                        base64Decode(_images[i]),
                      ),
                    ),
                    actions: <Widget>[
                      // ボタン領域
                      FlatButton(
                        child: Text("キャンセル"),
                        onPressed: () => Navigator.of(con).pop(false),
                      ),
                      FlatButton(
                        child: Text("削除"),
                        onPressed: () => Navigator.of(con).pop(true),
                      ),
                    ],
                  )
              );
              if(flg){
                setState(() {
                  _images.removeAt(i);
                });
              }
            },
            child: Image.memory(
              base64Decode(_images[i]),
              fit: BoxFit.fill,
              width: deviceWidth * imgSize[_images.length-1][i][0],
              height: imgHeight * imgSize[_images.length-1][i][1],
            ),
          )
      );
    }
    // 並べて返す
    switch(_images.length){
      case 1:
        return _imgItem[0];
      case 2:
        return Row(
          children: [
            _imgItem[0],
            _imgItem[1],
          ],
        );
      case 3:
        return Row(
          children: [
            _imgItem[0],
            Column(
              children: [
                _imgItem[1], _imgItem[2],
              ],
            )
          ],
        );
      case 4:
        return Row(
          children: [
            _imgItem[0],
            Column(
              children: [
                _imgItem[1],
                Row(children: [_imgItem[2],_imgItem[3]],),
              ],
            )
          ],
        );
      case 5:
        return Row(
          children: [
            _imgItem[0],
            Column(
              children: [
                Row(children: [_imgItem[1],_imgItem[2]],),
                Row(children: [_imgItem[3],_imgItem[4]],),
              ],
            )
          ],
        );
      default:
        return Row(
          children: [
            _imgItem[0],
            Column(
              children: [
                Row(children: [_imgItem[1],_imgItem[2]],),
                Row(children: [_imgItem[3],_imgItem[4]],),
              ],
            )
          ],
        );
    }

  }

  /// 写真選択(カメラあり)未使用
  // Future<void> cameraAssets() async {
  //   setState(() {
  //     // images = List<Asset>();
  //     _images = List<String>();
  //   });
  //
  //   List<Asset> resultList;
  //   String error;
  //
  //   try {
  //     resultList = await MultiImagePicker.pickImages(
  //       maxImages: 5, /// 選択できる最大枚数指定
  //       enableCamera: true,
  //       cupertinoOptions: CupertinoOptions(
  //         autoCloseOnSelectionLimit: true,
  //       ),
  //     );
  //   } on Exception catch (e) {
  //     error = e.toString();
  //   }
  //
  //   if (!mounted) return;
  //
  //   List<String> img64 = [];
  //
  //   for(int i = 0; i < resultList.length; i++){
  //     var bytedata = await resultList[i].getByteData();
  //     List<int> imageData = bytedata.buffer.asUint8List();
  //     img64.add(base64Encode(imageData));
  //   }
  //
  //   setState(() {
  //     _images = img64;
  //     if (error == null) _error = 'No Error Dectected';
  //   });
  // }

  /// 日付選択ドロップダウン
  Widget _dropdownDate(){
    // リストを用意
    List<int> Y = [];
    List<int> M = [1,2,3,4,5,6,7,8,9,10,11,12];
    List<int> D = [];
    // 2000年から10年後までをリストに入れる
    for(int i = 2000; i < DateTime.now().year+10; i++)
      Y.add(i);
    /** 年 */
    var widgetY  =
      DropdownButton<int>(
        value: _year,
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 30,
        elevation: 16,
        onChanged: (newValue) {
          setState(() {
            _year = newValue;
            _month = null; // 値があわることがあるため一旦nullに TODO
            _days = null;
          });
        },
        // Yをセット
        items: Y.map<DropdownMenuItem<int>>((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text(value.toString()),
          );
        }).toList(),
      );
    /** 月 */
    var widgetM =
      DropdownButton<int>(
        value: _month,
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 30,
        elevation: 16,
        onChanged: (newValue) {
          setState(() {
            _month = newValue;
            _days = null; // 値があわることがあるため一旦nullに TODO
          });
        },
        // Mをセット
        items: M.map<DropdownMenuItem<int>>((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text(value.toString()),
          );
        }).toList(),
      );

    // 選択されている月によって値が変わる
    switch(_month){
      case 2:case 4:case 6:case 9:case 11:
        // 2月
        if(_month == 2){
          // 閏年
          bool flg = false;
          if(_year % 4 == 0){
            if(_year % 100 == 0){
              if(_year % 400 == 0)
                flg = true;
            }else{
              flg = true;
            }
          }
          if(flg){
            for(int i = 1; i <= 29; i++)
              D.add(i);
          // 閏年じゃない
          }else{
            for(int i = 1; i <= 28; i++)
              D.add(i);
          }
        // 2月じゃない
        }else{
          for(int i = 1; i <= 30; i++)
            D.add(i);
        }
        break;
      default:
        // 31日の月
        for(int i = 1; i <= 31; i++)
          D.add(i);
        break;
    }
    /** 日 */
    var widgetD =
    DropdownButton<int>(
      value: _days,
      icon: Icon(Icons.arrow_drop_down),
      iconSize: 30,
      elevation: 16,
      onChanged: (newValue) {
        setState(() {
          _days = newValue;
        });
      },
      // Dをセット
      items: D.map<DropdownMenuItem<int>>((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
    );
    /** 横に3つ並べる */
    return Row(children: <Widget>[widgetY,widgetM,widgetD,]);
  }
}
