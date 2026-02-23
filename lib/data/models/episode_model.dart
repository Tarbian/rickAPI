import 'package:ricknmorty/domain/entities/episode.dart';

class EpisodeModel extends Episode {
  const EpisodeModel({
    required super.id,
    required super.name,
    required super.airDate,
    required super.episode,
    required super.characterUrls,
  });

  factory EpisodeModel.fromJson(Map<String, dynamic> json) {
    return EpisodeModel(
      id: json['id'] as int,
      name: json['name'] as String,
      airDate: json['air_date'] as String,
      episode: json['episode'] as String,
      characterUrls: List<String>.from(json['characters'] as List),
    );
  }
}
