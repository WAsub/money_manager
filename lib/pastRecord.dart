import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:money_manager/sqlite.dart';
import 'package:money_manager/main.dart';
import 'package:money_manager/viewImg.dart';
import 'package:money_manager/add.dart';
import 'package:money_manager/record.dart';

class PastRecord extends StatefulWidget {
  int nowid;
  PastRecord({Key key, this.nowid}) : super(key: key);
  @override
  _PastRecordState createState() => _PastRecordState();
}

class _PastRecordState extends State<PastRecord> {
  @override
  Widget build(BuildContext context) {
    double deviceHeight;
    double deviceWidth;

    return Scaffold(
      appBar: AppBar(title: Text('クレジットマネージャ'),), // タイトルテキスト
      /******************************************************* AppBar*/
      body: Record(nowid: widget.nowid,),
    );
  }
}
