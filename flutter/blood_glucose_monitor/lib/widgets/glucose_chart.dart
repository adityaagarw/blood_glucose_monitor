import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/glucose_reading.dart';

class GlucoseChart extends StatelessWidget {
  final List<GlucoseReading> readings;

  GlucoseChart({required this.readings});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: DateTimeAxis(),
      series: <LineSeries<GlucoseReading, String>>[
        LineSeries<GlucoseReading, String>(
          dataSource: readings,
          xValueMapper: (GlucoseReading reading, _) =>
              reading.date.toString(), // Convert DateTime to string
          yValueMapper: (GlucoseReading reading, _) =>
              reading.glucoseLevel.toDouble(),
        ),
      ],
    );
  }
}
