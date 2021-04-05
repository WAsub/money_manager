import 'package:flutter/material.dart';
import 'package:money_manager/record.dart';

class SubCard extends StatefulWidget {
  int nowid;
  SubCard({Key key, this.nowid}) : super(key: key);
  @override
  _SubCardState createState() => _SubCardState();
}
class _SubCardState extends State<SubCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('クレジットマネージャ'),), // タイトルテキスト
      /**************************************************************** AppBar*/
      body: Record(nowid: widget.nowid,),
    );
  }
}
