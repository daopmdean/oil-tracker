import 'package:oil_tracker/models/record.dart';
import 'package:oil_tracker/repo/record_repo.dart';
import 'package:uuid/uuid.dart';

class RecordRepoMemoryImpl implements RecordRepo {
  final List<Record> _records = [
    Record(
      id: '1',
      title: 'Nhot May',
      currentDistance: 1245,
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Record(
      id: '2',
      title: 'Nhot May',
      currentDistance: 4299,
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Record(
      id: '3',
      title: 'Nhot So',
      currentDistance: 8999,
      date: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  @override
  void deleteRecord(String id) {
    _records.removeWhere((r) => r.id == id);
  }

  @override
  List<Record> getRecords() {
    return _records;
  }

  @override
  Record newRecord(Record record) {
    var uuid = const Uuid();
    var newRecord = Record(
      id: uuid.v1(),
      title: record.title,
      currentDistance: record.currentDistance,
      date: record.date,
    );

    _records.add(newRecord);
    return newRecord;
  }
}
