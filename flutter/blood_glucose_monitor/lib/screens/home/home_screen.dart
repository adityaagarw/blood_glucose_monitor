import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../helpers/database_helper.dart';
import '../../models/glucose_reading.dart';
import '../../models/pp_reading.dart';

class HomeScreen extends StatefulWidget {
  @override
   _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedType = 'Fasting';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  int _glucoseLevel;
  String _foodName;

  void _submitForm() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    final newReading = GlucoseReading(
      glucoseLevel: _glucoseLevel,
      type: _selectedType,
      date: _selectedDate,
      time: _selectedTime,
      foodName: _selectedType == 'PP' ? _foodName : null,
    );
    // TODO: Save newReading to database
    _showSnackBar('Reading added successfully!');
  }

  void _showSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2050),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _selectTime(BuildContext context) async {
    final TimeOfDay pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Blood Glucose Tracker'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GlucoseInput(
                  onSaved: (value) {
                    _glucoseLevel = int.tryParse(value);
                  },
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: GestureDetector(
                        onTap: () => _selectDate(context),
                        child: Text(
                          'Date: ${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}',
                        ),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Flexible(
                      child: GestureDetector(
                        onTap: () => _selectTime(context),
                        child: Text(
                          'Time: ${_selectedTime.hour}:${_selectedTime.minute}',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  value: _selectedType,
                  items: ['Fasting', 'PP', 'Pre-dinner', 'Bedtime']
                      .map((type) => DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Type of Reading',
                  ),
                ),
                if (_selectedType == 'PP')
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Food Name',
                    ),
                    onSaved: (value) {
                      _foodName = value.trim();
                    },
                  ),
                SizedBox(height: 32.0),
                RaisedButton(
                  onPressed: _submitForm,
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}