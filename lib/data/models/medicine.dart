import 'package:flutter/material.dart';

class Medicine {
  final String id;
  final String name;
  final String dose;
  final TimeOfDay time;
  final bool isTaken;
  final DateTime createdAt;

  const Medicine({
    required this.id,
    required this.name,
    required this.dose,
    required this.time,
    this.isTaken = false,
    required this.createdAt,
  });

  Medicine copyWith({
    String? id,
    String? name,
    String? dose,
    TimeOfDay? time,
    bool? isTaken,
    DateTime? createdAt,
  }) {
    return Medicine(
      id: id ?? this.id,
      name: name ?? this.name,
      dose: dose ?? this.dose,
      time: time ?? this.time,
      isTaken: isTaken ?? this.isTaken,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dose': dose,
      'hour': time.hour,
      'minute': time.minute,
      'isTaken': isTaken,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['id'] as String,
      name: json['name'] as String,
      dose: json['dose'] as String,
      time: TimeOfDay(hour: json['hour'] as int, minute: json['minute'] as int),
      isTaken: json['isTaken'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  String get formattedTime {
    final period = time.hour < 12 ? 'AM' : 'PM';
    final hour = time.hour > 12
        ? time.hour - 12
        : time.hour == 0
        ? 12
        : time.hour;
    return '${hour}:${time.minute.toString().padLeft(2, '0')} $period';
  }

  bool get isTimePassed {
    final now = TimeOfDay.now();
    return time.hour < now.hour ||
        (time.hour == now.hour && time.minute < now.minute);
  }
}
