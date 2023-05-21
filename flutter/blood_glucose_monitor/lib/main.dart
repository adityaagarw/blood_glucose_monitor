import 'package:flutter/material.dart';

import 'screens/home/home_screen.dart';
import 'screens/graph/graph_screen.dart';
import 'screens/table/table_screen.dart';
import 'screens/delete/delete_screen.dart';
import 'models/glucose_reading.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final List<GlucoseReading> readings = []; // Replace with your actual data

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blood Glucose Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Blood Glucose Tracker'),
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.home)),
                Tab(icon: Icon(Icons.show_chart)),
                Tab(icon: Icon(Icons.table_chart)),
                Tab(icon: Icon(Icons.delete)),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              HomeScreen(),
              GraphScreen(readings: readings),
              TableScreen(),
              DeleteScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
