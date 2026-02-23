import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ricknmorty/core/constants.dart';
import 'package:ricknmorty/core/exeptions.dart';
import 'package:ricknmorty/data/models/character_model.dart';
import 'package:ricknmorty/data/models/episode_model.dart';

class RemoteDataSource {
  final http.Client _client;

  RemoteDataSource(this._client);

  Future<Map<String, dynamic>> _get(String url) async {
    try {
      final response = await _client.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else if (response.statusCode == 404) {
        throw const NotFoundException();
      } else {
        throw ServerException('Server error: ${response.statusCode}');
      }
    } on SocketException {
      throw const NetworkException();
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<List<dynamic>> _getList(String url) async {
    try {
      final response = await _client.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        return body is List ? body : [body];
      } else if (response.statusCode == 404) {
        throw const NotFoundException();
      } else {
        throw ServerException('Server error: ${response.statusCode}');
      }
    } on SocketException {
      throw const NetworkException();
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<({List<CharacterModel> characters, int? nextPage, int totalPages})>
      getCharacters({required int page, String? name}) async {
    var url = '${AppConstants.charactersEndpoint}?page=$page';
    if (name != null && name.isNotEmpty) {
      url += '&name=${Uri.encodeComponent(name)}';
    }
    final data = await _get(url);
    final info = data['info'] as Map<String, dynamic>;
    final nextUrl = info['next'] as String?;
    final totalPages = info['pages'] as int;

    int? nextPage;
    if (nextUrl != null) {
      final uri = Uri.parse(nextUrl);
      nextPage = int.tryParse(uri.queryParameters['page'] ?? '');
    }

    final results = (data['results'] as List)
        .map((e) => CharacterModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return (characters: results, nextPage: nextPage, totalPages: totalPages);
  }

  Future<List<CharacterModel>> getCharactersByUrls(List<String> urls) async {
    if (urls.isEmpty) return [];
    final ids = urls.map((url) => url.split('/').last).toList();
    final batchUrl = '${AppConstants.charactersEndpoint}/${ids.join(',')}';
    final data = await _getList(batchUrl);
    return data
        .map((e) => CharacterModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<EpisodeModel>> getEpisodesByUrls(List<String> urls) async {
    if (urls.isEmpty) return [];
    final ids = urls.map((url) => url.split('/').last).toList();
    final batchUrl = '${AppConstants.episodesEndpoint}/${ids.join(',')}';
    final data = await _getList(batchUrl);
    return data
        .map((e) => EpisodeModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<EpisodeModel> getEpisodeById(int id) async {
    final url = '${AppConstants.episodesEndpoint}/$id';
    final data = await _get(url);
    return EpisodeModel.fromJson(data);
  }
}
