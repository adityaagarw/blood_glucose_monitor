import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../models/glucose_reading.dart';
import '../widgets/delete_dialog.dart';

class GlucoseTable extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _GlucoseTableState createState() => _GlucoseTableState();
}

class _GlucoseTableState extends State<GlucoseTable> {
  List<GlucoseReading> _readings = [];

  @override
  void initState() {
    super.initState();
    _loadReadings();
  }

  Future<void> _loadReadings() async {
    final readings = await DatabaseHelper.instance.getAllReadings();
    setState(() {
      _readings = readings;
    });
  }

  Future<void> _deleteReading(String readingId) async {
    await DatabaseHelper.instance.deleteReading(readingId);
    await _loadReadings();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Reading deleted successfully'),
      ),
    );
  }

  Future<void> _showDeleteDialog(String readingId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteDialog(
          readingId: readingId,
          onDelete: _deleteReading,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _readings.length,
      itemBuilder: (BuildContext context, int index) {
        final reading = _readings[index];
        return ListTile(
          title: Text('Glucose Level: ${reading.glucoseLevel}'),
          subtitle: Text('Date: ${reading.date}, Type: ${reading.type}'),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteDialog(reading.id),
          ),
        );
      },
    );
  }
}
