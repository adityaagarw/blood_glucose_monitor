import 'package:flutter/material.dart';

class PPReading {
  final String id;
  final DateTime date;
  final TimeOfDay time;
  final int glucoseLevel;
  final String food;

  PPReading({
    required this.id,
    required this.date,
    required this.time,
    required this.glucoseLevel,
    required this.food,
  });

  factory PPReading.fromMap(Map<String, dynamic> map) {
    return PPReading(
      id: map['id'],
      date: DateTime.parse(map['date']),
      time: TimeOfDay(
        hour: int.parse(map['hour']),
        minute: int.parse(map['minute']),
      ),
      glucoseLevel: map['glucoseLevel'],
      food: map['food'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'hour': time.hour.toString(),
      'minute': time.minute.toString(),
      'glucoseLevel': glucoseLevel,
      'food': food,
    };
  }
}
