import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricknmorty/core/exeptions.dart';
import 'package:ricknmorty/domain/entities/character.dart';
import 'package:ricknmorty/domain/usecases/get_episodes_by_urls_usecase.dart';
import 'package:ricknmorty/presentation/cubits/character_detail_state.dart';

class CharacterDetailCubit extends Cubit<CharacterDetailState> {
  final GetEpisodesByUrlsUseCase _getEpisodesByUrlsUseCase;

  CharacterDetailCubit(this._getEpisodesByUrlsUseCase)
      : super(const CharacterDetailInitial());

  Future<void> loadCharacterDetail(Character character) async {
    emit(CharacterDetailLoading(character: character));
    try {
      final episodes = await _getEpisodesByUrlsUseCase(character.episodeUrls);
      emit(CharacterDetailLoaded(character: character, episodes: episodes));
    } on NetworkException catch (e) {
      emit(CharacterDetailError(
          character: character, message: e.message, isNetworkError: true));
    } on AppException catch (e) {
      emit(CharacterDetailError(character: character, message: e.message));
    } catch (e) {
      emit(CharacterDetailError(character: character, message: e.toString()));
    }
  }
}
