import 'package:flutter/material.dart';
class GlucoseReading {
  final int id;
  final DateTime date;
  final TimeOfDay time;
  final String type;
  final int glucoseLevel;
  final String food;

  GlucoseReading({
    this.id,
    this.date,
    this.time,
    this.type,
    this.glucoseLevel,
    this.food,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'time': '${time.hour}:${time.minute}',
      'type': type,
      'glucose_level': glucoseLevel,
    };
  }

  factory GlucoseReading.fromMap(Map<String, dynamic> map, String food) {
    final date = DateTime.tryParse(map['date']);
    final timeParts = map['time'].split(':');
    final time = TimeOfDay(hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
    return GlucoseReading(
      id: map['id'],
      date: date,
      time: time,
      type: map['type'],
      glucoseLevel: map['glucose_level'],
      food: food,
    );
  }
}