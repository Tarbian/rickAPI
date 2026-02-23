import 'package:ricknmorty/data/datasources/remote_data_source.dart';
import 'package:ricknmorty/domain/entities/episode.dart';
import 'package:ricknmorty/domain/repositories/episode_repository.dart';

class EpisodeRepositoryImpl implements EpisodeRepository {
  final RemoteDataSource _remoteDataSource;

  EpisodeRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Episode>> getEpisodesByUrls(List<String> urls) {
    return _remoteDataSource.getEpisodesByUrls(urls);
  }

  @override
  Future<Episode> getEpisodeById(int id) {
    return _remoteDataSource.getEpisodeById(id);
  }
}
