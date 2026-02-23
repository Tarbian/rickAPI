import 'package:equatable/equatable.dart';
import 'package:ricknmorty/domain/entities/character.dart';

abstract class CharacterListState extends Equatable {
  const CharacterListState();
  @override
  List<Object?> get props => [];
}

class CharacterListInitial extends CharacterListState {
  const CharacterListInitial();
}

class CharacterListLoading extends CharacterListState {
  const CharacterListLoading();
}

class CharacterListLoaded extends CharacterListState {
  final List<Character> characters;
  final bool hasMore;
  final bool isLoadingMore;
  final String? searchQuery;

  const CharacterListLoaded({
    required this.characters,
    required this.hasMore,
    this.isLoadingMore = false,
    this.searchQuery,
  });

  CharacterListLoaded copyWith({
    List<Character>? characters,
    bool? hasMore,
    bool? isLoadingMore,
    String? searchQuery,
  }) {
    return CharacterListLoaded(
      characters: characters ?? this.characters,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [characters, hasMore, isLoadingMore, searchQuery];
}

class CharacterListError extends CharacterListState {
  final String message;
  final bool isNetworkError;

  const CharacterListError(
      {required this.message, this.isNetworkError = false});

  @override
  List<Object?> get props => [message, isNetworkError];
}

class CharacterListEmpty extends CharacterListState {
  final String? searchQuery;
  const CharacterListEmpty({this.searchQuery});
  @override
  List<Object?> get props => [searchQuery];
}
