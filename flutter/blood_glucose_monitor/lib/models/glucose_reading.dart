import 'package:flutter/material.dart';

class GlucoseReading {
  final String id;
  final DateTime date;
  final TimeOfDay time;
  final String type;
  final int glucoseLevel;
  final String? food;

  GlucoseReading({
    required this.id,
    required this.date,
    required this.time,
    required this.type,
    required this.glucoseLevel,
    this.food,
  });

  factory GlucoseReading.fromMap(Map<String, dynamic> map) {
    return GlucoseReading(
      id: map['id'],
      date: DateTime.parse(map['date']),
      time: TimeOfDay(
        hour: int.parse(map['hour']),
        minute: int.parse(map['minute']),
      ),
      type: map['type'],
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
      'type': type,
      'glucoseLevel': glucoseLevel,
      'food': food,
    };
  }
}
