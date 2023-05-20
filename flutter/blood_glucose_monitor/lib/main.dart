import 'package:flutter/material.dart';
import 'screens/home/home_screen.dart';
import 'screens/graph/graph_screen.dart';
import 'screens/table/table_screen.dart';
import 'screens/delete/delete_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Glucose Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
      routes: {
        '/graph': (_) => GraphScreen(),
        '/table': (_) => TableScreen(),
        '/delete': (_) => DeleteScreen(),
      },
    );
  }
}