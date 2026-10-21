// Pruebas de caja blanca: lib/models/pokemon_model.dart
// Cubren las ramas de PokemonSummary.fromJson, PokemonDetail.fromJson y
// PokemonStat.formattedName (valores faltantes, conversión de unidades, etc.).
// Ejecutar: flutter test test/caja_blanca/pokemon_model_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto10ids1/models/pokemon_model.dart';

void main() {
  group('PokemonSummary', () {
    test('CB-P-01 extrae el id desde la URL y arma la imagen', () {
      final p = PokemonSummary.fromJson({
        'name': 'pikachu',
        'url': 'https://pokeapi.co/api/v2/pokemon/25/',
      });
      expect(p.id, 25);
      expect(p.imageUrl, endsWith('/official-artwork/25.png'));
      expect(p.formattedId, '#025');
      expect(p.formattedName, 'Pikachu');
    });

    test('CB-P-02 nombre compuesto con guion se capitaliza por palabra', () {
      final p = PokemonSummary.fromJson({
        'name': 'mr-mime',
        'url': 'https://pokeapi.co/api/v2/pokemon/122/',
      });
      expect(p.formattedName, 'Mr Mime');
    });

    test('CB-P-03 JSON vacío -> id 0, sin imagen, sin romper', () {
      final p = PokemonSummary.fromJson({});
      expect(p.id, 0);
      expect(p.name, '');
      expect(p.imageUrl, '');
      expect(p.formattedName, '');
    });

    test('CB-P-04 URL sin id numérico al final -> id 0', () {
      final p = PokemonSummary.fromJson({
        'name': 'x',
        'url': 'https://pokeapi.co/api/v2/pokemon/abc/',
      });
      expect(p.id, 0);
      expect(p.imageUrl, '');
    });
  });

  group('PokemonDetail', () {
    final completo = {
      'id': 25,
      'name': 'pikachu',
      'height': 4,
      'weight': 60,
      'base_experience': 112,
      'types': [
        {'type': {'name': 'electric'}}
      ],
      'abilities': [
        {'ability': {'name': 'static'}, 'is_hidden': false},
        {'ability': {'name': 'lightning-rod'}, 'is_hidden': true},
      ],
      'stats': [
        {'stat': {'name': 'hp'}, 'base_stat': 35}
      ],
      'sprites': {
        'front_default': 'http://s/front.png',
        'other': {
          'official-artwork': {'front_default': 'http://s/art.png'}
        },
      },
    };

    test('CB-P-05 convierte altura y peso (decímetros/hectogramos)', () {
      final d = PokemonDetail.fromJson(completo);
      expect(d.height, closeTo(0.4, 0.0001));
      expect(d.weight, closeTo(6.0, 0.0001));
      expect(d.baseExperience, 112);
    });

    test('CB-P-06 tipos y habilidades; la oculta se marca', () {
      final d = PokemonDetail.fromJson(completo);
      expect(d.types, ['electric']);
      expect(d.abilities, ['Static', 'Lightning Rod (Oculta)']);
    });

    test('CB-P-07 imagen oficial y sprite cuando existen', () {
      final d = PokemonDetail.fromJson(completo);
      expect(d.imageUrl, 'http://s/art.png');
      expect(d.spriteUrl, 'http://s/front.png');
    });

    test('CB-P-08 sin arte oficial usa el sprite por defecto', () {
      final json = Map<String, dynamic>.from(completo);
      json['sprites'] = {'front_default': 'http://s/front.png'};
      final d = PokemonDetail.fromJson(json);
      expect(d.imageUrl, 'http://s/front.png');
    });

    test('CB-P-09 sin sprites usa la URL de respaldo con el id', () {
      final json = Map<String, dynamic>.from(completo);
      json.remove('sprites');
      final d = PokemonDetail.fromJson(json);
      expect(d.imageUrl, endsWith('/official-artwork/25.png'));
      expect(d.spriteUrl, d.imageUrl);
    });

    test('CB-P-10 JSON vacío -> valores por defecto sin excepción', () {
      final d = PokemonDetail.fromJson({});
      expect(d.id, 0);
      expect(d.name, '');
      expect(d.height, 0.0);
      expect(d.weight, 0.0);
      expect(d.types, isEmpty);
      expect(d.abilities, isEmpty);
      expect(d.stats, isEmpty);
    });
  });

  group('PokemonStat.formattedName', () {
    test('CB-P-11 nombres conocidos se traducen', () {
      expect(PokemonStat(name: 'hp', value: 1).formattedName, 'PS (Salud)');
      expect(PokemonStat(name: 'attack', value: 1).formattedName, 'Ataque');
      expect(PokemonStat(name: 'defense', value: 1).formattedName, 'Defensa');
      expect(PokemonStat(name: 'special-attack', value: 1).formattedName,
          'Ataque Esp.');
      expect(PokemonStat(name: 'special-defense', value: 1).formattedName,
          'Defensa Esp.');
      expect(PokemonStat(name: 'speed', value: 1).formattedName, 'Velocidad');
    });

    test('CB-P-12 nombre desconocido se capitaliza (rama por defecto)', () {
      expect(PokemonStat(name: 'unknown-stat', value: 1).formattedName,
          'Unknown Stat');
    });
  });
}
