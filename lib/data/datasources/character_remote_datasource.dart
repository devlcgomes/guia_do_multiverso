import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/characters_response_model.dart';
import '../../core/error/failures.dart';

abstract class CharacterRemoteDataSource {
  Future<CharactersResponseModel> getCharacters({String? url, String? status});
}

class CharacterRemoteDataSourceImpl implements CharacterRemoteDataSource {
  final http.Client client;
  static const String baseUrl = 'https://rickandmortyapi.com/api/character';

  CharacterRemoteDataSourceImpl({required this.client});

  @override
  Future<CharactersResponseModel> getCharacters({String? url, String? status}) async {
    try {
      Uri uri;
      if (url != null) {
        uri = Uri.parse(url);
      } else {
        uri = Uri.parse(baseUrl);
        if (status != null && status.isNotEmpty) {
          uri = uri.replace(queryParameters: {'status': status});
        }
      }

      final response = await client.get(uri);

      if (response.statusCode == 200) {
        return CharactersResponseModel.fromJson(
          json.decode(response.body),
        );
      } else {
        throw ServerFailure('Erro ao carregar personagens: ${response.statusCode}');
      }
    } catch (e) {
      if (e is Failure) rethrow;
      throw NetworkFailure('Erro de conexão: $e');
    }
  }
}

