import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oil_tracker/models/record.dart';
import 'package:oil_tracker/screens/widgets/adaptive_button.dart';

class NewRecord extends StatefulWidget {
  final Function addRecord;

  const NewRecord({
    Key? key,
    required this.addRecord,
  }) : super(key: key);

  @override
  _NewRecordState createState() => _NewRecordState();
}

class _NewRecordState extends State<NewRecord> {
  final titleController = TextEditingController();
  final currentDistanceController = TextEditingController();
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            left: 10,
            top: 10,
            right: 10,
            bottom: mediaQuery.viewInsets.bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Title'),
                controller: titleController,
              ),
              TextField(
                decoration:
                    const InputDecoration(labelText: 'Current Distance'),
                controller: currentDistanceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: false,
                ),
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(selectedDate == null
                          ? 'No date chosen!'
                          : DateFormat().format(selectedDate!)),
                    ),
                    AdaptiveButton(
                      title: "Choose Date",
                      handler: _showDatePicker,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Add'),
                style: TextButton.styleFrom(
                  foregroundColor: theme.textTheme.button?.color,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    var enteredTitle = titleController.text;
    var enteredCurrentDistance = int.tryParse(currentDistanceController.text);

    if (enteredCurrentDistance == null || selectedDate == null) {
      return;
    }
    if (enteredTitle.isEmpty || enteredCurrentDistance <= 0) {
      return;
    }

    var record = Record(
      id: "",
      title: enteredTitle,
      currentDistance: enteredCurrentDistance,
      date: selectedDate!,
    );

    widget.addRecord(record);
    Navigator.of(context).pop();
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      selectedDate = pickedDate;
      _showTimePicker();
    });
  }

  void _showTimePicker() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((pickedTime) {
      if (pickedTime == null) {
        return;
      }

      setState(() {
        selectedDate = selectedDate!.add(
          Duration(hours: pickedTime.hour, minutes: pickedTime.minute),
        );
      });
    });
  }
}
