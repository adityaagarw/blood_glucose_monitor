import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../helpers/database_helper.dart';
import 'package:blood_glucose_monitor/models/glucose_reading.dart';

class _ReadingDataSource extends DataGridSource {
  final List<GlucoseReading> readings;

  _ReadingDataSource(this.readings) {
    _buildDataGridRows();
  }

  void _buildDataGridRows() {
    dataGridRows = readings
        .map<DataGridRow>((reading) => DataGridRow(cells: [
              DataGridCell(columnName: 'date', value: reading.date),
              DataGridCell(columnName: 'time', value: reading.time),
              DataGridCell(columnName: 'reading', value: reading.glucoseLevel),
              DataGridCell(columnName: 'type', value: reading.type),
              DataGridCell(columnName: 'food', value: reading.food),
            ]))
        .toList();
  }

  @override
  List<DataGridRow> get rows => dataGridRows;
  List<DataGridRow> dataGridRows = [];

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        return Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: Text(cell.value.toString()),
        );
      }).toList(),
    );
  }
}

class TableScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _TableScreenState createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  late _ReadingDataSource _dataSource;
  final _dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final readings = await _dbHelper.getAllReadings();
    setState(() {
      _dataSource = _ReadingDataSource(readings);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Readings Table'),
      ),
      body: _dataSource != null
          ? SfDataGrid(
              source: _dataSource,
              columnWidthMode: ColumnWidthMode.auto,
              columns: [
                GridColumn(
                    columnName: 'date',
                    label: Text('Date'),
                    autoFitPadding: EdgeInsets.all(8)),
                GridColumn(
                    columnName: 'time',
                    label: Text('Time'),
                    autoFitPadding: EdgeInsets.all(8)),
                GridColumn(
                    columnName: 'reading',
                    label: Text('Reading'),
                    autoFitPadding: EdgeInsets.all(8)),
                GridColumn(
                    columnName: 'type',
                    label: Text('Type'),
                    autoFitPadding: EdgeInsets.all(8)),
                GridColumn(
                    columnName: 'food',
                    label: Text('Food'),
                    autoFitPadding: EdgeInsets.all(8)),
                GridColumn(
                  columnName: 'delete',
                  label: Text(''),
                  width: 60,
                  // cellBuilder: (context, details) {
                  //   final rowIndex = details.rowIndex;
                  //   return IconButton(
                  //     icon: Icon(Icons.delete),
                  //     onPressed: () => _showDeleteDialog(rowIndex),
                  //   );
                  // },
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  void _showDeleteDialog(int rowIndex) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Reading'),
        content: const Text('Are you sure you want to delete this reading?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final reading = _dataSource.readings[rowIndex];
              _dbHelper.deleteReading(reading.id);
              setState(() {
                _dataSource.readings.removeAt(rowIndex);
              });
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
