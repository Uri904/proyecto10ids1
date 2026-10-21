import 'package:cloud_firestore/cloud_firestore.dart';

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

  /// Convertir a Map para guardar en Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name.trim(),
      'description': description.trim(),
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
    };
  }

  /// Crear instancia desde un DocumentSnapshot de Firestore
  factory ClassificationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    final Timestamp? timestamp = data['createdAt'] as Timestamp?;

    return ClassificationModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      createdAt: timestamp?.toDate(),
    );
  }
}
