import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../models/glucose_reading.dart';

class PPReadingInput extends StatefulWidget {
  @override
  _PPReadingInputState createState() => _PPReadingInputState();
}

class _PPReadingInputState extends State<PPReadingInput> {
  final _glucoseController = TextEditingController();
  final _timeController = TextEditingController();
  final _foodController = TextEditingController();
  String _selectedType = 'Fasting';

  void _submitReading() async {
    final glucoseLevel = int.tryParse(_glucoseController.text);
    final time =
        TimeOfDay.fromDateTime(DateTime.now()); // Use current time as TimeOfDay

    if (glucoseLevel != null) {
      final reading = GlucoseReading(
        id: DateTime.now().toString(),
        glucoseLevel: glucoseLevel,
        date: DateTime.now(),
        time: time,
        type: _selectedType,
        food: _selectedType == 'PP' ? _foodController.text : null,
      );

      await DatabaseHelper.instance.insertReading(reading);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reading saved successfully'),
        ),
      );

      _glucoseController.clear();
      _timeController.clear();
      _foodController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Enter PP Reading',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: _glucoseController,
            decoration: const InputDecoration(labelText: 'Glucose Level'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 8.0),
          DropdownButtonFormField<String>(
            value: _selectedType,
            onChanged: (value) {
              setState(() {
                _selectedType = value!;
              });
            },
            items: ['Fasting', 'PP', 'Pre-dinner', 'Bedtime']
                .map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    ))
                .toList(),
            decoration: const InputDecoration(labelText: 'Reading Type'),
          ),
          if (_selectedType == 'PP')
            TextField(
              controller: _foodController,
              decoration: const InputDecoration(labelText: 'Food Name'),
            ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: _submitReading,
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _glucoseController.dispose();
    _timeController.dispose();
    _foodController.dispose();
    super.dispose();
  }
}
