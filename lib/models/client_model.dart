import 'package:cloud_firestore/cloud_firestore.dart';

class ClientModel {
  final String? id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String? classificationId;
  final String? classificationName;
  final DateTime? createdAt;

  ClientModel({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    this.classificationId,
    this.classificationName,
    this.createdAt,
  });

  /// Convertir objeto a Map con los nombres de campos de Firestore
  Map<String, dynamic> toMap() {
    return {
      'name_client': name.trim(),
      'email_client': email.trim(),
      'phone_client': phone.trim(),
      'address_client': address.trim(),
      'classificationId': classificationId,
      'classificationName': classificationName,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
    };
  }

  /// Crear objeto leyendo desde el DocumentSnapshot de Firestore
  factory ClientModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    final Timestamp? timestamp = data['createdAt'] as Timestamp?;

    return ClientModel(
      id: doc.id,
      name: data['name_client'] ?? data['name'] ?? '',
      email: data['email_client'] ?? data['email'] ?? '',
      phone: data['phone_client'] ?? data['phone'] ?? '',
      address: data['address_client'] ?? data['address'] ?? '',
      classificationId: data['classificationId'],
      classificationName: data['classificationName'],
      createdAt: timestamp?.toDate(),
    );
  }
}
