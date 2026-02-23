import 'package:ricknmorty/domain/entities/episode.dart';

abstract class EpisodeRepository {
  Future<List<Episode>> getEpisodesByUrls(List<String> urls);
  Future<Episode> getEpisodeById(int id);
}
