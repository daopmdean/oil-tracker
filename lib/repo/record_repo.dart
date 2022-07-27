import 'package:oil_tracker/models/record.dart';

abstract class RecordRepo {
  List<Record> getRecords();
  Record newRecord(Record record);
  void deleteRecord(String id);
}
