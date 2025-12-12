import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_characters.dart';
import '../../../core/error/failures.dart';
import 'character_event.dart';
import 'character_state.dart';

class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  final GetCharacters getCharacters;

  CharacterBloc({required this.getCharacters}) : super(const CharacterInitial()) {
    on<LoadCharacters>(_onLoadCharacters);
    on<LoadMoreCharacters>(_onLoadMoreCharacters);
    on<RefreshCharacters>(_onRefreshCharacters);
  }

  Future<void> _onLoadCharacters(
    LoadCharacters event,
    Emitter<CharacterState> emit,
  ) async {
    emit(const CharacterLoading());

    try {
      final response = await getCharacters(GetCharactersParams());
      emit(
        CharacterLoaded(
          characters: response.characters,
          nextUrl: response.next,
          hasMore: response.next != null,
        ),
      );
    } catch (e) {
      if (e is Failure) {
        emit(CharacterError(e.message));
      } else {
        emit(CharacterError('Erro inesperado: $e'));
      }
    }
  }

  Future<void> _onLoadMoreCharacters(
    LoadMoreCharacters event,
    Emitter<CharacterState> emit,
  ) async {
    if (state is CharacterLoaded) {
      final currentState = state as CharacterLoaded;
      emit(CharacterLoadingMore(
        characters: currentState.characters,
        nextUrl: currentState.nextUrl,
      ));

      try {
        final response = await getCharacters(GetCharactersParams(url: event.nextUrl));
        final updatedCharacters = [
          ...currentState.characters,
          ...response.characters,
        ];
        emit(
          CharacterLoaded(
            characters: updatedCharacters,
            nextUrl: response.next,
            hasMore: response.next != null,
          ),
        );
      } catch (e) {
        if (e is Failure) {
          emit(CharacterError(e.message));
        } else {
          emit(CharacterError('Erro ao carregar mais: $e'));
        }
      }
    }
  }

  Future<void> _onRefreshCharacters(
    RefreshCharacters event,
    Emitter<CharacterState> emit,
  ) async {
    try {
      final response = await getCharacters(GetCharactersParams());
      emit(
        CharacterLoaded(
          characters: response.characters,
          nextUrl: response.next,
          hasMore: response.next != null,
        ),
      );
    } catch (e) {
      if (e is Failure) {
        emit(CharacterError(e.message));
      } else {
        emit(CharacterError('Erro ao atualizar: $e'));
      }
    }
  }
}

