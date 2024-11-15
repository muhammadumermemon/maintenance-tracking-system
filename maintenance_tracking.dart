class Equipment {
  final int id;
  final String name;
  final String type;
  final DateTime lastMaintenanceDate;

  Equipment({
    required this.id,
    required this.name,
    required this.type,
    required this.lastMaintenanceDate,
  });

  // Convert an Equipment object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'lastMaintenanceDate': lastMaintenanceDate.toIso8601String(),
    };
  }

  // Create an Equipment object from a Map object
  factory Equipment.fromMap(Map<String, dynamic> map) {
    return Equipment(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      lastMaintenanceDate: DateTime.parse(map['lastMaintenanceDate']),
    );
  }
}
