import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guia_do_multiverso/core/error/failures.dart';
import 'package:guia_do_multiverso/domain/entities/characters_response_entity.dart';
import 'package:guia_do_multiverso/presentation/bloc/character/character_bloc.dart';
import 'package:guia_do_multiverso/presentation/bloc/character/character_event.dart';
import 'package:guia_do_multiverso/presentation/bloc/character/character_state.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helpers.dart';
import '../../../helpers/mocks.mocks.dart';

void main() {
  late MockGetCharacters mockGetCharacters;
  late CharacterBloc characterBloc;

  setUp(() {
    mockGetCharacters = MockGetCharacters();
    characterBloc = CharacterBloc(getCharacters: mockGetCharacters);
  });

  tearDown(() {
    if (!characterBloc.isClosed) {
      characterBloc.close();
    }
  });

  group('CharacterBloc', () {
    test('Estado inicial deve ser CharacterInitial', () {
      expect(characterBloc.state, equals(const CharacterInitial()));
    });

    group('LoadCharacters', () {
      final testCharacters = TestHelpers.createTestCharactersList(3);
      final testResponse = CharactersResponseEntity(
        count: 3,
        pages: 1,
        next: null,
        prev: null,
        characters: testCharacters,
      );

      blocTest<CharacterBloc, CharacterState>(
        'deve emitir [CharacterLoading, CharacterLoaded] quando carregar com sucesso',
        build: () {
          when(mockGetCharacters(any)).thenAnswer((_) async => testResponse);
          return characterBloc;
        },
        act: (bloc) => bloc.add(const LoadCharacters()),
        expect: () => [
          const CharacterLoading(),
          CharacterLoaded(
            characters: testCharacters,
            nextUrl: null,
            hasMore: false,
            currentStatus: null,
          ),
        ],
        verify: (_) {
          verify(mockGetCharacters(any)).called(1);
        },
      );

      blocTest<CharacterBloc, CharacterState>(
        'deve emitir [CharacterLoading, CharacterLoaded] com status quando filtrar por status',
        build: () {
          when(mockGetCharacters(any)).thenAnswer((_) async => testResponse);
          return characterBloc;
        },
        act: (bloc) => bloc.add(const LoadCharacters(status: 'alive')),
        expect: () => [
          const CharacterLoading(),
          CharacterLoaded(
            characters: testCharacters,
            nextUrl: null,
            hasMore: false,
            currentStatus: 'alive',
          ),
        ],
        verify: (_) {
          verify(mockGetCharacters(any)).called(1);
        },
      );

      blocTest<CharacterBloc, CharacterState>(
        'deve emitir [CharacterLoading, CharacterLoaded] com nextUrl quando houver próxima página',
        build: () {
          final responseWithNext = CharactersResponseEntity(
            count: 3,
            pages: 2,
            next: 'https://example.com/next',
            prev: null,
            characters: testCharacters,
          );
          when(mockGetCharacters(any)).thenAnswer((_) async => responseWithNext);
          return characterBloc;
        },
        act: (bloc) => bloc.add(const LoadCharacters()),
        expect: () => [
          const CharacterLoading(),
          CharacterLoaded(
            characters: testCharacters,
            nextUrl: 'https://example.com/next',
            hasMore: true,
            currentStatus: null,
          ),
        ],
      );

      blocTest<CharacterBloc, CharacterState>(
        'deve emitir [CharacterLoading, CharacterError] quando ocorrer erro',
        build: () {
          when(mockGetCharacters(any))
              .thenThrow(const ServerFailure('Erro ao carregar'));
          return characterBloc;
        },
        act: (bloc) => bloc.add(const LoadCharacters()),
        expect: () => [
          const CharacterLoading(),
          const CharacterError('Erro ao carregar'),
        ],
      );

      blocTest<CharacterBloc, CharacterState>(
        'deve emitir [CharacterLoading, CharacterError] com mensagem genérica quando ocorrer erro desconhecido',
        build: () {
          when(mockGetCharacters(any)).thenThrow(Exception('Erro desconhecido'));
          return characterBloc;
        },
        act: (bloc) => bloc.add(const LoadCharacters()),
        expect: () => [
          const CharacterLoading(),
          const CharacterError('Erro ao carregar personagens. Tente novamente.'),
        ],
      );
    });

    group('LoadMoreCharacters', () {
      final initialCharacters = TestHelpers.createTestCharactersList(3);
      final moreCharacters = List.generate(
        2,
        (index) => TestHelpers.createTestCharacter(
          id: index + 4, // IDs diferentes: 4, 5
          name: 'Character ${index + 4}',
        ),
      );
      final allCharacters = [...initialCharacters, ...moreCharacters];

      blocTest<CharacterBloc, CharacterState>(
        'deve emitir [CharacterLoadingMore, CharacterLoaded] quando carregar mais com sucesso',
        build: () {
          final moreResponse = CharactersResponseEntity(
            count: 5,
            pages: 2,
            next: null,
            prev: 'https://example.com/prev',
            characters: moreCharacters,
          );

          when(mockGetCharacters(any)).thenAnswer((_) async => moreResponse);
          return characterBloc;
        },
        seed: () => CharacterLoaded(
          characters: initialCharacters,
          nextUrl: 'https://example.com/next',
          hasMore: true,
          currentStatus: null,
        ),
        act: (bloc) => bloc.add(const LoadMoreCharacters('https://example.com/next')),
        expect: () => [
          CharacterLoadingMore(
            characters: initialCharacters,
            nextUrl: 'https://example.com/next',
            currentStatus: null,
          ),
          CharacterLoaded(
            characters: allCharacters,
            nextUrl: null,
            hasMore: false,
            currentStatus: null,
          ),
        ],
      );

      blocTest<CharacterBloc, CharacterState>(
        'deve preservar personagens anteriores quando ocorrer erro ao carregar mais',
        build: () {
          when(mockGetCharacters(any))
              .thenThrow(const ServerFailure('Erro ao carregar mais'));
          return characterBloc;
        },
        seed: () => CharacterLoaded(
          characters: initialCharacters,
          nextUrl: 'https://example.com/next',
          hasMore: true,
          currentStatus: null,
        ),
        act: (bloc) => bloc.add(const LoadMoreCharacters('https://example.com/next')),
        expect: () => [
          CharacterLoadingMore(
            characters: initialCharacters,
            nextUrl: 'https://example.com/next',
            currentStatus: null,
          ),
          CharacterError(
            'Erro ao carregar mais',
            previousCharacters: initialCharacters,
            currentStatus: null,
          ),
        ],
      );

      blocTest<CharacterBloc, CharacterState>(
        'não deve fazer nada se já estiver carregando mais',
        build: () => characterBloc,
        seed: () => CharacterLoadingMore(
          characters: initialCharacters,
          nextUrl: 'https://example.com/next',
          currentStatus: null,
        ),
        act: (bloc) => bloc.add(const LoadMoreCharacters('https://example.com/next')),
        expect: () => [],
      );

      blocTest<CharacterBloc, CharacterState>(
        'não deve fazer nada se o estado não for CharacterLoaded',
        build: () => characterBloc,
        seed: () => const CharacterInitial(),
        act: (bloc) => bloc.add(const LoadMoreCharacters('https://example.com/next')),
        expect: () => [],
      );
    });

    group('RefreshCharacters', () {
      final testCharacters = TestHelpers.createTestCharactersList(3);
      final testResponse = CharactersResponseEntity(
        count: 3,
        pages: 1,
        next: null,
        prev: null,
        characters: testCharacters,
      );

      blocTest<CharacterBloc, CharacterState>(
        'deve emitir CharacterLoaded quando atualizar com sucesso',
        build: () {
          when(mockGetCharacters(any)).thenAnswer((_) async => testResponse);
          return characterBloc;
        },
        act: (bloc) => bloc.add(const RefreshCharacters()),
        expect: () => [
          CharacterLoaded(
            characters: testCharacters,
            nextUrl: null,
            hasMore: false,
            currentStatus: null,
          ),
        ],
      );

      blocTest<CharacterBloc, CharacterState>(
        'deve emitir CharacterError quando ocorrer erro ao atualizar',
        build: () {
          when(mockGetCharacters(any))
              .thenThrow(const ServerFailure('Erro ao atualizar'));
          return characterBloc;
        },
        act: (bloc) => bloc.add(const RefreshCharacters()),
        expect: () => [
          const CharacterError('Erro ao atualizar'),
        ],
      );
    });

    group('FilterByStatus', () {
      final testCharacters = TestHelpers.createTestCharactersList(3);
      final testResponse = CharactersResponseEntity(
        count: 3,
        pages: 1,
        next: null,
        prev: null,
        characters: testCharacters,
      );

      blocTest<CharacterBloc, CharacterState>(
        'deve emitir [CharacterLoading, CharacterLoaded] quando filtrar por status',
        build: () {
          when(mockGetCharacters(any)).thenAnswer((_) async => testResponse);
          return characterBloc;
        },
        act: (bloc) => bloc.add(const FilterByStatus('alive')),
        expect: () => [
          const CharacterLoading(),
          CharacterLoaded(
            characters: testCharacters,
            nextUrl: null,
            hasMore: false,
            currentStatus: 'alive',
          ),
        ],
        verify: (_) {
          verify(mockGetCharacters(any)).called(1);
        },
      );

      blocTest<CharacterBloc, CharacterState>(
        'deve filtrar por "todos" quando status for null',
        build: () {
          when(mockGetCharacters(any)).thenAnswer((_) async => testResponse);
          return characterBloc;
        },
        act: (bloc) => bloc.add(const FilterByStatus(null)),
        expect: () => [
          const CharacterLoading(),
          CharacterLoaded(
            characters: testCharacters,
            nextUrl: null,
            hasMore: false,
            currentStatus: null,
          ),
        ],
        verify: (_) {
          verify(mockGetCharacters(any)).called(1);
        },
      );

      blocTest<CharacterBloc, CharacterState>(
        'deve emitir [CharacterLoading, CharacterError] quando ocorrer erro ao filtrar',
        build: () {
          when(mockGetCharacters(any))
              .thenThrow(const ServerFailure('Erro ao filtrar'));
          return characterBloc;
        },
        act: (bloc) => bloc.add(const FilterByStatus('alive')),
        expect: () => [
          const CharacterLoading(),
          const CharacterError('Erro ao filtrar'),
        ],
      );
    });
  });
}

