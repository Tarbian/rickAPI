import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricknmorty/core/exeptions.dart';
import 'package:ricknmorty/domain/usecases/get_characters_usecase.dart';
import 'package:ricknmorty/presentation/cubits/character_list_state.dart';

class CharacterListCubit extends Cubit<CharacterListState> {
  final GetCharactersUseCase _getCharactersUseCase;

  int _currentPage = 1;
  String? _searchQuery;

  CharacterListCubit(this._getCharactersUseCase)
      : super(const CharacterListInitial());

  Future<void> loadCharacters({String? searchQuery}) async {
    _currentPage = 1;
    _searchQuery = searchQuery;
    emit(const CharacterListLoading());
    await _fetchPage();
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! CharacterListLoaded ||
        !current.hasMore ||
        current.isLoadingMore) return;
    emit(current.copyWith(isLoadingMore: true));
    _currentPage++;
    await _fetchPage(append: true);
  }

  Future<void> _fetchPage({bool append = false}) async {
    try {
      final paginated = await _getCharactersUseCase(
        page: _currentPage,
        name: _searchQuery,
      );

      if (!append && paginated.results.isEmpty) {
        emit(CharacterListEmpty(searchQuery: _searchQuery));
        return;
      }

      final existing = append && state is CharacterListLoaded
          ? (state as CharacterListLoaded).characters
          : [];

      emit(CharacterListLoaded(
        characters: [...existing, ...paginated.results],
        hasMore: paginated.hasMore,
        isLoadingMore: false,
        searchQuery: _searchQuery,
      ));
    } on NetworkException catch (e) {
      _handleError(e.message, isNetworkError: true, append: append);
    } on NotFoundException catch (_) {
      if (!append) emit(CharacterListEmpty(searchQuery: _searchQuery));
    } on AppException catch (e) {
      _handleError(e.message, append: append);
    } catch (e) {
      _handleError(e.toString(), append: append);
    }
  }

  void _handleError(String message,
      {bool isNetworkError = false, bool append = false}) {
    if (append) {
      _currentPage--;
      final current = state;
      if (current is CharacterListLoaded) {
        emit(current.copyWith(isLoadingMore: false));
      }
    } else {
      emit(
          CharacterListError(message: message, isNetworkError: isNetworkError));
    }
  }
}
