import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../models/glucose_reading.dart';
import '../../widgets/glucose_chart.dart';
import '../../helpers/database_helper.dart';

class GraphScreen extends StatefulWidget {
  @override
  _GraphScreenState createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  final List<String> _tabTypes = ['Fasting', 'PP', 'Pre-dinner', 'Bedtime'];
  int _selectedTab = 0;
  int _selectedScale = 7; // Initial scale is set to 7 days

  final List<int> _scales = [
    3,
    7,
    14,
    30,
    60,
    90,
    180,
    365
  ]; // Available scales in days

  List<GlucoseReading> _readings = [];

  @override
  void initState() {
    super.initState();
    _loadReadings();
  }

  Future<void> _loadReadings() async {
    List<GlucoseReading> readings =
        await DatabaseHelper.instance.getAllReadings();
    setState(() {
      _readings = readings;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Graph'),
        toolbarHeight: 50,
      ),
      body: Column(
        children: [
          Container(
            height: 30,
          ),
          _buildTabs(),
          Container(
            height: 30,
          ),
          _buildScaleButtons(),
          Container(
            height: 30,
          ),
          _buildChart(),
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

  Widget _buildScaleButtons() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8.0,
      runSpacing: 8.0,
      children: _scales.map((scale) {
        final isSelected = scale == _selectedScale;

        return ElevatedButton(
          onPressed: () {
            setState(() {
              _selectedScale = scale;
            });
          },
          style: ElevatedButton.styleFrom(
            primary: isSelected
                ? Color.fromARGB(255, 14, 15, 15)
                : Color.fromARGB(255, 50, 56, 56),
          ),
          child: Text(
            '$scale days',
            style: TextStyle(
              color: isSelected ? Colors.white : null,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildChart() {
    final List<GlucoseReading> filteredReadings = _readings
        .where((reading) => reading.type == _tabTypes[_selectedTab])
        .toList();

    final DateTime currentDate = DateTime.now();
    final DateTime startDate =
        currentDate.subtract(Duration(days: _selectedScale));

    final List<GlucoseReading> scaledReadings = filteredReadings
        .where((reading) => reading.date.isAfter(startDate))
        .toList();

    return GlucoseChart(readings: scaledReadings);
  }
}
