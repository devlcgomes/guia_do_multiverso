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
  final String? currentStatus;

  const CharacterLoaded({
    required this.characters,
    this.nextUrl,
    required this.hasMore,
    this.currentStatus,
  });

  @override
  List<Object?> get props => [characters, nextUrl, hasMore, currentStatus];
}

class CharacterLoadingMore extends CharacterState {
  final List<CharacterEntity> characters;
  final String? nextUrl;
  final String? currentStatus;

  const CharacterLoadingMore({
    required this.characters,
    this.nextUrl,
    this.currentStatus,
  });

  @override
  List<Object?> get props => [characters, nextUrl, currentStatus];
}

class CharacterError extends CharacterState {
  final String message;
  final List<CharacterEntity>? previousCharacters;
  final String? currentStatus;

  const CharacterError(
    this.message, {
    this.previousCharacters,
    this.currentStatus,
  });

  @override
  List<Object?> get props => [message, previousCharacters, currentStatus];
}

