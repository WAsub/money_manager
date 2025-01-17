import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:money_manager/processing.dart';

class Money {
  int id;
  List<String> image;
  int money;
  String memo;
  String date;
  int cid;

  Money({this.id, this.image, this.money, this.memo, this.date, this.cid,});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image': image,
      'money': money,
      'memo': memo,
      'date': date,
      'cid': cid,
    };
  }
  @override
  String toString() {
    return 'Memo{id: $id, image: $image, money: $money, memo: $memo, date: $date, cid: $cid}';
  }
}
class Setting {
  int id;
  String cardName;
  int cardOrder;
  int cardColor;
  int deadline;
  int paymentDate;

  Setting({this.id, this.cardName, this.cardOrder, this.cardColor, this.deadline, this.paymentDate,});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cardName': cardName,
      'cardOrder': cardOrder,
      'cardColor': cardColor,
      'deadline': deadline,
      'paymentDate': paymentDate,
    };
  }
  @override
  String toString() {
    return 'Memo{id: $id, cardName: $cardName, cardOrder: $cardOrder, cardColor: $cardColor, deadline: $deadline, paymentDate: $paymentDate}';
  }
}


class SQLite{
  static Future<Database> get database async {
    final Future<Database> _database = openDatabase(
      join(await getDatabasesPath(), 'money_database.db'),
      onCreate: (db, version) async{
        await db.execute(
          "CREATE TABLE moneys("
              "id INTEGER PRIMARY KEY AUTOINCREMENT, "
              "money INTEGER, "
              "memo TEXT, "
              "date TEXT, "
              "cid INTEGER"
              ")",
        );
        await db.execute(
          "CREATE TABLE images("
              "id INTEGER PRIMARY KEY AUTOINCREMENT, "
              "fid INTEGER, "
              "image TEXT"
              ")",
        );
        await db.execute(
          "CREATE TABLE setting("
              "id INTEGER PRIMARY KEY AUTOINCREMENT, "
              "cardName TEXT, "
              "cardOrder INTEGER, "
              "cardColor INTEGER, "
              "deadline INTEGER, "
              "paymentDate INTEGER"
              ")",
        );
        await db.execute(
          'INSERT INTO setting(cardName, cardOrder, cardColor, deadline, paymentDate) VALUES("クレジットカード", 1, 10, 25, 10)',
        );
        // await db.execute(
        //   'INSERT INTO setting(cardName, cardOrder, cardColor, deadline, paymentDate) VALUES("JCB2", 2, 0, 15, 10)',
        // );
        // テスト用
        // await db.execute(
        //   'INSERT INTO moneys(money, memo, date, cid) VALUES(1000, "aa", "2021-04-01", 1)',
        // );
        // await db.execute(
        //   'INSERT INTO moneys(money, memo, date, cid) VALUES(1000, "aaa", "2021-04-03", 1)',
        // );
        // await db.execute(
        //   'INSERT INTO moneys(money, memo, date, cid) VALUES(257, "d", "2021-04-03", 2)',
        // );
        // await db.execute(
        //   'INSERT INTO moneys(money, memo, date, cid) VALUES(8000, "あf", "2021-04-07", 2)',
        // );

      },
      version: 1,
    );
    return _database;
  }

  /// 金額リスト(日付順、ひと月分)取得用
  static Future<List<List<Money>>> getMoneys(int year, int month, int day) async {
    // 設定を取得
    List<Setting> config = await getSetting();
    // 取得する期間を設定
    var ds;
    var de;
    List<List<Money>> list = [];
    for(int i = 0; i <= config.length; i++){
      list.add([]);
    }
    for(int j = 1; j < config.length; j++){
      if(config[j].deadline == 32){
        ds =  DateTime(year, month);
        de =  DateTime(year, month);
      }else if(day <= config[j].deadline){
        ds =  DateTime(year, month - 1);
        de =  DateTime(year, month);
      }else{
        ds =  DateTime(year, month);
        de =  DateTime(year, month + 1);
      }

      String Dstart = ds.year.toString()+'-'+processing.doubleDigit(ds.month)+'-'+
          processing.doubleDigit(
              config[j].deadline == 32 ? 1 : config[j].deadline+1
          );
      String Dend = de.year.toString()+'-'+processing.doubleDigit(de.month)+'-'+
          processing.doubleDigit(
              processing.legalDay(de.year, de.month, config[j].deadline)
          );

      final Database db = await database;
      // リストを取得
      final List<Map<String, dynamic>> maps_moneys = await db.rawQuery(
        'SELECT * FROM moneys WHERE (date >= ? AND date <= ?) AND cid = ? ORDER BY date',
        [Dstart, Dend, config[j].id]
      );
      for(int i = 0; i < maps_moneys.length; i++){
        list[config[j].cardOrder].add(Money(
          id: maps_moneys[i]['id'],
          image: [],
          money: maps_moneys[i]['money'],
          memo: maps_moneys[i]['memo'],
          date: maps_moneys[i]['date'],
          cid: maps_moneys[i]['cid'],
        ));
      }
      list[config[j].cardOrder] = await getImages(list[config[j].cardOrder]);
    }
    return list;
  }
  // 写真リストを取得し、元リストに追加
  static Future<List<Money>> getImages(List<Money> Mlist) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps_images = await db.query('images');
    var list = Mlist;
    for(int i = 0; i < maps_images.length; i++){
      for(int j = 0; j < list.length; j++){
        list[j].id ==  maps_images[i]['fid'] ? list[j].image.add(maps_images[i]['image']) : null;
      }
    }
    return list;
  }
  // 最大ID取得用
  static Future<int> getMaxMoneyID() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT MAX(id) FROM moneys'
    );
    int reMax = maps[0]['MAX(id)'];
    return reMax;
  }
  /// 金額&写真登録用
  static Future<void> insertMoney(Money money) async {
    final Database db = await database;
    // 金額を登録
    await db.rawInsert(
        'INSERT INTO moneys(money, memo, date, cid) VALUES (?, ?, ?, ?)',
        [money.money, money.memo, money.date, money.cid]
    );
    if(money.image.length == 0) // 写真がなかったら後の処理は飛ばす
      return;
    // 写真を登録
    int maxID = await getMaxMoneyID(); // さっき登録したID取得
    insertImgs(maxID, money.image);
  }
  // 写真登録用
  static Future<void> insertImgs(int id, List<String> imgs) async {
    final Database db = await database;
    for(int i = 0; i < imgs.length; i++){
      await db.rawInsert(
          'INSERT INTO images(fid, image) VALUES (?, ?)',
          [id, imgs[i]]
      );
    }
  }
  /// 金額更新用
  static Future<void> updateMoney(Money money) async {
    final db = await database;
    await db.rawUpdate(
      'UPDATE moneys SET money = ?, memo = ?, date = ?, cid = ? WHERE id = ?',
      [money.money, money.memo, money.date, money.cid, money.id]
    );
    deleteImgs(money.id);
    insertImgs(money.id, money.image);
  }
  /// 金額&写真削除用
  static Future<void> deleteMoneyAndImgs(int id) async {
    final db = await database;
    await db.delete(
      'moneys',
      where: "id = ?",
      whereArgs: [id],
    );
    deleteImgs(id);
  }
  // 写真削除用
  static Future<void> deleteImgs(int id) async {
    final db = await database;
    await db.delete(
      'images',
      where: "fid = ?",
      whereArgs: [id],
    );
  }

  /// 設定取得用
  static Future<List<Setting>> getSetting() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM setting ORDER BY cardOrder',
    );
    List<Setting> list = [null,];
    for(int i = 0; i < maps.length; i++){
      list.add( Setting(
        id: maps[i]['id'],
        cardName: maps[i]['cardName'],
        cardOrder: maps[i]['cardOrder'],
        cardColor: maps[i]['cardColor'],
        deadline: maps[i]['deadline'],
        paymentDate: maps[i]['paymentDate'],
      ));
    }
    return list;
  }
  /// 設定登録用
  static Future<void> insertSetting(Setting config) async {
    final db = await database;
    int order = await countSetting() + 1;
    await db.rawInsert(
        'INSERT INTO setting(cardName, cardOrder, cardColor, deadline, paymentDate) VALUES (?, ?, ?, ?, ?)',
        [config.cardName, order, config.cardColor, config.deadline, config.paymentDate,]
    );
  }
  // カードの数取得用
  static Future<int> countSetting() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT COUNT(id) FROM setting',
    );
    int reCnt = maps[0]['COUNT(id)'];
    return reCnt;
  }
  /// 設定更新用
  static Future<void> updateSetting(Setting config) async {
    final db = await database;
    await db.rawUpdate(
      'UPDATE setting SET cardName = ?, cardOrder = ?, cardColor = ?, deadline = ?, paymentDate = ? WHERE id = ?',
      [config.cardName, config.cardOrder, config.cardColor, config.deadline, config.paymentDate, config.id,]
    );
  }
  /// 設定削除用
  static Future<void> deleteSetting(int id) async {
    final db = await database;
    await db.delete(
      'setting',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}