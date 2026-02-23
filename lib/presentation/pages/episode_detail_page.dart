import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricknmorty/core/constants.dart';
import 'package:ricknmorty/di/injection.dart';
import 'package:ricknmorty/domain/entities/episode.dart';
import 'package:ricknmorty/domain/usecases/get_characters_by_urls_usecase.dart';
import 'package:ricknmorty/presentation/cubits/episode_detail_cubit.dart';
import 'package:ricknmorty/presentation/cubits/episode_detail_state.dart';
import 'package:ricknmorty/presentation/widgets/app_error_widget.dart';
import 'package:ricknmorty/presentation/widgets/info_row.dart';
import 'package:ricknmorty/presentation/widgets/section_card.dart';

class EpisodeDetailPage extends StatelessWidget {
  final Episode episode;

  const EpisodeDetailPage({super.key, required this.episode});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EpisodeDetailCubit(sl<GetCharactersByUrlsUseCase>())
        ..loadEpisodeDetail(episode),
      child: _EpisodeDetailView(episode: episode),
    );
  }
}

class _EpisodeDetailView extends StatelessWidget {
  final Episode episode;

  const _EpisodeDetailView({required this.episode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(episode.episode)),
      body: BlocBuilder<EpisodeDetailCubit, EpisodeDetailState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(AppConstants.screenPadding),
            children: [
              SectionCard(
                title: 'Episode Info',
                child: Column(
                  children: [
                    InfoRow(
                      label: 'Title',
                      icon: Icons.title_rounded,
                      value: episode.name,
                    ),
                    InfoRow(
                      label: 'Episode',
                      icon: Icons.tv_rounded,
                      value: episode.episode,
                    ),
                    InfoRow(
                      label: 'Air Date',
                      icon: Icons.calendar_today_rounded,
                      value: episode.airDate,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.itemSpacing),
              _buildCharactersSection(context, state),
              const SizedBox(height: AppConstants.screenPadding),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCharactersSection(
    BuildContext context,
    EpisodeDetailState state,
  ) {
    if (state is EpisodeDetailLoading) {
      return const SectionCard(
        title: 'Characters',
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (state is EpisodeDetailError) {
      return SectionCard(
        title: 'Characters',
        child: AppErrorWidget(
          message: state.message,
          isNetworkError: state.isNetworkError,
          onRetry: () =>
              context.read<EpisodeDetailCubit>().loadEpisodeDetail(episode),
        ),
      );
    }

    if (state is EpisodeDetailLoaded) {
      if (state.characters.isEmpty) {
        return const SectionCard(
          title: 'Characters',
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('No characters found.'),
            ),
          ),
        );
      }

      return SectionCard(
        title: 'Characters (${state.characters.length})',
        child: Column(
          children: state.characters
              .map(
                (c) => Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 1,
                  child: ListTile(
                    dense: true,
                    leading: const Icon(Icons.person_outline_rounded),
                    title: Text(c.name),
                    subtitle: Text(c.status),
                    trailing: Text(
                      c.species,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
