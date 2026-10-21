import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/classification_model.dart';

class ClassificationService {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('classifications');

  /// Obtener clasificaciones en tiempo real
  Stream<List<ClassificationModel>> getClassificationsStream() {
    return _collection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ClassificationModel.fromFirestore(doc))
          .toList();
    });
  }

  /// Agregar una nueva clasificación
  Future<void> addClassification(ClassificationModel classification) async {
    try {
      await _collection.add(classification.toMap());
    } catch (e) {
      throw Exception('Error al registrar la clasificación: $e');
    }
  }

  /// Actualizar una clasificación existente
  Future<void> updateClassification(ClassificationModel classification) async {
    if (classification.id == null || classification.id!.isEmpty) {
      throw Exception('ID no válido para actualizar');
    }
    try {
      await _collection.doc(classification.id).update(classification.toMap());
    } catch (e) {
      throw Exception('Error al actualizar la clasificación: $e');
    }
  }

  /// Eliminar una clasificación por su ID
  Future<void> deleteClassification(String id) async {
    try {
      await _collection.doc(id).delete();
    } catch (e) {
      throw Exception('Error al eliminar la clasificación: $e');
    }
  }
}
