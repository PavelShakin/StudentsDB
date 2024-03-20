import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../domain/entities/user_entity.dart';

class SqliteService {

  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();

    return openDatabase(
      join(path, 'database.db'),
      onCreate: (database, version) async {
        await database.execute(
            "CREATE TABLE Users("
                "id INTEGER PRIMARY KEY AUTOINCREMENT, "
                "fullName TEXT NOT NULL, "
                "userGroup TEXT NOT NULL, "
                "phoneNumber TEXT NOT NULL"
                ")"
        );
      },
      version: 1,
    );
  }
  
  Future createUser(User user) async {
    final Database db = await initializeDB();
    await db.insert(''
        'Users',
        user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }
  
  Future<List<User>> getUsersList() async {
    final db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('Users', orderBy: 'fullName');
    return queryResult.map((e) => User.fromMap(e)).toList();
  }

  Future deleteTable() async {
    final db = await initializeDB();
    await db.delete('Users');
  }
}