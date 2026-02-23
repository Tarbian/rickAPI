import 'package:ricknmorty/domain/entities/character.dart';
import 'package:ricknmorty/domain/entities/paginated_result.dart';
import 'package:ricknmorty/domain/repositories/character_repository.dart';


class GetCharactersUseCase {
  final CharacterRepository _repository;
  GetCharactersUseCase(this._repository);

  Future<PaginatedResult<Character>> call({required int page, String? name}) {
    return _repository.getCharacters(page: page, name: name);
  }
}
