import 'package:flutter/material.dart';
import '../../helpers/database_helper.dart';
import '../../models/glucose_reading.dart';

class TableScreen extends StatefulWidget {
  final List<GlucoseReading> glucoseReadings;

  TableScreen({required this.glucoseReadings});

  @override
  _TableScreenState createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  List<GlucoseReading> _sortedReadings;

  @override
  void initState() {
    super.initState();
    _sortedReadings = List.from(widget.glucoseReadings);
    _sortedReadings.sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  void _deleteReading(GlucoseReading reading) {
    setState(() {
      widget.glucoseReadings.remove(reading);
      _sortedReadings.remove(reading);
    });
  }

  void _deleteReadingsInRange(DateTime startDate, DateTime endDate) {
    setState(() {
      widget.glucoseReadings
          .removeWhere((reading) => reading.dateTime.isAfter(startDate) && reading.dateTime.isBefore(endDate));
      _sortedReadings
          .removeWhere((reading) => reading.dateTime.isAfter(startDate) && reading.dateTime.isBefore(endDate));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blood Glucose Tracker'),
      ),
      body: GlucoseTable(
        readings: _sortedReadings,
        onDelete: _deleteReading,
        onDeleteRange: _deleteReadingsInRange,
      ),
    );
  }
}