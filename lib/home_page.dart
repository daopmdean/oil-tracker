import 'package:flutter/material.dart';
import 'package:oil_tracker/models/record.dart';
import 'package:oil_tracker/screens/new_record.dart';
import 'package:oil_tracker/screens/record_list.dart';
import 'package:uuid/uuid.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
      currentDistance: 42,
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Record(
      id: '3',
      title: 'Nhot So',
      currentDistance: 899,
      date: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Center(
          child: RecordList(
            records: _records,
            deleteFunc: _deleteRecord,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => startNewTransaction(context),
        tooltip: 'Add Record',
        child: const Icon(Icons.add),
      ),
    );
  }

  void startNewTransaction(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (_) {
        return NewRecord(addRecord: _newRecord);
      },
    );
  }

  void _newRecord(String title, int currentDistance, DateTime dateTime) {
    var uuid = const Uuid();
    var transaction = Record(
      id: uuid.v1(),
      title: title,
      currentDistance: currentDistance,
      date: dateTime,
    );

    setState(() {
      _records.add(transaction);
    });
  }

  void _deleteRecord(String id) {
    setState(() {
      _records.removeWhere((trx) => trx.id == id);
    });
  }
}
