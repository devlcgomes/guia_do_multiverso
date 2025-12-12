import 'package:equatable/equatable.dart';

abstract class CharacterEvent extends Equatable {
  const CharacterEvent();

  @override
  List<Object?> get props => [];
}

class LoadCharacters extends CharacterEvent {
  const LoadCharacters();
}

class LoadMoreCharacters extends CharacterEvent {
  final String nextUrl;

  const LoadMoreCharacters(this.nextUrl);

  @override
  List<Object?> get props => [nextUrl];
}

class RefreshCharacters extends CharacterEvent {
  const RefreshCharacters();
}

