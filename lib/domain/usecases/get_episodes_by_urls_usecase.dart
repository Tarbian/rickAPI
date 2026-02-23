import 'package:ricknmorty/domain/entities/episode.dart';
import 'package:ricknmorty/domain/repositories/episode_repository.dart';

class GetEpisodesByUrlsUseCase {
  final EpisodeRepository _repository;
  GetEpisodesByUrlsUseCase(this._repository);

  Future<List<Episode>> call(List<String> urls) {
    return _repository.getEpisodesByUrls(urls);
  }
}
