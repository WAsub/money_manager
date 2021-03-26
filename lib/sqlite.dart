import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:money_manager/processing.dart';

class Money {
  int id;
  List<String> image;
  int money;
  String date;

  Money({this.id, this.image, this.money, this.date});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image': image,
      'money': money,
      'date': date,
    };
  }
  @override
  String toString() {
    return 'Memo{id: $id, image: $image, money: $money, date: $date}';
  }
}
class Setting {
  int deadline;
  int paymentDate;

  Setting({this.deadline, this.paymentDate,});

  Map<String, dynamic> toMap() {
    return {
      'deadline': deadline,
      'paymentDate': paymentDate,
    };
  }
  @override
  String toString() {
    return 'Memo{deadline: $deadline, paymentDate: $paymentDate}';
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
              "date TEXT"
              ")",
        );
        await db.execute(
          "CREATE TABLE images("
              "id INTEGER PRIMARY KEY AUTOINCREMENT, "
              "fid INTEGER , "
              "image TEXT)",
        );
        await db.execute(
          "CREATE TABLE setting("
              "deadline INTEGER , "
              "paymentDate INTEGER)",
        );
        await db.execute(
          'INSERT INTO setting VALUES(15, 10)',
        );
        // テスト用
        await db.execute(
          'INSERT INTO moneys(money, date) VALUES(1000, "2021-01-01")',
        );
        await db.execute(
          'INSERT INTO moneys(money, date) VALUES(1000, "2021-01-03")',
        );
        await db.execute(
          'INSERT INTO moneys(money, date) VALUES(257, "2021-01-03")',
        );
        await db.execute(
          'INSERT INTO moneys(money, date) VALUES(8000, "2021-01-07")',
        );
      },
      version: 1,
    );
    return _database;
  }

  /// 金額リスト(日付順、ひと月分)取得用
  static Future<List<Money>> getMoneys(int year, int month, int day) async {
    // 設定を取得
    List<Setting> config = await getSetting();
    // 取得する期間を設定
    var ds;
    var de;
    if(day <= config[0].deadline){
      ds =  DateTime(year, month - 1);
      de =  DateTime(year, month);
    }else{
      ds =  DateTime(year, month);
      de =  DateTime(year, month + 1);
    }
    String Dstart = ds.year.toString()+'-'+processing.doubleDigit(ds.month)+'-'+(config[0].deadline+1).toString();
    String Dend = de.year.toString()+'-'+processing.doubleDigit(de.month)+'-'+config[0].deadline.toString();

    final Database db = await database;
    // リストを取得
    final List<Map<String, dynamic>> maps_moneys = await db.rawQuery(
        'SELECT * FROM moneys WHERE date >= "$Dstart" AND date <="$Dend" ORDER BY date'
    );
    List<Money> list = [];
    for(int i = 0; i < maps_moneys.length; i++){
      list.add( Money(
            id: maps_moneys[i]['id'],
            image: [],
            money: maps_moneys[i]['money'],
            date: maps_moneys[i]['date'],
          ));
    }
    return list;
  }
  /// 写真リストを取得し、元リストに追加
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
  /// 最大ID取得用
  static Future<List<Money>> getMaxMoneyID() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps_moneys = await db.rawQuery(
        'SELECT MAX(id),money,date FROM moneys'
    );
    List<Money> list = [];
    for(int i = 0; i < maps_moneys.length; i++){
      list.add( Money(
        id: maps_moneys[i]['MAX(id)'],
        image: [],
        money: maps_moneys[i]['money'],
        date: maps_moneys[i]['date'],
      ));
    }
    return list;
  }
  /// 金額&写真登録用
  static Future<void> insertMoney(Money money) async {
    final Database db = await database;
    // 金額を登録
    await db.rawInsert(
        'INSERT INTO moneys(money, date) VALUES (?, ?)',
        [money.money, money.date]
    );
    if(money.image.length == 0) // 写真がなかったら後の処理は飛ばす
      return;
    // 写真を登録
    var list = await getMaxMoneyID(); // さっき登録したID取得
    insertImgs(list[0].id, money.image);
  }
  /// 写真登録用
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
      'UPDATE moneys SET money = ?, date = ? WHERE id = ?',
      [money.money, money.date, money.id]
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
    final List<Map<String, dynamic>> maps = await db.query('setting');
    List<Setting> list = [];
    for(int i = 0; i < maps.length; i++){
      list.add( Setting(
        deadline: maps[i]['deadline'],
        paymentDate: maps[i]['paymentDate'],
      ));
    }

    return list;
  }
  /// 設定更新用
  static Future<void> updateSetting(Setting config) async {
    final db = await database;
    await db.update(
      'setting',
      config.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }
}