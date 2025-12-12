import 'package:equatable/equatable.dart';

class CharacterEntity extends Equatable {
  final int id;
  final String name;
  final String status;
  final String species;
  final String type;
  final String gender;
  final String image;
  final String url;
  final String location;
  final String origin;
  final List<String> episodes;
  final DateTime created;

  const CharacterEntity({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.image,
    required this.url,
    required this.location,
    required this.origin,
    required this.episodes,
    required this.created,
  });

  @override
  List<Object> get props => [
        id,
        name,
        status,
        species,
        type,
        gender,
        image,
        url,
        location,
        origin,
        episodes,
        created,
      ];
}

