class PokemonSummary {
  final int id;
  final String name;
  final String url;
  final String imageUrl;

  PokemonSummary({
    required this.id,
    required this.name,
    required this.url,
    required this.imageUrl,
  });

  /// Nombre formateado con la primera letra en mayúscula
  String get formattedName {
    if (name.isEmpty) return '';
    return name
        .split('-')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1)}'
            : '')
        .join(' ');
  }

  /// ID formateado como #001, #025, etc.
  String get formattedId => '#${id.toString().padLeft(3, '0')}';

  factory PokemonSummary.fromJson(Map<String, dynamic> json) {
    final String url = json['url'] ?? '';
    int id = 0;

    // Extraer el ID de la URL (ej: "https://pokeapi.co/api/v2/pokemon/25/")
    final uri = Uri.tryParse(url);
    if (uri != null && uri.pathSegments.isNotEmpty) {
      final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
      if (segments.isNotEmpty) {
        id = int.tryParse(segments.last) ?? 0;
      }
    }

    // URL de la imagen de arte oficial de PokéAPI
    final imageUrl = id > 0
        ? 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png'
        : '';

    return PokemonSummary(
      id: id,
      name: json['name'] ?? '',
      url: url,
      imageUrl: imageUrl,
    );
  }
}

class PokemonStat {
  final String name;
  final int value;

  PokemonStat({
    required this.name,
    required this.value,
  });

  String get formattedName {
    switch (name.toLowerCase()) {
      case 'hp':
        return 'PS (Salud)';
      case 'attack':
        return 'Ataque';
      case 'defense':
        return 'Defensa';
      case 'special-attack':
        return 'Ataque Esp.';
      case 'special-defense':
        return 'Defensa Esp.';
      case 'speed':
        return 'Velocidad';
      default:
        return name
            .split('-')
            .map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '')
            .join(' ');
    }
  }
}

class PokemonDetail {
  final int id;
  final String name;
  final String imageUrl;
  final String spriteUrl;
  final double height; // En metros
  final double weight; // En kilogramos
  final int baseExperience;
  final List<String> types;
  final List<String> abilities;
  final List<PokemonStat> stats;

  PokemonDetail({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.spriteUrl,
    required this.height,
    required this.weight,
    required this.baseExperience,
    required this.types,
    required this.abilities,
    required this.stats,
  });

  String get formattedName {
    if (name.isEmpty) return '';
    return name
        .split('-')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1)}'
            : '')
        .join(' ');
  }

  String get formattedId => '#${id.toString().padLeft(3, '0')}';

  factory PokemonDetail.fromJson(Map<String, dynamic> json) {
    final int id = json['id'] ?? 0;

    // Sprite por defecto e imagen oficial
    final sprites = json['sprites'] as Map<String, dynamic>? ?? {};
    final other = sprites['other'] as Map<String, dynamic>? ?? {};
    final officialArtwork = other['official-artwork'] as Map<String, dynamic>? ?? {};

    final String imageUrl = officialArtwork['front_default'] ??
        sprites['front_default'] ??
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';

    final String spriteUrl = sprites['front_default'] ?? imageUrl;

    // Tipos
    final typesList = (json['types'] as List<dynamic>? ?? [])
        .map((t) => (t['type']?['name'] as String? ?? ''))
        .where((t) => t.isNotEmpty)
        .toList();

    // Habilidades
    final abilitiesList = (json['abilities'] as List<dynamic>? ?? [])
        .map((a) {
          final name = a['ability']?['name'] as String? ?? '';
          final isHidden = a['is_hidden'] as bool? ?? false;
          final formatted = name
              .split('-')
              .map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '')
              .join(' ');
          return isHidden ? '$formatted (Oculta)' : formatted;
        })
        .where((a) => a.isNotEmpty)
        .toList();

    // Estadísticas
    final statsList = (json['stats'] as List<dynamic>? ?? [])
        .map((s) => PokemonStat(
              name: s['stat']?['name'] as String? ?? '',
              value: s['base_stat'] as int? ?? 0,
            ))
        .toList();

    // Altura en decímetros a metros, peso en hectogramos a kg
    final int rawHeight = json['height'] as int? ?? 0;
    final int rawWeight = json['weight'] as int? ?? 0;

    return PokemonDetail(
      id: id,
      name: json['name'] ?? '',
      imageUrl: imageUrl,
      spriteUrl: spriteUrl,
      height: rawHeight / 10.0,
      weight: rawWeight / 10.0,
      baseExperience: json['base_experience'] as int? ?? 0,
      types: typesList,
      abilities: abilitiesList,
      stats: statsList,
    );
  }
}
