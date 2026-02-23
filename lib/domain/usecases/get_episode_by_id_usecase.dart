import 'package:ricknmorty/domain/entities/episode.dart';
import 'package:ricknmorty/domain/repositories/episode_repository.dart';

class GetEpisodeByIdUseCase {
  final EpisodeRepository _repository;
  GetEpisodeByIdUseCase(this._repository);

  Future<Episode> call(int id) {
    return _repository.getEpisodeById(id);
  }
}
