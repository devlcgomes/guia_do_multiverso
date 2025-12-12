import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/characters_response_model.dart';
import '../../core/error/failures.dart';

abstract class CharacterRemoteDataSource {
  Future<CharactersResponseModel> getCharacters({String? url, String? status, String? name});
}

class CharacterRemoteDataSourceImpl implements CharacterRemoteDataSource {
  final http.Client client;
  static const String baseUrl = 'https://rickandmortyapi.com/api/character';

  CharacterRemoteDataSourceImpl({required this.client});

  @override
  Future<CharactersResponseModel> getCharacters({String? url, String? status, String? name}) async {
    try {
      Uri uri;
      if (url != null) {
        uri = Uri.parse(url);
      } else {
        uri = Uri.parse(baseUrl);
        final queryParams = <String, String>{};
        if (status != null && status.isNotEmpty) {
          queryParams['status'] = status;
        }
        if (name != null && name.isNotEmpty) {
          queryParams['name'] = name;
        }
        if (queryParams.isNotEmpty) {
          uri = uri.replace(queryParameters: queryParams);
        }
      }

      final response = await client.get(uri).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw NetworkFailure('Tempo de conexão esgotado. Verifique sua internet e tente novamente.');
        },
      );

      if (response.statusCode == 200) {
        return CharactersResponseModel.fromJson(
          json.decode(response.body),
        );
      } else {
        throw ServerFailure('Erro ao carregar personagens. Tente novamente mais tarde.');
      }
    } catch (e) {
      if (e is Failure) rethrow;
      
      final errorMessage = e.toString().toLowerCase();
      if (errorMessage.contains('socket') || 
          errorMessage.contains('network') ||
          errorMessage.contains('connection') ||
          errorMessage.contains('internet')) {
        throw NetworkFailure('Sem conexão com a internet. Verifique sua rede e tente novamente.');
      }
      
      throw NetworkFailure('Erro ao conectar com o servidor. Tente novamente.');
    }
  }
}

