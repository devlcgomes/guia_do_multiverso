import '../entities/characters_response_entity.dart';
import '../repositories/character_repository.dart';
import '../../core/usecases/usecase.dart';

class GetCharacters implements UseCase<CharactersResponseEntity, GetCharactersParams> {
  final CharacterRepository repository;

  GetCharacters(this.repository);

  @override
  Future<CharactersResponseEntity> call(GetCharactersParams params) async {
    return await repository.getCharacters(url: params.url, status: params.status, name: params.name);
  }
}

class GetCharactersParams {
  final String? url;
  final String? status;
  final String? name;

  GetCharactersParams({this.url, this.status, this.name});
}

