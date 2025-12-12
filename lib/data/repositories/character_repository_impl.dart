import '../../domain/repositories/character_repository.dart';
import '../../domain/entities/characters_response_entity.dart';
import '../../core/error/failures.dart';
import '../datasources/character_remote_datasource.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  final CharacterRemoteDataSource remoteDataSource;

  CharacterRepositoryImpl({required this.remoteDataSource});

  @override
  Future<CharactersResponseEntity> getCharacters({String? url}) async {
    try {
      final result = await remoteDataSource.getCharacters(url: url);
      return result;
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure('Erro inesperado: $e');
    }
  }
}

