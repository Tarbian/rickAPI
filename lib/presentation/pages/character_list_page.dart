import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricknmorty/core/constants.dart';
import 'package:ricknmorty/di/injection.dart';
import 'package:ricknmorty/domain/usecases/get_characters_usecase.dart';
import 'package:ricknmorty/presentation/cubits/character_list_cubit.dart';
import 'package:ricknmorty/presentation/cubits/character_list_state.dart';
import 'package:ricknmorty/presentation/pages/character_detail_page.dart';
import 'package:ricknmorty/presentation/widgets/app_error_widget.dart';
import 'package:ricknmorty/presentation/widgets/character_card.dart';

class CharacterListPage extends StatelessWidget {
  const CharacterListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          CharacterListCubit(sl<GetCharactersUseCase>())..loadCharacters(),
      child: const _CharacterListView(),
    );
  }
}

class _CharacterListView extends StatefulWidget {
  const _CharacterListView();

  @override
  State<_CharacterListView> createState() => _CharacterListViewState();
}

class _CharacterListViewState extends State<_CharacterListView> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  String _lastSearch = '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<CharacterListCubit>().loadMore();
    }
  }

  void _onSearchChanged(String value) {
    if (value == _lastSearch) return;
    _lastSearch = value;
    context.read<CharacterListCubit>().loadCharacters(
          searchQuery: value.isEmpty ? null : value,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppConstants.screenPadding,
              0,
              AppConstants.screenPadding,
              8,
            ),
            child: SearchBar(
              controller: _searchController,
              hintText: AppConstants.searchHint,
              leading: const Icon(Icons.search_rounded),
              trailing: [
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear_rounded),
                    onPressed: () {
                      _searchController.clear();
                      _onSearchChanged('');
                    },
                  ),
              ],
              onChanged: _onSearchChanged,
            ),
          ),
        ),
      ),
      body: BlocBuilder<CharacterListCubit, CharacterListState>(
        builder: (context, state) {
          if (state is CharacterListLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CharacterListError) {
            return AppErrorWidget(
              message: state.message,
              isNetworkError: state.isNetworkError,
              onRetry: () => context.read<CharacterListCubit>().loadCharacters(
                    searchQuery: _lastSearch.isEmpty ? null : _lastSearch,
                  ),
            );
          }

          if (state is CharacterListEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off_rounded, size: 64),
                  const SizedBox(height: 16),
                  Text(
                    state.searchQuery != null
                        ? 'No characters found for "${state.searchQuery}"'
                        : AppConstants.noCharactersFound,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            );
          }

          if (state is CharacterListLoaded) {
            return ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(AppConstants.screenPadding),
              itemCount: state.characters.length + (state.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= state.characters.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final character = state.characters[index];
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: AppConstants.itemSpacing,
                  ),
                  child: CharacterCard(
                    character: character,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            CharacterDetailPage(character: character),
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
