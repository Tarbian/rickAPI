import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricknmorty/core/constants.dart';
import 'package:ricknmorty/di/injection.dart';
import 'package:ricknmorty/domain/entities/character.dart';
import 'package:ricknmorty/domain/usecases/get_episodes_by_urls_usecase.dart';
import 'package:ricknmorty/presentation/cubits/character_detail_cubit.dart';
import 'package:ricknmorty/presentation/cubits/character_detail_state.dart';
import 'package:ricknmorty/presentation/pages/episode_detail_page.dart';
import 'package:ricknmorty/presentation/widgets/app_error_widget.dart';
import 'package:ricknmorty/presentation/widgets/info_row.dart';
import 'package:ricknmorty/presentation/widgets/section_card.dart';

class CharacterDetailPage extends StatelessWidget {
  final Character character;

  const CharacterDetailPage({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CharacterDetailCubit(sl<GetEpisodesByUrlsUseCase>())
        ..loadCharacterDetail(character),
      child: _CharacterDetailView(character: character),
    );
  }
}

class _CharacterDetailView extends StatelessWidget {
  final Character character;

  const _CharacterDetailView({required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(character.name)),
      body: BlocBuilder<CharacterDetailCubit, CharacterDetailState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(AppConstants.screenPadding),
            children: [
              SectionCard(
                title: 'Character Info',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            AppConstants.cardBorderRadius),
                        child: Image.network(
                          character.image,
                          width: AppConstants.detailAvatarSize,
                          height: AppConstants.detailAvatarSize,
                          fit: BoxFit.cover,
                          loadingBuilder: (_, child, progress) {
                            if (progress == null) return child;
                            return const SizedBox(
                              width: AppConstants.detailAvatarSize,
                              height: AppConstants.detailAvatarSize,
                              child: Center(
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                            );
                          },
                          errorBuilder: (_, __, ___) => Container(
                            width: AppConstants.detailAvatarSize,
                            height: AppConstants.detailAvatarSize,
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                            child: const Icon(Icons.broken_image_outlined,
                                size: 48),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    InfoRow(
                      label: 'Status',
                      icon: Icons.circle_outlined,
                      value: character.status,
                    ),
                    InfoRow(
                      label: 'Species',
                      icon: Icons.category_outlined,
                      value: character.species,
                    ),
                    InfoRow(
                      label: 'Gender',
                      icon: Icons.person_outline,
                      value: character.gender,
                    ),
                    InfoRow(
                      label: 'Origin',
                      icon: Icons.public_outlined,
                      value: character.originName,
                    ),
                    InfoRow(
                      label: 'Location',
                      icon: Icons.location_on_outlined,
                      value: character.locationName,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.itemSpacing),
              _buildEpisodesSection(context, state),
              const SizedBox(height: AppConstants.screenPadding),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEpisodesSection(
      BuildContext context, CharacterDetailState state) {
    if (state is CharacterDetailLoading) {
      return const SectionCard(
        title: 'Episodes',
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (state is CharacterDetailError) {
      return SectionCard(
        title: 'Episodes',
        child: AppErrorWidget(
          message: state.message,
          isNetworkError: state.isNetworkError,
          onRetry: () => context
              .read<CharacterDetailCubit>()
              .loadCharacterDetail(character),
        ),
      );
    }

    if (state is CharacterDetailLoaded) {
      if (state.episodes.isEmpty) {
        return const SectionCard(
          title: 'Episodes',
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(AppConstants.noEpisodesFound),
            ),
          ),
        );
      }

      return SectionCard(
        title: 'Episodes (${state.episodes.length})',
        child: Column(
          children: state.episodes
              .map(
                (ep) => Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 1,
                  child: ListTile(
                    dense: true,
                    leading: const Icon(Icons.tv_outlined),
                    title: Text(ep.name),
                    subtitle: Text(ep.episode),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EpisodeDetailPage(episode: ep),
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
