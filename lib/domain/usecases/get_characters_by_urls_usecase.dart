import 'package:ricknmorty/domain/entities/character.dart';
import 'package:ricknmorty/domain/repositories/character_repository.dart';

class GetCharactersByUrlsUseCase {
  final CharacterRepository _repository;
  GetCharactersByUrlsUseCase(this._repository);

  Future<List<Character>> call(List<String> urls) {
    return _repository.getCharactersByUrls(urls);
  }
}
