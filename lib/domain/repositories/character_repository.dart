import '../entities/characters_response_entity.dart';

abstract class CharacterRepository {
  Future<CharactersResponseEntity> getCharacters({String? url});
}

