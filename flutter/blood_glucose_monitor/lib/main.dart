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

  final ThemeData myTheme = ThemeData.dark().copyWith(
    // Customize the dark theme colors
    primaryColor: Colors.blueGrey[900],
    //accentColor: Colors.lightBlueAccent,
    scaffoldBackgroundColor: Colors.grey[900],
    backgroundColor: Colors.grey[800],
    cardColor: Colors.grey[800],
    // Customize the dark theme typography
    textTheme: TextTheme(
      headline6: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      // Customize other text styles as per your design requirements
    ),
  );
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blood Glucose Tracker',
      theme: myTheme,
      //theme: ThemeData(
      //  primarySwatch: Colors.lime,
      //),
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
              GraphScreen(),
              TableScreen(),
              DeleteScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
