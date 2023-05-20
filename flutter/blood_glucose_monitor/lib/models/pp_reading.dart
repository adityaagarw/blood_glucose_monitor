import 'package:flutter/material.dart';

class PPReading {
  final int id;
  final int readingId;
  final String food;

  PPReading({
    this.id,
    this.readingId,
    this.food,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'reading_id': readingId,
      'food': food,
    };
  }

  factory PPReading.fromMap(Map<String, dynamic> map) {
    return PPReading(
      id: map['id'],
      readingId: map['reading_id'],
      food: map['food'],
    );
  }
}