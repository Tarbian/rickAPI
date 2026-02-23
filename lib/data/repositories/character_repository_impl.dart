import 'package:ricknmorty/data/datasources/remote_data_source.dart';
import 'package:ricknmorty/domain/entities/character.dart';
import 'package:ricknmorty/domain/entities/paginated_result.dart';
import 'package:ricknmorty/domain/repositories/character_repository.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  final RemoteDataSource _remoteDataSource;

  CharacterRepositoryImpl(this._remoteDataSource);

  @override
  Future<PaginatedResult<Character>> getCharacters({
    required int page,
    String? name,
  }) async {
    final result =
        await _remoteDataSource.getCharacters(page: page, name: name);
    return PaginatedResult(
      results: result.characters,
      nextPage: result.nextPage,
      totalPages: result.totalPages,
    );
  }

  @override
  Future<List<Character>> getCharactersByUrls(List<String> urls) {
    return _remoteDataSource.getCharactersByUrls(urls);
  }
}
