import 'package:flutter/material.dart';
import 'package:oil_tracker/models/record.dart';
import 'package:oil_tracker/repo/record_repo.dart';
import 'package:oil_tracker/repo/record_repo_sqflite.dart';
import 'package:oil_tracker/screens/new_record.dart';
import 'package:oil_tracker/screens/record_list.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // final RecordRepo _recordRepo = RecordRepoMemoryImpl();
  final RecordRepo _recordRepo = RecordRepoSqfliteImpl();
  late Future<List<Record>> _records;

  @override
  void initState() {
    super.initState();
    _records = _recordRepo.getRecords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Center(
          child: FutureBuilder<List<Record>>(
            future: _records,
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? RecordList(
                      records: snapshot.data!,
                      deleteFunc: _deleteFunc,
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    );
            },
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
        return NewRecord(addRecord: _newRecordFunc);
      },
    );
  }

  void _newRecordFunc(Record record) async {
    _recordRepo.newRecord(record).whenComplete(
          () => setState(() {
            _records = _recordRepo.getRecords();
          }),
        );
  }

  void _deleteFunc(String id) {
    _recordRepo.deleteRecord(id).whenComplete(
          () => setState(() {
            _records = _recordRepo.getRecords();
          }),
        );
  }
}
