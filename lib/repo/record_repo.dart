import 'package:oil_tracker/models/record.dart';

abstract class RecordRepo {
  Future<List<Record>> getRecords();
  Future<Record> newRecord(Record record);
  Future<void> deleteRecord(String id);
}
