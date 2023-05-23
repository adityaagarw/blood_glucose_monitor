import 'package:flutter/material.dart';
import '../../models/glucose_reading.dart';
import '../../widgets/glucose_chart.dart';

class GraphScreen extends StatefulWidget {
  final List<GlucoseReading> readings;

  GraphScreen({required this.readings});

  @override
  _GraphScreenState createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  final List<String> _tabTypes = ['Fasting', 'PP', 'Pre-dinner', 'Bedtime'];
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Graph'),
      ),
      body: Column(
        children: [
          _buildTabs(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: _buildChart(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _tabTypes.map((type) {
        final index = _tabTypes.indexOf(type);
        final isSelected = index == _selectedTab;
        final color = isSelected ? Colors.blue : Colors.grey;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedTab = index;
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: color),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              type,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildChart() {
    final List<GlucoseReading> filteredReadings = widget.readings
        .where((reading) => reading.type == _tabTypes[_selectedTab])
        .toList();

    return GlucoseChart(readings: filteredReadings);
  }
}
