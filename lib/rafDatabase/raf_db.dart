import 'package:sek/rafDatabase/rafDatabaseService.dart';
import 'package:sek/rafDatabase/rafModel.dart';
import 'package:sqflite/sqflite.dart';

class RafDatabase {
  final tableName = 'raf_db';
  Future<void> createTable(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $tableName(
      "id" INTEGER NOT NULL,
      "rafName" TEXT NOT NULL,
      PRIMARY KEY("id" AUTOINCREMENT)
    );""");
  }

  Future<int> create({required String rafName}) async {
    final database = await RafDatabaseService().database;
    return await database
        .rawInsert('''INSERT INTO $tableName (rafName) VALUES(?)''', [rafName]);
  }

  Future<List<Raf>> fetchAll() async {
    final database = await RafDatabaseService().database;
    final rafs = await database.rawQuery('''SELECT * from $tableName''');
    return rafs.map((raf) => Raf.fromSqfliteDatabase(raf)).toList();
  }

  Future<void> update(int id, String rafName) async {
    final database = await RafDatabaseService().database;
    await database.rawUpdate(
        '''UPDATE $tableName SET rafName = ? WHERE id = ?''', [rafName, id]);
  }

  Future<void> delete(int id) async {
    final database = await RafDatabaseService().database;
    await database.rawDelete('''DELETE FROM $tableName WHERE id = ?''', [id]);
  }
}
