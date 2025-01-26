import 'package:cloud_firestore/cloud_firestore.dart';

class PillsEntity {
  String? id; // ID do documento no Firestore
  final String name;
  final String dosage;
  final String time;
  final String duration;
  final String priority;
  final String description;
  final DateTime createdAt;

  PillsEntity({
    this.id,
    required this.name,
    required this.dosage,
    required this.time,
    required this.duration,
    required this.priority,
    required this.description,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory PillsEntity.fromMap(String id, Map<String, dynamic> map) {
    return PillsEntity(
      id: id,
      name: map['name'] ?? '',
      dosage: map['dosage'] ?? '',
      time: map['time'] ?? '',
      duration: map['duration'] ?? '',
      priority: map['priority'] ?? '',
      description: map['description'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'dosage': dosage,
      'time': time,
      'duration': duration,
      'priority': priority,
      'description': description,
      'createdAt': createdAt,
    };
  }
}
