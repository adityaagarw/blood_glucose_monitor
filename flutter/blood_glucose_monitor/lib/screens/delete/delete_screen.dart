import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../helpers/database_helper.dart';
import '../../models/glucose_reading.dart';

class DeleteScreen extends StatefulWidget {
  final List<GlucoseReading> glucoseReadings;

  DeleteScreen({@required this.glucoseReadings});

  @override
  _DeleteScreenState createState() => _DeleteScreenState();
}

class _DeleteScreenState extends State<DeleteScreen> {
  DateTime _startDate;
  DateTime _endDate;
  bool _showRangeForm = false;

  void _deleteReadings() {
    if (_showRangeForm) {
      if (_startDate != null && _endDate != null) {
        widget.glucoseReadings
            .removeWhere((reading) => reading.dateTime.isAfter(_startDate) && reading.dateTime.isBefore(_endDate));
      }
    } else {
      widget.glucoseReadings.clear();
    }
    Navigator.pop(context);
  }

  void _toggleRangeForm() {
    setState(() {
      _showRangeForm = !_showRangeForm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blood Glucose Tracker'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RaisedButton(
                onPressed: _toggleRangeForm,
                child: Text(_showRangeForm ? 'Clear Range' : 'Delete Range'),
              ),
              SizedBox(height: 16.0),
              if (_showRangeForm)
                DeleteForm(
                  onStartDateChanged: (value) {
                    setState(() {
                      _startDate = value;
                    });
                  },
                  onEndDateChanged: (value) {
                    setState(() {
                      _endDate = value;
                    });
                  },
                  onDelete: _deleteReadings,
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Are you sure you want to delete all readings?',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    SizedBox(height: 16.0),
                    RaisedButton(
                      onPressed: _deleteReadings,
                      child: Text('Delete All Readings'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}