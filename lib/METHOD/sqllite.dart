import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

final String columnId = "id";
final String columnUserId = "userid";
final String columnName = "name";
final String columnAge = "age";
final String columnPass = "password";
final String tableName = 'account';

class Account {
  int id;
  String userId;
  String name;
  String password;
  int age;

  Account({
    this.id,
    this.userId,
    this.name,
    this.password,
    this.age,
  });

  factory Account.fromMap(Map<String, dynamic> json) => new Account(
        id: json[columnId],
        userId: json[columnUserId],
        name: json[columnName],
        password: json[columnPass],
        age: json[columnAge],
      );

  Map<String, dynamic> toMap() => {
        columnUserId: userId,
        columnName: name,
        columnAge: age,
        columnPass: password,
      };
}

class AccountProvider {
  AccountProvider._();

  static final AccountProvider db = AccountProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "account.db");
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE $tableName ("
          "$columnId INTEGER PRIMARY KEY AUTOINCREMENT,"
          "$columnUserId TEXT,"
          "$columnName TEXT,"
          "$columnAge INTEGER,"
          "$columnPass TEXT"
          ")");
    });
  }

  insertAccount(Account acc) async {
    final db = await database;
    // var table =
    //     await db.rawQuery("SELECT MAX($columnId)+1 as $columnId FROM Subject");
    // int id = table.first[columnId];
    // var raw = await db.rawInsert(
    //     "INSERT Into Subject ($columnId,$columnTitle,$columnDone)"
    //     " VALUES (?,?,?)",
    //     [id, newSubject.title, newSubject.done]);
    // return raw;
    acc.id = await db.insert(tableName, acc.toMap());
    print(acc.id);
    return acc;
  }

  Future<List<Account>> getDoneTodo() async {
    final db = await database;

    // var res = await db.rawQuery("SELECT * FROM Subject WHERE done=1");
    var res = await db.query(tableName, where: "done = ? ", whereArgs: [1]);

    List<Account> list =
        res.isNotEmpty ? res.map((c) => Account.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<Account>> getUnDoneTodo() async {
    final db = await database;

    // var res = await db.rawQuery("SELECT * FROM Subject WHERE done=1");
    var res = await db.query(tableName, where: "done = ? ", whereArgs: [0]);

    List<Account> list =
        res.isNotEmpty ? res.map((c) => Account.fromMap(c)).toList() : [];
    return list;
  }

  deleteDone() async {
    final db = await database;
    db.rawDelete("Delete from $tableName where $columnName = 1");
  }

  Future<Account> getAccount(String id, String pass) async {
    final db = await database;
    List<Map<String, dynamic>> res;
    try {
      res = await db.rawQuery("Select * from $tableName where $columnUserId = $id and $columnPass = $pass");
    } catch (e) {
      res = [];
    }

    return res.length > 0 ? Account.fromMap(res.first) : null;
  }

  // ------------------- UN USE METHOD -------------------

  updateAccount(Account newAccount) async {
    final db = await database;
    var res = await db.update(tableName, newAccount.toMap(),
        where: "$columnId = ?", whereArgs: [newAccount.id]);
    return res;
  }

  Future<List<Account>> getAllAccount() async {
    final db = await database;
    var res = await db.query(tableName);
    List<Account> list =
        res.isNotEmpty ? res.map((c) => Account.fromMap(c)).toList() : [];
    return list;
  }

  // deleteSubject(int id) async {
  //   final db = await database;
  //   return db.delete(tableName, where: "$columnId = ?", whereArgs: [id]);
  // }

  // deleteAll() async {
  //   final db = await database;
  //   db.rawDelete("Delete from Subject");
  // }
}
