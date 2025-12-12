import 'package:equatable/equatable.dart';
import 'character_entity.dart';

class CharactersResponseEntity extends Equatable {
  final int count;
  final int pages;
  final String? next;
  final String? prev;
  final List<CharacterEntity> characters;

  const CharactersResponseEntity({
    required this.count,
    required this.pages,
    this.next,
    this.prev,
    required this.characters,
  });

  @override
  List<Object?> get props => [count, pages, next, prev, characters];
}

