import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../helpers/database_helper.dart';
import '../../models/glucose_reading.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _glucoseLevelController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  String _selectedType = 'Fasting';
  String? _selectedFood;

  @override
  void dispose() {
    _glucoseLevelController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      final glucoseLevel = int.tryParse(_glucoseLevelController.text);
      final dateFormat = DateFormat('yyyy-MM-dd');
      final timeFormat = DateFormat('hh:mm a');
      final date = dateFormat.parse(_dateController.text);
      final time =
          TimeOfDay.fromDateTime(timeFormat.parse(_timeController.text));
      print('Time: $time');

      if (glucoseLevel != null) {
        final reading = GlucoseReading(
          id: DateTime.now().toString(),
          date: date,
          time: time,
          type: _selectedType,
          glucoseLevel: glucoseLevel,
          food: _selectedType == 'PP' ? _selectedFood : null,
        );

        await DatabaseHelper.instance.insertReading(reading);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reading added successfully!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Glucose Level'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a glucose level';
                    }
                    return null;
                  },
                  controller: _glucoseLevelController,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Date'),
                  readOnly: true,
                  controller: _dateController,
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        final dateFormat = DateFormat('yyyy-MM-dd');
                        _dateController.text = dateFormat.format(pickedDate);
                        print('Producer Date: ${_dateController.text}');
                      });
                    }
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please select a date';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Time'),
                  readOnly: true,
                  controller: _timeController,
                  onTap: () async {
                    final pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      final formattedTime = DateFormat('hh:mm a').format(
                        DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                          DateTime.now().day,
                          pickedTime.hour,
                          pickedTime.minute,
                        ),
                      );
                      setState(() {
                        _timeController.text = formattedTime;
                        print('Producer Time: ${_timeController.text}');
                      });
                    }
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please select a time';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Type'),
                  value: _selectedType,
                  items: const ['Fasting', 'PP', 'Pre-dinner', 'Bedtime']
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a type';
                    }
                    return null;
                  },
                ),
                if (_selectedType == 'PP') ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Food'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a food';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _selectedFood = value;
                      });
                    },
                  ),
                ],
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 14, 15, 15),
                  ),
                  onPressed: _onSubmit,
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
