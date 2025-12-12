import 'package:equatable/equatable.dart';

abstract class CharacterEvent extends Equatable {
  const CharacterEvent();

  @override
  List<Object?> get props => [];
}

class LoadCharacters extends CharacterEvent {
  final String? status;

  const LoadCharacters({this.status});

  @override
  List<Object?> get props => [status];
}

class LoadMoreCharacters extends CharacterEvent {
  final String nextUrl;

  const LoadMoreCharacters(this.nextUrl);

  @override
  List<Object?> get props => [nextUrl];
}

class RefreshCharacters extends CharacterEvent {
  final String? status;

  const RefreshCharacters({this.status});

  @override
  List<Object?> get props => [status];
}

class FilterByStatus extends CharacterEvent {
  final String? status;

  const FilterByStatus(this.status);

  @override
  List<Object?> get props => [status];
}

class SearchCharacters extends CharacterEvent {
  final String query;

  const SearchCharacters(this.query);

  @override
  List<Object?> get props => [query];
}

