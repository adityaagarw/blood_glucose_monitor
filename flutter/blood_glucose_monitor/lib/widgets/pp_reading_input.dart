import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/pp_reading.dart';

class PPReadingInput extends StatefulWidget {
  final Function addReading;

  PPReadingInput(this.addReading);

  @override
  _PPReadingInputState createState() => _PPReadingInputState();
}

class _PPReadingInputState extends State<PPReadingInput> {
  final _nameFocusNode = FocusNode();
  final _nameController = TextEditingController();
  final _glucoseController = TextEditingController();
  DateTime _selectedDate;

  void _submitData() {
    if (_glucoseController.text.isEmpty) {
      return;
    }

    final enteredName = _nameController.text;
    final enteredGlucose = double.parse(_glucoseController.text);

    if (enteredName.isEmpty || _selectedDate == null) {
      return;
    }

    widget.addReading(
      PPReading(
        id: DateTime.now().toString(),
        name: enteredName,
        glucose: enteredGlucose,
        date: _selectedDate,
      ),
    );

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Food Name'),
                textInputAction: TextInputAction.next,
                onSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_nameFocusNode);
                },
                controller: _nameController,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Glucose'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                controller: _glucoseController,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'No Date Chosen'
                          : 'Picked Date: ${DateFormat.yMd().format(_selectedDate)}',
                    ),
                  ),
                  TextButton(
                    onPressed: _presentDatePicker,
                    child: Text(
                      'Choose Date',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: _submitData,
                child: Text('Add Reading'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}