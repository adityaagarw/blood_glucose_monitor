import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../models/glucose_reading.dart';

class GlucoseTable extends StatelessWidget {
  final List<GlucoseReading> readings;
  final Function(GlucoseReading) onDelete;
  final Function(DateTime, DateTime) onDeleteRange;

  GlucoseTable({@required this.readings, this.onDelete, this.onDeleteRange});

  void _showDeleteConfirmationDialog(BuildContext context, GlucoseReading reading) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Reading?'),
        content: Text('Are you sure you want to delete this reading?'),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          FlatButton(
            onPressed: () {
              onDelete(reading);
              Navigator.pop(context);
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showRangeDeleteConfirmationDialog(BuildContext context) {
    final startDateController = TextEditingController();
    final endDateController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Readings?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: startDateController,
              decoration: InputDecoration(
                labelText: 'Start Date',
                hintText: 'YYYY-MM-DD',
              ),
            ),
            TextField(
              controller: endDateController,
              decoration: InputDecoration(
                labelText: 'End Date',
                hintText: 'YYYY-MM-DD',
              ),
            ),
          ],
        ),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          FlatButton(
            onPressed: () {
              final startDate = DateTime.tryParse(startDateController.text);
              final endDate = DateTime.tryParse(endDateController.text);
              if (startDate != null && endDate != null) {
                onDeleteRange(startDate, endDate);
              }
              Navigator.pop(context);
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  TableRow _buildHeaderRow() {
    return TableRow(
      children: [
        _buildHeaderCell('Date'),
        _buildHeaderCell('Time'),
        _buildHeaderCell('Type'),
        _buildHeaderCell('Glucose Level'),
        _buildHeaderCell('Actions'),
      ],
    );
  }

  Widget _buildHeaderCell(String text) {
    return TableCell(
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

    TableRow _buildReadingRow(BuildContext context, GlucoseReading reading) {
    return TableRow(
      children: [
        _buildCell('${reading.date.year}-${reading.date.month}-${reading.date.day}'),
        _buildCell('${reading.time.hour}:${reading.time.minute}'),
        _buildCell(reading.type),
        _buildCell(reading.glucoseLevel.toString()),
        _buildActionCell(context, reading),
      ],
    );
  }

  Widget _buildCell(String text) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(text),
      ),
    );
  }

  Widget _buildActionCell(BuildContext context, GlucoseReading reading) {
    return TableCell(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _showDeleteConfirmationDialog(context, reading);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: _buildColumns(),
        rows: _buildRows(context),
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    return [
      DataColumn(label: Text('Date')),
      DataColumn(label: Text('Time')),
      DataColumn(label: Text('Type')),
      DataColumn(label: Text('Glucose Level')),
      DataColumn(label: Text('Actions')),
    ];
  }

  List<DataRow> _buildRows(BuildContext context) {
    final rows = <DataRow>[];
    rows.add(_buildHeaderRow());
    for (final reading in readings) {
      rows.add(DataRow(cells: _buildReadingCells(context, reading)));
    }
    return rows;
  }

  List<DataCell> _buildReadingCells(BuildContext context, GlucoseReading reading) {
    return [
      DataCell(Text('${reading.date.year}-${reading.date.month}-${reading.date.day}')),
      DataCell(Text('${reading.time.hour}:${reading.time.minute}')),
      DataCell(Text(reading.type)),
      DataCell(Text(reading.glucoseLevel.toString())),
      DataCell(
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _showDeleteConfirmationDialog(context, reading);
              },
            ),
          ],
        ),
      ),
    ];
  }
}