import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/client_model.dart';

class ClientService {
  final CollectionReference _clientsCollection =
      FirebaseFirestore.instance.collection('clients');

  /// Obtener lista de clientes en tiempo real
  Stream<List<ClientModel>> getClientsStream() {
    return _clientsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ClientModel.fromFirestore(doc))
          .toList();
    });
  }

  /// Agregar un nuevo cliente a Firestore
  Future<void> addClient(ClientModel client) async {
    try {
      await _clientsCollection.add(client.toMap());
    } catch (e) {
      throw Exception('Error al agregar el cliente: $e');
    }
  }

  /// Actualizar un cliente existente en Firestore
  Future<void> updateClient(ClientModel client) async {
    if (client.id == null || client.id!.isEmpty) {
      throw Exception('ID del cliente no válido para actualizar');
    }
    try {
      await _clientsCollection.doc(client.id).update(client.toMap());
    } catch (e) {
      throw Exception('Error al actualizar el cliente: $e');
    }
  }

  /// Eliminar un cliente de Firestore por su ID
  Future<void> deleteClient(String clientId) async {
    try {
      await _clientsCollection.doc(clientId).delete();
    } catch (e) {
      throw Exception('Error al eliminar el cliente: $e');
    }
  }
}
