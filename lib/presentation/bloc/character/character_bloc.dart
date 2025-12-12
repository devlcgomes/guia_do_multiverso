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
    on<FilterByStatus>(_onFilterByStatus);
  }

  Future<void> _onLoadCharacters(
    LoadCharacters event,
    Emitter<CharacterState> emit,
  ) async {
    emit(const CharacterLoading());

    try {
      final response = await getCharacters(GetCharactersParams(status: event.status));
      emit(
        CharacterLoaded(
          characters: response.characters,
          nextUrl: response.next,
          hasMore: response.next != null,
          currentStatus: event.status,
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
        currentStatus: currentState.currentStatus,
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
            currentStatus: currentState.currentStatus,
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
      final status = event.status ?? (state is CharacterLoaded ? (state as CharacterLoaded).currentStatus : null);
      final response = await getCharacters(GetCharactersParams(status: status));
      emit(
        CharacterLoaded(
          characters: response.characters,
          nextUrl: response.next,
          hasMore: response.next != null,
          currentStatus: status,
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

  Future<void> _onFilterByStatus(
    FilterByStatus event,
    Emitter<CharacterState> emit,
  ) async {
    emit(const CharacterLoading());

    try {
      final response = await getCharacters(GetCharactersParams(status: event.status));
      emit(
        CharacterLoaded(
          characters: response.characters,
          nextUrl: response.next,
          hasMore: response.next != null,
          currentStatus: event.status,
        ),
      );
    } catch (e) {
      if (e is Failure) {
        emit(CharacterError(e.message));
      } else {
        emit(CharacterError('Erro ao filtrar: $e'));
      }
    }
  }
}

