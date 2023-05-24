import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:intl/intl.dart';
import '../../models/glucose_reading.dart';
import '../../helpers/database_helper.dart';

class _ReadingDataSource extends DataGridSource {
  _ReadingDataSource(List<GlucoseReading> readings) {
    _readings = readings;
    _sortReadings();
    _buildDataGridRows();
  }

  List<DataGridRow> _dataGridRows = [];
  List<GlucoseReading> _readings = [];

  void _sortReadings() {
    _readings.sort((a, b) {
      final aDateTime = DateTime(2000, 1, 1, a.time.hour, a.time.minute);
      final bDateTime = DateTime(2000, 1, 1, b.time.hour, b.time.minute);
      return bDateTime.compareTo(aDateTime);
    });
    _readings.sort((a, b) => b.date.compareTo(a.date));
  }

  void _buildDataGridRows() {
    _dataGridRows = _readings.map<DataGridRow>((reading) {
      return DataGridRow(cells: [
        DataGridCell<String>(
            columnName: 'date',
            value: DateFormat("yyyy-MM-dd").format(reading.date)),
        DataGridCell<String>(
            columnName: 'time',
            value:
                '${reading.time.hourOfPeriod}:${reading.time.minute.toString().padLeft(2, '0')} ${reading.time.period.toString().split('.').last}'),
        DataGridCell<int>(columnName: 'reading', value: reading.glucoseLevel),
        DataGridCell<String>(columnName: 'type', value: reading.type),
        DataGridCell<String>(columnName: 'food', value: reading.food ?? ''),
      ]);
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataCell) {
      return Container(
        padding: EdgeInsets.all(8),
        alignment: Alignment.center,
        child: Text(dataCell.value.toString()),
      );
    }).toList());
  }

  String getColumnNameByIndex(int index) {
    switch (index) {
      case 0:
        return 'date';
      case 1:
        return 'time';
      case 2:
        return 'reading';
      case 3:
        return 'type';
      case 4:
        return 'food';
      default:
        return '';
    }
  }

  void deleteReading(int index) async {
    final reading = _readings[index];
    await DatabaseHelper.instance.deleteReading(reading.id);
    _readings.removeAt(index);
    _buildDataGridRows();
    notifyListeners();
  }
}

class TableScreen extends StatefulWidget {
  @override
  _TableScreenState createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  _ReadingDataSource? _dataSource;

  @override
  void initState() {
    super.initState();
    _loadReadings();
  }

  Future<void> _loadReadings() async {
    List<GlucoseReading> readings =
        await DatabaseHelper.instance.getAllReadings();
    setState(() {
      _dataSource = _ReadingDataSource(readings);
    });
  }

  void _showDeleteConfirmationDialog(int rowIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Reading'),
          content: const Text('Are you sure you want to delete this reading?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                _deleteReading(rowIndex);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteReading(int rowIndex) {
    _dataSource?.deleteReading(rowIndex);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Entry deleted successfully!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_dataSource == null) {
      return CircularProgressIndicator();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Glucose Readings'),
      ),
      body: SfDataGrid(
        allowFiltering: true,
        gridLinesVisibility: GridLinesVisibility.both,
        source: _dataSource!,
        columnWidthMode: ColumnWidthMode.fill,
        columns: <GridColumn>[
          GridColumn(
            allowFiltering: true,
            allowSorting: true,
            filterIconPosition: ColumnHeaderIconPosition.start,
            filterIconPadding: EdgeInsets.all(0),
            sortIconPosition: ColumnHeaderIconPosition.end,
            columnName: 'date',
            width: 90,
            label: Text("Date"),
          ),
          GridColumn(
            allowFiltering: true,
            allowSorting: false,
            filterIconPosition: ColumnHeaderIconPosition.start,
            filterIconPadding: EdgeInsets.all(0),
            columnName: 'time',
            width: 76,
            label: Text("Time"),
          ),
          GridColumn(
            allowFiltering: false,
            allowSorting: false,
            filterIconPosition: ColumnHeaderIconPosition.start,
            filterIconPadding: EdgeInsets.all(0),
            columnName: 'reading',
            columnWidthMode: ColumnWidthMode.auto,
            width: 68,
            //label: Text("Reading"),
            label: Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.center,
              child: Text('Reading'),
            ),
          ),
          GridColumn(
            allowSorting: false,
            filterIconPosition: ColumnHeaderIconPosition.start,
            filterIconPadding: EdgeInsets.all(0),
            columnName: 'type',
            width: 82,
            label: Text('Type'),
          ),
          GridColumn(
            allowSorting: false,
            filterIconPosition: ColumnHeaderIconPosition.start,
            filterIconPadding: EdgeInsets.all(0),
            columnName: 'food',
            label: Text('Food'),
          ),
        ],
        onCellLongPress: (args) {
          final rowIndex = args.rowColumnIndex.rowIndex - 1;
          final columnIndex = args.rowColumnIndex.columnIndex;
          final columnName = _dataSource?.getColumnNameByIndex(columnIndex);
          if (columnName == 'date' || columnName == 'time') {
            _showDeleteConfirmationDialog(rowIndex);
          }
        },
        headerGridLinesVisibility: GridLinesVisibility.horizontal,
      ),
    );
  }
}
