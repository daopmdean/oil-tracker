import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oil_tracker/models/record.dart';

class RecordList extends StatelessWidget {
  const RecordList({
    Key? key,
    required this.records,
    required this.deleteFunc,
  }) : super(key: key);

  final List<Record> records;
  final Function deleteFunc;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);

    return records.isEmpty
        ? Column(
            children: const [
              SizedBox(height: 10),
              Text('No record yet!'),
              SizedBox(height: 20),
            ],
          )
        : ListView.builder(
            itemCount: records.length,
            itemBuilder: (ctx, index) {
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 8,
                ),
                child: ListTile(
                  title: Text(
                    '${records[index].title} - ${records[index].currentDistance}',
                    style: theme.textTheme.headline6,
                  ),
                  subtitle: Text(
                    DateFormat().format(records[index].date),
                  ),
                  trailing: mediaQuery.size.width > 400
                      ? TextButton.icon(
                          onPressed: () => deleteFunc(records[index].id),
                          icon: Icon(
                            Icons.delete,
                            color: theme.errorColor,
                          ),
                          label: Text(
                            'Delete',
                            style: TextStyle(
                              color: theme.errorColor,
                            ),
                          ),
                        )
                      : IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext ctx) {
                                return AlertDialog(
                                  title: const Text('Please Confirm'),
                                  content: const Text('Remove the record?'),
                                  actions: [
                                    // The "Yes" button
                                    TextButton(
                                        onPressed: () {
                                          deleteFunc(records[index].id);
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Yes')),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('No'))
                                  ],
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.delete),
                          color: theme.errorColor,
                        ),
                ),
              );
            },
          );
  }
}
