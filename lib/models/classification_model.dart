class ClassificationModel {
  final String? id;
  final String name;
  final String description;
  final DateTime? createdAt;

  ClassificationModel({
    this.id,
    required this.name,
    required this.description,
    this.createdAt,
  });

  /// Convertir a Map para guardar en Supabase
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'name': name.trim(),
      'description': description.trim(),
    };
    if (createdAt != null) {
      map['created_at'] = createdAt!.toIso8601String();
    }
    return map;
  }

  /// Crear instancia desde un Map de Supabase
  factory ClassificationModel.fromMap(Map<String, dynamic> data) {
    DateTime? parsedDate;
    final rawDate = data['created_at'] ?? data['createdAt'];
    if (rawDate != null) {
      if (rawDate is String) {
        parsedDate = DateTime.tryParse(rawDate);
      } else if (rawDate is DateTime) {
        parsedDate = rawDate;
      }
    }

    return ClassificationModel(
      id: data['id']?.toString(),
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      createdAt: parsedDate,
    );
  }
}
