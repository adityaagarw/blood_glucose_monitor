import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../helpers/database_helper.dart';
import '../../models/glucose_reading.dart';

class TableScreen extends StatelessWidget {
  const TableScreen(); //{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Glucose Tracker - Table')),
      body: FutureBuilder<List<GlucoseReading>>(
        future: DatabaseHelper.instance.getAllReadings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error retrieving readings'));
          }

          final readings = snapshot.data ?? [];

          return ListView.builder(
            itemCount: readings.length,
            itemBuilder: (context, index) {
              final reading = readings[index];

              return ListTile(
                title: Text('Glucose Level: ${reading.glucoseLevel}'),
                subtitle: Text(
                    'Date: ${DateFormat("yyyy-MM-dd").format(reading.date)} ${reading.time.format(context)}'),
                trailing: Text('Type: ${reading.type}'),
              );
            },
          );
        },
      ),
    );
  }
}
