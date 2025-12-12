import '../../domain/entities/characters_response_entity.dart';
import 'character_model.dart';

class CharactersResponseModel extends CharactersResponseEntity {
  const CharactersResponseModel({
    required super.count,
    required super.pages,
    super.next,
    super.prev,
    required super.characters,
  });

  factory CharactersResponseModel.fromJson(Map<String, dynamic> json) {
    return CharactersResponseModel(
      count: json['info']['count'],
      pages: json['info']['pages'],
      next: json['info']['next'],
      prev: json['info']['prev'],
      characters: (json['results'] as List)
          .map((item) => CharacterModel.fromJson(item))
          .toList(),
    );
  }
}

