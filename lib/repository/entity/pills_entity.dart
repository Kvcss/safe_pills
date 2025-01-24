class PillsEntity {
  String? id; // ID do documento no Firestore
  final String name;
  final String dosage;
  final String time;
  final String duration;
  final String priority;
  final String description;

  PillsEntity({
    this.id,
    required this.name,
    required this.dosage,
    required this.time,
    required this.duration,
    required this.priority,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'dosage': dosage,
      'time': time,
      'duration': duration,
      'priority': priority,
      'description': description,
      'createdAt': DateTime.now(),
    };
  }

  factory PillsEntity.fromMap(Map<String, dynamic> map) {
    return PillsEntity(
      name: map['name'] ?? '',
      dosage: map['dosage'] ?? '',
      time: map['time'] ?? '',
      duration: map['duration'] ?? '',
      priority: map['priority'] ?? '',
      description: map['description'] ?? '',
    );
  }
}
