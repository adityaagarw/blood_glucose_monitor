import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/glucose_reading.dart';
import '../models/pp_reading.dart';
import '../helpers/database_helper.dart';
import '../widgets/pp_reading_input.dart';

class GlucoseInput extends StatelessWidget {
  final Function(String) onSaved;

  GlucoseInput({@required this.onSaved});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Glucose Level',
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter a glucose level.';
        }
        final glucoseLevel = int.tryParse(value);
        if (glucoseLevel == null || glucoseLevel < 0 || glucoseLevel > 999) {
          return 'Please enter a valid glucose level.';
        }
        return null;
      },
      onSaved: onSaved,
    );
  }
}