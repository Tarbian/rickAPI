import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricknmorty/core/exeptions.dart';
import 'package:ricknmorty/domain/entities/episode.dart';
import 'package:ricknmorty/domain/usecases/get_characters_by_urls_usecase.dart';
import 'package:ricknmorty/presentation/cubits/episode_detail_state.dart';

class EpisodeDetailCubit extends Cubit<EpisodeDetailState> {
  final GetCharactersByUrlsUseCase _getCharactersByUrlsUseCase;

  EpisodeDetailCubit(this._getCharactersByUrlsUseCase)
      : super(const EpisodeDetailInitial());

  Future<void> loadEpisodeDetail(Episode episode) async {
    emit(EpisodeDetailLoading(episode: episode));
    try {
      final characters =
          await _getCharactersByUrlsUseCase(episode.characterUrls);
      emit(EpisodeDetailLoaded(episode: episode, characters: characters));
    } on NetworkException catch (e) {
      emit(EpisodeDetailError(
          episode: episode, message: e.message, isNetworkError: true));
    } on AppException catch (e) {
      emit(EpisodeDetailError(episode: episode, message: e.message));
    } catch (e) {
      emit(EpisodeDetailError(episode: episode, message: e.toString()));
    }
  }
}
