import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:oil_tracker/models/record.dart';
import 'package:oil_tracker/repo/record_repo.dart';
import 'package:uuid/uuid.dart';

const recordTableName = "records";

class RecordRepoSqfliteImpl implements RecordRepo {
  @override
  Future<void> deleteRecord(String id) async {
    await DbRepo.delete(recordTableName, id);
  }

  @override
  Future<List<Record>> getRecords() async {
    final data = await DbRepo.getData(recordTableName);
    return data
        .map(
          (row) => Record(
            id: row['id'],
            title: row['title'],
            currentDistance: row['current_distance'],
            date: DateTime.fromMillisecondsSinceEpoch(row['date']),
          ),
        )
        .toList();
  }

  @override
  Future<Record> newRecord(Record record) async {
    var uuid = const Uuid();
    var newRecord = Record(
      id: uuid.v1(),
      title: record.title,
      currentDistance: record.currentDistance,
      date: record.date,
    );

    await DbRepo.insert(recordTableName, {
      'id': newRecord.id,
      'title': newRecord.title,
      'current_distance': newRecord.currentDistance,
      'date': newRecord.date.millisecondsSinceEpoch,
    });
    return newRecord;
  }
}

class DbRepo {
  static Future<sql.Database> getDb() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'oil_tracker.db'),
      onCreate: (db, v) {
        return db.execute('CREATE TABLE records('
            'id TEXT PRIMARY KEY, '
            'title TEXT, '
            'current_distance INTEGER, '
            'date INTEGER)');
      },
      version: 1,
    );
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final sqlDb = await getDb();
    await sqlDb.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<int> delete(String table, String id) async {
    final sqlDb = await getDb();
    return await sqlDb.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final sqlDb = await getDb();
    return sqlDb.query(table, orderBy: "date DESC");
  }
}
