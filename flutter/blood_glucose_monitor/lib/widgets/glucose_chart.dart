import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

import '../models/glucose_reading.dart';

class GlucoseChart extends StatelessWidget {
  final List<GlucoseReading> readings;

  GlucoseChart({required this.readings});

  @override
  Widget build(BuildContext context) {
    readings.sort((a, b) => a.date.compareTo(b.date)); // Sort readings by date

    return SfCartesianChart(
      primaryXAxis: CategoryAxis(
        majorGridLines: MajorGridLines(width: 0.5),
        labelRotation: -45,
      ),
      primaryYAxis: NumericAxis(
        minimum: _getYAxisMinimum(),
        maximum: _getYAxisMaximum(),
        interval: 10,
        labelFormat: '{value}',
        majorGridLines: MajorGridLines(width: 0.5),
        majorTickLines: MajorTickLines(size: 0),
        axisLine: AxisLine(width: 0),
      ),
      series: <LineSeries<GlucoseReading, String>>[
        LineSeries<GlucoseReading, String>(
          dataSource: readings,
          xValueMapper: (GlucoseReading reading, _) =>
              DateFormat("MM/dd").format(reading.date), // Format date to MM/dd
          yValueMapper: (GlucoseReading reading, _) =>
              reading.glucoseLevel.toDouble(),
          dataLabelSettings: DataLabelSettings(isVisible: true),
          enableTooltip: true,
          markerSettings: MarkerSettings(isVisible: true),
        ),
      ],
    );
  }

  double _getYAxisMinimum() {
    if (readings.isNotEmpty) {
      final minValue = readings
          .map((reading) => reading.glucoseLevel)
          .reduce((a, b) => a < b ? a : b)
          .toDouble();
      return (minValue / 10).floor() * 10;
    } else {
      return 50;
    }
  }

  double _getYAxisMaximum() {
    if (readings.isNotEmpty) {
      final maxValue = readings
          .map((reading) => reading.glucoseLevel)
          .reduce((a, b) => a > b ? a : b)
          .toDouble();
      return (maxValue / 10).ceil() * 10;
    } else {
      return 350;
    }
  }
}
