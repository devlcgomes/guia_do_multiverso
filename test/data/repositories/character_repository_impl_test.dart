import 'package:flutter_test/flutter_test.dart';
import 'package:guia_do_multiverso/core/error/failures.dart';
import 'package:guia_do_multiverso/data/datasources/character_remote_datasource.dart';
import 'package:guia_do_multiverso/data/models/character_model.dart';
import 'package:guia_do_multiverso/data/models/characters_response_model.dart';
import 'package:guia_do_multiverso/data/repositories/character_repository_impl.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helpers.dart';
import '../../helpers/mocks.mocks.dart';

void main() {
  late CharacterRepositoryImpl repository;
  late MockCharacterRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockCharacterRemoteDataSource();
    repository = CharacterRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  group('CharacterRepositoryImpl', () {
    group('getCharacters', () {
      test(
        'deve retornar CharactersResponseEntity quando chamar com sucesso',
        () async {
          // arrange
          final testCharacters = TestHelpers.createTestCharactersList(3);
          final testResponse = CharactersResponseModel(
            count: 3,
            pages: 1,
            next: null,
            prev: null,
            characters: testCharacters.map((e) => CharacterModel(
              id: e.id,
              name: e.name,
              status: e.status,
              species: e.species,
              type: e.type,
              gender: e.gender,
              image: e.image,
              url: e.url,
              location: e.location,
              origin: e.origin,
              episodes: e.episodes,
              created: e.created,
            )).toList(),
          );

          when(mockRemoteDataSource.getCharacters())
              .thenAnswer((_) async => testResponse);

          // act
          final result = await repository.getCharacters();

          // assert
          expect(result.characters.length, equals(3));
          expect(result.count, equals(3));
          verify(mockRemoteDataSource.getCharacters()).called(1);
        },
      );

      test(
        'deve passar os parâmetros corretos para o datasource',
        () async {
          // arrange
          final testResponse = CharactersResponseModel(
            count: 0,
            pages: 0,
            next: null,
            prev: null,
            characters: [],
          );

          when(mockRemoteDataSource.getCharacters(
            url: anyNamed('url'),
            status: anyNamed('status'),
          )).thenAnswer((_) async => testResponse);

          // act
          await repository.getCharacters(url: 'https://example.com', status: 'alive');

          // assert
          verify(mockRemoteDataSource.getCharacters(
            url: 'https://example.com',
            status: 'alive',
          )).called(1);
        },
      );

      test(
        'deve rethrow Failure quando o datasource lançar uma Failure',
        () async {
          // arrange
          when(mockRemoteDataSource.getCharacters())
              .thenThrow(const ServerFailure('Erro no servidor'));

          // act
          final call = repository.getCharacters;

          // assert
          expect(
            () => call(),
            throwsA(isA<ServerFailure>().having(
              (e) => e.message,
              'message',
              'Erro no servidor',
            )),
          );
          verify(mockRemoteDataSource.getCharacters()).called(1);
        },
      );

      test(
        'deve lançar ServerFailure quando ocorrer um erro inesperado',
        () async {
          // arrange
          when(mockRemoteDataSource.getCharacters())
              .thenThrow(Exception('Erro inesperado'));

          // act
          final call = repository.getCharacters;

          // assert
          expect(
            () => call(),
            throwsA(isA<ServerFailure>().having(
              (e) => e.message,
              'message',
              contains('Erro inesperado'),
            )),
          );
        },
      );

      test(
        'deve rethrow NetworkFailure quando o datasource lançar NetworkFailure',
        () async {
          // arrange
          when(mockRemoteDataSource.getCharacters())
              .thenThrow(const NetworkFailure('Sem conexão'));

          // act
          final call = repository.getCharacters;

          // assert
          expect(
            () => call(),
            throwsA(isA<NetworkFailure>().having(
              (e) => e.message,
              'message',
              'Sem conexão',
            )),
          );
        },
      );
    });
  });
}

