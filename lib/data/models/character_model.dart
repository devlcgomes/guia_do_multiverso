import '../../domain/entities/character_entity.dart';

class CharacterModel extends CharacterEntity {
  const CharacterModel({
    required super.id,
    required super.name,
    required super.status,
    required super.species,
    required super.type,
    required super.gender,
    required super.image,
    required super.url,
    required super.location,
    required super.origin,
    required super.episodes,
    required super.created,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      status: json['status'] as String? ?? 'unknown',
      species: json['species'] as String? ?? '',
      type: json['type'] as String? ?? '',
      gender: json['gender'] as String? ?? 'unknown',
      image: json['image'] as String? ?? '',
      url: json['url'] as String? ?? '',
      location: json['location']?['name'] as String? ?? 'Desconhecido',
      origin: json['origin']?['name'] as String? ?? 'Desconhecido',
      episodes: (json['episode'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList()
              .cast<String>() ??
          <String>[],
      created: DateTime.parse(json['created'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'species': species,
      'type': type,
      'gender': gender,
      'image': image,
      'url': url,
      'location': {'name': location},
      'origin': {'name': origin},
      'episode': episodes,
      'created': created.toIso8601String(),
    };
  }
}

