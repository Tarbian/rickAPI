import 'package:ricknmorty/domain/entities/character.dart';

class CharacterModel extends Character {
  const CharacterModel({
    required super.id,
    required super.name,
    required super.status,
    required super.species,
    required super.type,
    required super.gender,
    required super.originName,
    required super.locationName,
    required super.image,
    required super.episodeUrls,
    required super.url,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id'] as int,
      name: json['name'] as String,
      status: json['status'] as String,
      species: json['species'] as String,
      type: json['type'] as String,
      gender: json['gender'] as String,
      originName: (json['origin'] as Map<String, dynamic>)['name'] as String,
      locationName:
          (json['location'] as Map<String, dynamic>)['name'] as String,
      image: json['image'] as String,
      episodeUrls: List<String>.from(json['episode'] as List),
      url: json['url'] as String,
    );
  }
}
