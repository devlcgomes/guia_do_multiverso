import 'package:http/http.dart' as http;
import 'data/datasources/character_remote_datasource.dart';
import 'data/repositories/character_repository_impl.dart';
import 'domain/usecases/get_characters.dart';
import 'presentation/bloc/character/character_bloc.dart';

class InjectionContainer {
  static CharacterBloc getCharacterBloc() {
    final httpClient = http.Client();
    final remoteDataSource = CharacterRemoteDataSourceImpl(client: httpClient);
    final repository = CharacterRepositoryImpl(remoteDataSource: remoteDataSource);
    final getCharacters = GetCharacters(repository);
    return CharacterBloc(getCharacters: getCharacters);
  }
}

