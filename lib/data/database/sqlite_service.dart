import 'dart:io';

import 'package:excel/excel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../domain/entities/user_entity.dart';

class SqliteService {
  late Database _db;

  Future<void> initializeDB() async {
    String path = await getDatabasesPath();

    _db = await openDatabase(
      join(path, 'database.db'),
      onCreate: (database, version) async {
        await database.execute("CREATE TABLE Users("
            "id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "fullName TEXT NOT NULL, "
            "userGroup TEXT NOT NULL, "
            "phoneNumber TEXT NOT NULL UNIQUE"
            ")");
      },
      version: 1,
    );
  }

  Future<void> insertUser(User user) async {
    await _db.insert('Users', user.toMap());
  }

  Future<List<User>> getUsersList() async {
    final List<Map<String, Object?>> queryResult =
        await _db.query('Users', orderBy: 'fullName');
    return queryResult.map((e) => User.fromMap(e)).toList();
  }

  Future deleteTable() async {
    await _db.delete('Users');
  }

  Future<List<List<String>>> readExcelData(String filePath) async {
    var file = File(filePath);
    var bytes = await file.readAsBytes();
    var excel = Excel.decodeBytes(bytes);
    List<List<String>> users = [];

    for (var table in excel.tables.keys) {
      for (var row in excel.tables[table]!.rows) {
        List<String> user = [];
        List<String> parts = row.toString().split(', ');

        for (String part in parts) {
          if (part.startsWith('[Data(')) {
            String data = part.substring('[Data('.length);
            user.add(data);
          }
          if (part.startsWith('Data(')) {
            String data = part.substring('Data('.length);
            user.add(data);
          }
        }
        if (user.isNotEmpty) {
          users.add(user);
        }
      }
    }
    return users;
  }
}
