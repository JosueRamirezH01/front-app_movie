import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories_impl.dart';
import '../domain/entities.dart';
import '../domain/repositories.dart';
import '../hive/local_datasource.dart';

// ─── DATASOURCE PROVIDER ───────────────────────────────────────────────────────
final localDataSourceProvider = Provider<HiveLocalDataSource>(
      (ref) => HiveLocalDataSource(), // factory → retorna _instance
);

// ─── REPOSITORY PROVIDERS ──────────────────────────────────────────────────────
final programRepositoryProvider = Provider<ProgramRepository>((ref) {
  return ProgramRepositoryImpl(ref.watch(localDataSourceProvider));
});

final seasonRepositoryProvider = Provider<SeasonRepository>((ref) {
  return SeasonRepositoryImpl(ref.watch(localDataSourceProvider));
});

final episodeRepositoryProvider = Provider<EpisodeRepository>((ref) {
  return EpisodeRepositoryImpl(ref.watch(localDataSourceProvider));
});

// ─── PROGRAMS PROVIDER ─────────────────────────────────────────────────────────
final programsProvider = FutureProvider<List<Program>>((ref) async {
  final repo = ref.watch(programRepositoryProvider);
  final result = await repo.getPrograms();
  return result.fold(
        (failure) => throw Exception(failure.message),
        (programs) => programs,
  );
});

final featuredProgramsProvider = FutureProvider<List<Program>>((ref) async {
  final repo = ref.watch(programRepositoryProvider);
  final result = await repo.getFeaturedPrograms();
  return result.fold(
        (failure) => throw Exception(failure.message),
        (programs) => programs,
  );
});

final programByIdProvider =
FutureProvider.family<Program, String>((ref, id) async {
  final repo = ref.watch(programRepositoryProvider);
  final result = await repo.getProgramById(id);
  return result.fold(
        (failure) => throw Exception(failure.message),
        (program) => program,
  );
});

// ─── SEARCH PROVIDER ───────────────────────────────────────────────────────────
final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = FutureProvider<List<Program>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return [];
  final repo = ref.watch(programRepositoryProvider);
  final result = await repo.searchPrograms(query);
  return result.fold(
        (failure) => throw Exception(failure.message),
        (programs) => programs,
  );
});

// ─── SEASONS PROVIDER ──────────────────────────────────────────────────────────
final seasonsByProgramProvider =
FutureProvider.family<List<Season>, String>((ref, programId) async {
  final repo = ref.watch(seasonRepositoryProvider);
  final result = await repo.getSeasonsByProgram(programId);
  return result.fold(
        (failure) => throw Exception(failure.message),
        (seasons) => seasons,
  );
});

// ─── EPISODES PROVIDER ─────────────────────────────────────────────────────────
final episodesBySeasonProvider =
FutureProvider.family<List<Episode>, String>((ref, seasonId) async {
  final repo = ref.watch(episodeRepositoryProvider);
  final result = await repo.getEpisodesBySeason(seasonId);
  return result.fold(
        (failure) => throw Exception(failure.message),
        (episodes) => episodes,
  );
});

final continueWatchingProvider = FutureProvider<List<Episode>>((ref) async {
  final repo = ref.watch(episodeRepositoryProvider);
  final result = await repo.getContinueWatching();
  return result.fold(
        (failure) => throw Exception(failure.message),
        (episodes) => episodes,
  );
});

// ─── SELECTED SEASON PROVIDER ──────────────────────────────────────────────────
final selectedSeasonIndexProvider =
StateProvider.family<int, String>((ref, programId) => 0);

// ─── PLAYER PROVIDER ───────────────────────────────────────────────────────────
class PlayerState {
  final Episode? episode;
  final bool isPlaying;
  final Duration position;
  final bool showControls;

  const PlayerState({
    this.episode,
    this.isPlaying = false,
    this.position = Duration.zero,
    this.showControls = true,
  });

  PlayerState copyWith({
    Episode? episode,
    bool? isPlaying,
    Duration? position,
    bool? showControls,
  }) =>
      PlayerState(
        episode: episode ?? this.episode,
        isPlaying: isPlaying ?? this.isPlaying,
        position: position ?? this.position,
        showControls: showControls ?? this.showControls,
      );
}

class PlayerNotifier extends StateNotifier<PlayerState> {
  final EpisodeRepository _repo;

  PlayerNotifier(this._repo) : super(const PlayerState());

  void setEpisode(Episode episode) {
    state = state.copyWith(
      episode: episode,
      position: episode.watchProgress ?? Duration.zero,
      isPlaying: true,
    );
  }

  void togglePlayPause() {
    state = state.copyWith(isPlaying: !state.isPlaying);
  }

  void updatePosition(Duration position) {
    state = state.copyWith(position: position);
    if (state.episode != null) {
      _repo.updateWatchProgress(state.episode!.id, position);
    }
  }

  void toggleControls() {
    state = state.copyWith(showControls: !state.showControls);
  }
}

final playerProvider = StateNotifierProvider<PlayerNotifier, PlayerState>((ref) {
  return PlayerNotifier(ref.watch(episodeRepositoryProvider));
});