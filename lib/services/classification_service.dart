import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/classification_model.dart';

class ClassificationService {
  SupabaseClient get _client => Supabase.instance.client;

  /// In-memory storage fallback if remote server is unreachable
  static final List<ClassificationModel> _memoryList = [];
  static final StreamController<List<ClassificationModel>> _fallbackController =
      StreamController<List<ClassificationModel>>.broadcast();

  /// Obtener clasificaciones en tiempo real
  Stream<List<ClassificationModel>> getClassificationsStream() {
    try {
      return _client
          .from('classifications')
          .stream(primaryKey: ['id'])
          .order('created_at', ascending: false)
          .map((dataList) {
            final list =
                dataList.map((map) => ClassificationModel.fromMap(map)).toList();
            _memoryList.clear();
            _memoryList.addAll(list);
            return list;
          })
          .handleError((e) {
            _fallbackController.add(List.from(_memoryList));
          });
    } catch (_) {
      return _fallbackController.stream;
    }
  }

  /// Agregar una nueva clasificación
  Future<void> addClassification(ClassificationModel classification) async {
    try {
      await _client.from('classifications').insert(classification.toMap());
    } catch (_) {
      final newId = DateTime.now().millisecondsSinceEpoch.toString();
      final newModel = ClassificationModel(
        id: newId,
        name: classification.name,
        description: classification.description,
        createdAt: DateTime.now(),
      );
      _memoryList.insert(0, newModel);
      _fallbackController.add(List.from(_memoryList));
    }
  }

  /// Actualizar una clasificación existente
  Future<void> updateClassification(ClassificationModel classification) async {
    if (classification.id == null || classification.id!.isEmpty) {
      throw Exception('ID no válido para actualizar');
    }
    try {
      await _client
          .from('classifications')
          .update(classification.toMap())
          .eq('id', classification.id!);
    } catch (_) {
      final index = _memoryList.indexWhere((c) => c.id == classification.id);
      if (index != -1) {
        _memoryList[index] = classification;
        _fallbackController.add(List.from(_memoryList));
      }
    }
  }

  /// Eliminar una clasificación por su ID
  Future<void> deleteClassification(String id) async {
    try {
      await _client.from('classifications').delete().eq('id', id);
    } catch (_) {
      _memoryList.removeWhere((c) => c.id == id);
      _fallbackController.add(List.from(_memoryList));
    }
  }
}
