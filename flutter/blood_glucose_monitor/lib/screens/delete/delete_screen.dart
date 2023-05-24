import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../helpers/database_helper.dart';

class DeleteScreen extends StatefulWidget {
  const DeleteScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DeleteScreenState createState() => _DeleteScreenState();
}

class _DeleteScreenState extends State<DeleteScreen> {
  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _deleteReadingsByDateRange() async {
    if (_startDate != null && _endDate != null) {
      final deletedCount = await DatabaseHelper.instance
          .deleteReadingsByDateRange(_startDate!, _endDate!);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$deletedCount reading(s) deleted successfully!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delete Readings')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Delete Readings By Date Range',
                style: TextStyle(fontSize: 20)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 14, 15, 15),
                    ),
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _startDate = pickedDate;
                        });
                      }
                    },
                    child: Text(
                      _startDate != null
                          ? 'Start Date: ${DateFormat("yyyy-MM-dd").format(_startDate!)}'
                          : 'Select Start Date',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 14, 15, 15),
                    ),
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _endDate = pickedDate;
                        });
                      }
                    },
                    child: Text(
                      _endDate != null
                          ? 'End Date: ${DateFormat("yyyy-MM-dd").format(_endDate!)}'
                          : 'Select End Date',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
                child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 14, 15, 15),
              ),
              onPressed: _deleteReadingsByDateRange,
              child: const Text('Delete Readings'),
            )),
          ],
        ),
      ),
    );
  }
}
