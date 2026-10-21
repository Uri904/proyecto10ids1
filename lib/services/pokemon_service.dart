import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/pokemon_model.dart';

class PokemonService {
  static const String _baseUrl = 'https://pokeapi.co/api/v2';

  /// Obtener listado de Pokémon
  Future<List<PokemonSummary>> fetchPokemonList({
    int limit = 60,
    int offset = 0,
  }) async {
    final url = Uri.parse('$_baseUrl/pokemon?limit=$limit&offset=$offset');

    try {
      final response = await http.get(url).timeout(
        const Duration(seconds: 12),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final results = data['results'] as List<dynamic>? ?? [];

        return results
            .map((item) => PokemonSummary.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
          'Error del servidor: Código de respuesta ${response.statusCode}',
        );
      }
    } on SocketException {
      throw Exception(
        'Sin conexión a Internet. Por favor, verifica tu red e intenta nuevamente.',
      );
    } on http.ClientException {
      throw Exception(
        'Error de conexión al intentar comunicarse con PokéAPI.',
      );
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Ocurrió un error inesperado: $e');
    }
  }

  /// Obtener detalle completo de un Pokémon por su ID o Nombre
  Future<PokemonDetail> fetchPokemonDetail(String idOrName) async {
    final url = Uri.parse('$_baseUrl/pokemon/${idOrName.toLowerCase()}');

    try {
      final response = await http.get(url).timeout(
        const Duration(seconds: 12),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return PokemonDetail.fromJson(data);
      } else if (response.statusCode == 404) {
        throw Exception('No se encontró la información para el Pokémon $idOrName');
      } else {
        throw Exception(
          'Error del servidor: Código ${response.statusCode}',
        );
      }
    } on SocketException {
      throw Exception(
        'Sin conexión a Internet. No se pudieron obtener los detalles.',
      );
    } on http.ClientException {
      throw Exception(
        'Error al conectar con el servidor de PokéAPI.',
      );
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Ocurrió un error inesperado al cargar el detalle: $e');
    }
  }
}
