import 'package:sek/wishListDatabase/wlDatabaseService.dart';
import 'package:sek/wishListDatabase/wlModel.dart';
import 'package:sqflite/sqflite.dart';

class WListDatabase {
  final tableName = 'wishList_db';
  Future<void> createTable(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $tableName(
      "id" INTEGER NOT NULL,
      "bookName" TEXT NOT NULL,
      "author" TEXT NOT NULL,
      "publisher" TEXT NOT NULL,
      "address" TEXT NOT NULL,
      PRIMARY KEY("id" AUTOINCREMENT)
    );""");
  }

  Future<int> create(
      {required String bookName,
      required String author,
      required String publisher}) async {
    final database = await WListDatabaseService().database;
    return await database.rawInsert(
      '''INSERT INTO $tableName (bookName, author, publisher, address) VALUES (?, ?, ?, '')''',
      [bookName, author, publisher],
    );
  }

  Future<List<WList>> fetchAll() async {
    final database = await WListDatabaseService().database;
    final wlist = await database.rawQuery('''SELECT * from $tableName''');
    return wlist.map((wish) => WList.fromSqfliteDatabase(wish)).toList();
  }

  Future<void> delete(int id) async {
    final database = await WListDatabaseService().database;
    await database.rawDelete('''DELETE FROM $tableName WHERE id = ?''', [id]);
  }

  Future<void> updateAddress(int id, String newAddress) async {
    final database = await WListDatabaseService().database;
    await database.rawUpdate(
        '''UPDATE $tableName SET address = ? WHERE id = ?''', [newAddress, id]);
  }
}
