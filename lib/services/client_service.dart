import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/client_model.dart';

class ClientService {
  SupabaseClient get _client => Supabase.instance.client;

  /// In-memory storage fallback if remote server is unreachable
  static final List<ClientModel> _memoryClients = [];
  static final StreamController<List<ClientModel>> _fallbackController =
      StreamController<List<ClientModel>>.broadcast();

  /// Obtener lista de clientes en tiempo real
  Stream<List<ClientModel>> getClientsStream() {
    try {
      return _client
          .from('clients')
          .stream(primaryKey: ['id'])
          .order('created_at', ascending: false)
          .map((dataList) {
            final list = dataList.map((map) => ClientModel.fromMap(map)).toList();
            _memoryClients.clear();
            _memoryClients.addAll(list);
            return list;
          })
          .handleError((e) {
            _fallbackController.add(List.from(_memoryClients));
          });
    } catch (_) {
      return _fallbackController.stream;
    }
  }

  /// Agregar un nuevo cliente
  Future<void> addClient(ClientModel client) async {
    try {
      await _client.from('clients').insert(client.toMap());
    } catch (_) {
      final newId = DateTime.now().millisecondsSinceEpoch.toString();
      final newClient = ClientModel(
        id: newId,
        name: client.name,
        email: client.email,
        phone: client.phone,
        address: client.address,
        classificationId: client.classificationId,
        classificationName: client.classificationName,
        createdAt: DateTime.now(),
      );
      _memoryClients.insert(0, newClient);
      _fallbackController.add(List.from(_memoryClients));
    }
  }

  /// Actualizar un cliente existente
  Future<void> updateClient(ClientModel client) async {
    if (client.id == null || client.id!.isEmpty) {
      throw Exception('ID del cliente no válido para actualizar');
    }
    try {
      await _client
          .from('clients')
          .update(client.toMap())
          .eq('id', client.id!);
    } catch (_) {
      final index = _memoryClients.indexWhere((c) => c.id == client.id);
      if (index != -1) {
        _memoryClients[index] = client;
        _fallbackController.add(List.from(_memoryClients));
      }
    }
  }

  /// Eliminar un cliente por su ID
  Future<void> deleteClient(String clientId) async {
    try {
      await _client.from('clients').delete().eq('id', clientId);
    } catch (_) {
      _memoryClients.removeWhere((c) => c.id == clientId);
      _fallbackController.add(List.from(_memoryClients));
    }
  }
}
