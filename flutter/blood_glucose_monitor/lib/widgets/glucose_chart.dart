import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import '../models/glucose_reading.dart';

class GlucoseChart extends StatelessWidget {
  final List<GlucoseReading> readings;

  GlucoseChart({required this.readings});

  List<charts.Series<GlucoseReading, DateTime>> _createSeries() {
    return [
      _createReadingSeries('Fasting'),
      _createReadingSeries('PP'),
      _createReadingSeries('Pre-dinner'),
      _createReadingSeries('Bedtime'),
    ];
  }

  charts.Series<GlucoseReading, DateTime> _createReadingSeries(String type) {
    final data = readings.where((reading) => reading.type == type).toList();
    return charts.Series<GlucoseReading, DateTime>(
      id: type,
      colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (reading, _) => reading.dateTime,
      measureFn: (reading, _) => reading.glucoseLevel,
      data: data,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: charts.TimeSeriesChart(
        _createSeries(),
        animate: true,
        animationDuration: Duration(milliseconds: 500),
        defaultRenderer: charts.LineRendererConfig(),
        behaviors: [
          charts.ChartTitle('Glucose Levels',
              behaviorPosition: charts.BehaviorPosition.top,
              titleOutsideJustification: charts.OutsideJustification.middleDrawArea),
          charts.ChartTitle('Time',
              behaviorPosition: charts.BehaviorPosition.bottom,
              titleOutsideJustification: charts.OutsideJustification.middleDrawArea),
        ],
      ),
    );
  }
}