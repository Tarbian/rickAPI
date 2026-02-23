import 'package:equatable/equatable.dart';
import 'package:ricknmorty/domain/entities/character.dart';
import 'package:ricknmorty/domain/entities/episode.dart';

abstract class CharacterDetailState extends Equatable {
  const CharacterDetailState();
  @override
  List<Object?> get props => [];
}

class CharacterDetailInitial extends CharacterDetailState {
  const CharacterDetailInitial();
}

class CharacterDetailLoading extends CharacterDetailState {
  final Character character;
  const CharacterDetailLoading({required this.character});
  @override
  List<Object?> get props => [character];
}

class CharacterDetailLoaded extends CharacterDetailState {
  final Character character;
  final List<Episode> episodes;
  const CharacterDetailLoaded(
      {required this.character, required this.episodes});
  @override
  List<Object?> get props => [character, episodes];
}

class CharacterDetailError extends CharacterDetailState {
  final Character character;
  final String message;
  final bool isNetworkError;
  const CharacterDetailError({
    required this.character,
    required this.message,
    this.isNetworkError = false,
  });
  @override
  List<Object?> get props => [character, message, isNetworkError];
}
