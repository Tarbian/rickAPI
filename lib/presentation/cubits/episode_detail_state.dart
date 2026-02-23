import 'package:equatable/equatable.dart';
import 'package:ricknmorty/domain/entities/character.dart';
import 'package:ricknmorty/domain/entities/episode.dart';

abstract class EpisodeDetailState extends Equatable {
  const EpisodeDetailState();
  @override
  List<Object?> get props => [];
}

class EpisodeDetailInitial extends EpisodeDetailState {
  const EpisodeDetailInitial();
}

class EpisodeDetailLoading extends EpisodeDetailState {
  final Episode episode;
  const EpisodeDetailLoading({required this.episode});
  @override
  List<Object?> get props => [episode];
}

class EpisodeDetailLoaded extends EpisodeDetailState {
  final Episode episode;
  final List<Character> characters;
  const EpisodeDetailLoaded({required this.episode, required this.characters});
  @override
  List<Object?> get props => [episode, characters];
}

class EpisodeDetailError extends EpisodeDetailState {
  final Episode episode;
  final String message;
  final bool isNetworkError;
  const EpisodeDetailError({
    required this.episode,
    required this.message,
    this.isNetworkError = false,
  });
  @override
  List<Object?> get props => [episode, message, isNetworkError];
}
