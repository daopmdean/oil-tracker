import 'package:flutter/material.dart';
import 'package:oil_tracker/models/record.dart';
import 'package:oil_tracker/repo/record_repo.dart';
import 'package:oil_tracker/repo/record_repo_memory.dart';
import 'package:oil_tracker/screens/new_record.dart';
import 'package:oil_tracker/screens/record_list.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final RecordRepo _recordRepo = RecordRepoMemoryImpl();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Center(
          child: RecordList(
            records: _recordRepo.getRecords(),
            deleteFunc: _deleteFunc,
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

  void _newRecordFunc(Record record) {
    setState(() {
      _recordRepo.newRecord(record);
    });
  }

  void _deleteFunc(String id) {
    setState(() {
      _recordRepo.deleteRecord(id);
    });
  }
}
