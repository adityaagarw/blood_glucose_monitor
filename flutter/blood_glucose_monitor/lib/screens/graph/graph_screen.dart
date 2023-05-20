import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../../helpers/database_helper.dart';
import '../../models/glucose_reading.dart';

class GraphScreen extends StatefulWidget {
  @override
  _GraphScreenState createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  int _selectedTabIndex = 0;
  List<GlucoseReading> _readings = [];
  List<charts.Series<GlucoseReading, DateTime>> _seriesList = [];

  final _tabs = [
    Tab(text: 'Fasting'),
    Tab(text: 'PP'),
    Tab(text: 'Pre-dinner'),
    Tab(text: 'Bedtime'),
  ];

  @override
  void initState() {
    super.initState();
    _loadReadings();
  }

  Future<void> _loadReadings() async {
    final readings = await DatabaseHelper().getReadings();
    setState(() {
      _readings = readings;
      _seriesList = _buildSeriesList(readings);
    });
  }

  List<charts.Series<GlucoseReading, DateTime>> _buildSeriesList(List<GlucoseReading> readings) {
    return [
      _buildSeries(readings, 'Fasting', charts.ColorUtil.fromDartColor(Colors.red)),
      _buildSeries(readings, 'PP', charts.ColorUtil.fromDartColor(Colors.blue)),
      _buildSeries(readings, 'Pre-dinner', charts.ColorUtil.fromDartColor(Colors.green)),
      _buildSeries(readings, 'Bedtime', charts.ColorUtil.fromDartColor(Colors.purple)),
    ];
  }

  charts.Series<GlucoseReading, DateTime> _buildSeries(List<GlucoseReading> readings, String type, charts.Color color) {
    final data = readings.where((reading) => reading.type == type).toList();
    return charts.Series<GlucoseReading, DateTime>(
      id: type,
      colorFn: (_, __) => color,
      domainFn: (reading, _) => DateTime(reading.date.year, reading.date.month, reading.date.day, reading.time.hour, reading.time.minute),
      measureFn: (reading, _) => reading.glucoseLevel,
      data: data,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Glucose Tracker - Graph'),
      ),
      body: Column(
        children: [
          TabBar(
            tabs: _tabs,
            isScrollable: true,
            onTap: (index) => setState(() => _selectedTabIndex = index),
          ),
          Expanded(
            child: charts.TimeSeriesChart(
              _seriesList[_selectedTabIndex].data,
              animate: true,
              dateTimeFactory: const charts.LocalDateTimeFactory(),
              behaviors: [
                charts.SeriesLegend(
                  position: charts.BehaviorPosition.bottom,
                  horizontalFirst: false,
                  desiredMaxRows: 1,
                  cellPadding: EdgeInsets.only(right: 4.0, bottom: 4.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}