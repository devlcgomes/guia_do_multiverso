import 'package:equatable/equatable.dart';
import '../../../domain/entities/character_entity.dart';

abstract class CharacterState extends Equatable {
  const CharacterState();

  @override
  List<Object?> get props => [];
}

class CharacterInitial extends CharacterState {
  const CharacterInitial();
}

class CharacterLoading extends CharacterState {
  const CharacterLoading();
}

class CharacterLoaded extends CharacterState {
  final List<CharacterEntity> characters;
  final String? nextUrl;
  final bool hasMore;

  const CharacterLoaded({
    required this.characters,
    this.nextUrl,
    required this.hasMore,
  });

  @override
  List<Object?> get props => [characters, nextUrl, hasMore];
}

class CharacterLoadingMore extends CharacterState {
  final List<CharacterEntity> characters;
  final String? nextUrl;

  const CharacterLoadingMore({
    required this.characters,
    this.nextUrl,
  });

  @override
  List<Object?> get props => [characters, nextUrl];
}

class CharacterError extends CharacterState {
  final String message;

  const CharacterError(this.message);

  @override
  List<Object?> get props => [message];
}

