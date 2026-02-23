import 'package:ricknmorty/domain/entities/character.dart';
import 'package:ricknmorty/domain/entities/paginated_result.dart';

abstract class CharacterRepository {
  Future<PaginatedResult<Character>> getCharacters({
    required int page,
    String? name,
  });

  Future<List<Character>> getCharactersByUrls(List<String> urls);
}
