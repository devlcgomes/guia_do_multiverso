import 'package:guia_do_multiverso/domain/entities/character_entity.dart';
import 'package:guia_do_multiverso/domain/entities/characters_response_entity.dart';

/// Helper para criar entidades de teste
class TestHelpers {
  static CharacterEntity createTestCharacter({
    int id = 1,
    String name = 'Rick Sanchez',
    String status = 'Alive',
    String species = 'Human',
    String type = '',
    String gender = 'Male',
    String image = 'https://example.com/image.jpg',
    String url = 'https://example.com/character/1',
    String location = 'Earth',
    String origin = 'Earth',
    List<String>? episodes,
    DateTime? created,
  }) {
    return CharacterEntity(
      id: id,
      name: name,
      status: status,
      species: species,
      type: type,
      gender: gender,
      image: image,
      url: url,
      location: location,
      origin: origin,
      episodes: episodes ?? ['https://example.com/episode/1'],
      created: created ?? DateTime(2020, 1, 1),
    );
  }

  static CharactersResponseEntity createTestCharactersResponse({
    int count = 1,
    int pages = 1,
    String? next,
    String? prev,
    List<CharacterEntity>? characters,
  }) {
    return CharactersResponseEntity(
      count: count,
      pages: pages,
      next: next,
      prev: prev,
      characters: characters ?? [createTestCharacter()],
    );
  }

  static List<CharacterEntity> createTestCharactersList(int count) {
    return List.generate(
      count,
      (index) => createTestCharacter(
        id: index + 1,
        name: 'Character ${index + 1}',
      ),
    );
  }
}

