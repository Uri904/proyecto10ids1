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

  /// Convertir objeto a Map para la base de datos de Supabase
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'name_client': name.trim(),
      'email_client': email.trim(),
      'phone_client': phone.trim(),
      'address_client': address.trim(),
      'classification_id': classificationId,
      'classification_name': classificationName,
    };
    if (createdAt != null) {
      map['created_at'] = createdAt!.toIso8601String();
    }
    return map;
  }

  /// Crear objeto desde Map devuelto por Supabase
  factory ClientModel.fromMap(Map<String, dynamic> data) {
    DateTime? parsedDate;
    final rawDate = data['created_at'] ?? data['createdAt'];
    if (rawDate != null) {
      if (rawDate is String) {
        parsedDate = DateTime.tryParse(rawDate);
      } else if (rawDate is DateTime) {
        parsedDate = rawDate;
      }
    }

    return ClientModel(
      id: data['id']?.toString(),
      name: data['name_client'] ?? data['name'] ?? '',
      email: data['email_client'] ?? data['email'] ?? '',
      phone: data['phone_client'] ?? data['phone'] ?? '',
      address: data['address_client'] ?? data['address'] ?? '',
      classificationId: data['classification_id'] ?? data['classificationId'],
      classificationName: data['classification_name'] ?? data['classificationName'],
      createdAt: parsedDate,
    );
  }
}
