import 'package:flutter/material.dart';
import 'dart:convert';

class ViewImg extends StatefulWidget {
  List<String> imgs = [];
  ViewImg({Key key, this.imgs}) : super(key: key);
  @override
  _ViewImgState createState() => _ViewImgState();
}

class _ViewImgState extends State<ViewImg> {
  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(title: Text('クレジットマネージャ'),); // タイトルテキスト
    double appheight = appBar.preferredSize.height;
    final double deviceHeight = MediaQuery.of(context).size.height - appheight;
    final double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: appBar,
      /******************************************************* AppBar*/
      body: ListView.separated(
        itemCount: widget.imgs.length,
        itemBuilder: (context, index) {
          return Image.memory(
            base64Decode(widget.imgs[index]),
            fit: BoxFit.fitWidth,
          );
        },
        separatorBuilder: (context, index) {
          return Divider(height:3,);
        },
      ),
    );
  }
}
