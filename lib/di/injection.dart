import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:ricknmorty/data/datasources/remote_data_source.dart';
import 'package:ricknmorty/data/repositories/character_repository_impl.dart';
import 'package:ricknmorty/data/repositories/episode_repository_impl.dart';
import 'package:ricknmorty/domain/repositories/character_repository.dart';
import 'package:ricknmorty/domain/repositories/episode_repository.dart';
import 'package:ricknmorty/domain/usecases/get_characters_by_urls_usecase.dart';
import 'package:ricknmorty/domain/usecases/get_characters_usecase.dart';
import 'package:ricknmorty/domain/usecases/get_episode_by_id_usecase.dart';
import 'package:ricknmorty/domain/usecases/get_episodes_by_urls_usecase.dart';

final sl = GetIt.instance;

void setupDi() {
  sl.registerLazySingleton<http.Client>(() => http.Client());

  sl.registerLazySingleton<RemoteDataSource>(
    () => RemoteDataSource(sl<http.Client>()),
  );

  sl.registerLazySingleton<CharacterRepository>(
    () => CharacterRepositoryImpl(sl<RemoteDataSource>()),
  );
  sl.registerLazySingleton<EpisodeRepository>(
    () => EpisodeRepositoryImpl(sl<RemoteDataSource>()),
  );

  sl.registerLazySingleton(
      () => GetCharactersUseCase(sl<CharacterRepository>()));
  sl.registerLazySingleton(
      () => GetCharactersByUrlsUseCase(sl<CharacterRepository>()));
  sl.registerLazySingleton(
      () => GetEpisodesByUrlsUseCase(sl<EpisodeRepository>()));
  sl.registerLazySingleton(
      () => GetEpisodeByIdUseCase(sl<EpisodeRepository>()));
}
