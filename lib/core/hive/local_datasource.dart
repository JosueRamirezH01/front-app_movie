import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'hive_models.dart';

const _uuid = Uuid();

abstract class LocalDataSource {
  Future<List<ProgramHiveModel>> getPrograms();
  Future<ProgramHiveModel?> getProgramById(String id);
  Future<List<SeasonHiveModel>> getSeasonsByProgram(String programId);
  Future<List<EpisodeHiveModel>> getEpisodesBySeason(String seasonId);
  Future<void> updateEpisodeProgress(String episodeId, int progressSeconds);
  Future<List<EpisodeHiveModel>> getContinueWatching();
}

class HiveLocalDataSource implements LocalDataSource {
  // ─── SINGLETON ───────────────────────────────────────────────────────────────
  static final HiveLocalDataSource _instance = HiveLocalDataSource._internal();

  factory HiveLocalDataSource() => _instance;

  HiveLocalDataSource._internal();

  // ─── BOXES ───────────────────────────────────────────────────────────────────
  static const _programsBox = 'programs';
  static const _seasonsBox = 'seasons';
  static const _episodesBox = 'episodes';

  Box<ProgramHiveModel> get _programs => Hive.box<ProgramHiveModel>(_programsBox);
  Box<SeasonHiveModel> get _seasons => Hive.box<SeasonHiveModel>(_seasonsBox);
  Box<EpisodeHiveModel> get _episodes => Hive.box<EpisodeHiveModel>(_episodesBox);

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ProgramHiveModelAdapter());
    Hive.registerAdapter(SeasonHiveModelAdapter());
    Hive.registerAdapter(EpisodeHiveModelAdapter());

    await Hive.openBox<ProgramHiveModel>(_programsBox);
    await Hive.openBox<SeasonHiveModel>(_seasonsBox);
    await Hive.openBox<EpisodeHiveModel>(_episodesBox);

    final instance = HiveLocalDataSource();
    if ((await instance.getPrograms()).isEmpty) {
      await instance._seedMockData();
    }
  }

  @override
  Future<List<ProgramHiveModel>> getPrograms() async =>
      _programs.values.toList();

  @override
  Future<ProgramHiveModel?> getProgramById(String id) async =>
      _programs.get(id);

  @override
  Future<List<SeasonHiveModel>> getSeasonsByProgram(String programId) async =>
      _seasons.values
          .where((s) => s.programId == programId)
          .toList()
        ..sort((a, b) => a.seasonNumber.compareTo(b.seasonNumber));

  @override
  Future<List<EpisodeHiveModel>> getEpisodesBySeason(String seasonId) async =>
      _episodes.values
          .where((e) => e.seasonId == seasonId)
          .toList()
        ..sort((a, b) => a.episodeNumber.compareTo(b.episodeNumber));

  @override
  Future<void> updateEpisodeProgress(
      String episodeId,
      int progressSeconds,
      ) async {
    final episode = _episodes.get(episodeId);
    if (episode != null) {
      episode.watchProgressSeconds = progressSeconds;
      final totalSeconds = episode.durationSeconds;
      episode.isWatched = progressSeconds >= (totalSeconds * 0.9).toInt();
      await episode.save();
    }
  }

  @override
  Future<List<EpisodeHiveModel>> getContinueWatching() async =>
      _episodes.values
          .where((e) =>
      e.watchProgressSeconds != null &&
          e.watchProgressSeconds! > 0 &&
          !e.isWatched)
          .toList()
        ..sort((a, b) => b.watchProgressSeconds!.compareTo(a.watchProgressSeconds!));

  // ─── SEED DATA ──────────────────────────────────────────────────────────────
  Future<void> _seedMockData() async {
    final programs = _buildPrograms();
    for (final p in programs) {
      await _programs.put(p.id, p);
    }

    final seasons = _buildSeasons(programs);
    for (final s in seasons) {
      await _seasons.put(s.id, s);
    }

    final episodes = _buildEpisodes(seasons);
    for (final e in episodes) {
      await _episodes.put(e.id, e);
    }
  }

  List<ProgramHiveModel> _buildPrograms() {
    return [
      _program(
        id: 'prog_hh_clasico',
        title: 'Hablando Huevadas Clásico',
        description: 'El programa original que lo inició todo. Humor sin filtros, entrevistas locas y sketches que marcaron una generación.',
        thumbnail: 'https://picsum.photos/seed/hh1/400/600',
        banner: 'https://picsum.photos/seed/hh1b/1280/720',
        category: 'Comedia',
        tags: ['humor', 'entrevistas', 'clasico'],
        rating: 9.2,
        totalEpisodes: 48,
        totalSeasons: 4,
        isNew: false,
        isFeatured: true,
      ),
      _program(
        id: 'prog_hh_debate',
        title: 'El Debate Huevón',
        description: 'Debates sobre temas absurdos con invitados especiales. ¿Cuál es mejor: la sierra o la costa? Lo resolvemos aquí.',
        thumbnail: 'https://picsum.photos/seed/hh2/400/600',
        banner: 'https://picsum.photos/seed/hh2b/1280/720',
        category: 'Talk Show',
        tags: ['debate', 'invitados', 'opinion'],
        rating: 8.7,
        totalEpisodes: 24,
        totalSeasons: 2,
        isNew: false,
        isFeatured: true,
      ),
      _program(
        id: 'prog_hh_calle',
        title: 'HH en la Calle',
        description: 'Salimos a las calles de Lima a hacerle preguntas imposibles a la gente. Las respuestas son oro puro.',
        thumbnail: 'https://picsum.photos/seed/hh3/400/600',
        banner: 'https://picsum.photos/seed/hh3b/1280/720',
        category: 'Reality',
        tags: ['calle', 'entrevistas', 'lima'],
        rating: 9.0,
        totalEpisodes: 36,
        totalSeasons: 3,
        isNew: true,
        isFeatured: false,
      ),
      _program(
        id: 'prog_hh_invitados',
        title: 'HH con Invitados',
        description: 'Los mejores comediantes del Perú y Latinoamérica pasan por nuestro set a decir sus peores chistes.',
        thumbnail: 'https://picsum.photos/seed/hh4/400/600',
        banner: 'https://picsum.photos/seed/hh4b/1280/720',
        category: 'Stand-Up',
        tags: ['stand-up', 'comediantes', 'latinoamerica'],
        rating: 8.5,
        totalEpisodes: 18,
        totalSeasons: 2,
        isNew: false,
        isFeatured: false,
      ),
      _program(
        id: 'prog_hh_noche',
        title: 'Hablando Huevadas Noche',
        description: 'La versión nocturna más atrevida del programa. Para mayores de 18. Mucho más picante.',
        thumbnail: 'https://picsum.photos/seed/hh5/400/600',
        banner: 'https://picsum.photos/seed/hh5b/1280/720',
        category: 'Comedia Adulta',
        tags: ['noche', 'adultos', 'picante'],
        rating: 8.9,
        totalEpisodes: 12,
        totalSeasons: 1,
        isNew: true,
        isFeatured: true,
      ),
      _program(
        id: 'prog_hh_politica',
        title: 'Política Huevona',
        description: 'Analizamos la política peruana de la manera más absurda posible. Porque si no te ríes, lloras.',
        thumbnail: 'https://picsum.photos/seed/hh6/400/600',
        banner: 'https://picsum.photos/seed/hh6b/1280/720',
        category: 'Sátira Política',
        tags: ['politica', 'satira', 'peru'],
        rating: 9.1,
        totalEpisodes: 30,
        totalSeasons: 3,
        isNew: false,
        isFeatured: false,
      ),
    ];
  }

  List<SeasonHiveModel> _buildSeasons(List<ProgramHiveModel> programs) {
    final seasons = <SeasonHiveModel>[];
    for (final program in programs) {
      for (int s = 1; s <= program.totalSeasons; s++) {
        final id = '${program.id}_s$s';
        final model = SeasonHiveModel()
          ..id = id
          ..programId = program.id
          ..seasonNumber = s
          ..title = 'Temporada $s'
          ..description = 'La temporada $s de ${program.title} con todos sus mejores momentos.'
          ..thumbnailUrl = 'https://picsum.photos/seed/${program.id}_s$s/400/225'
          ..totalEpisodes = (program.totalEpisodes / program.totalSeasons).ceil()
          ..releaseDate = DateTime(2021 + s, 1, 15);
        seasons.add(model);
      }
    }
    return seasons;
  }

  List<EpisodeHiveModel> _buildEpisodes(List<SeasonHiveModel> seasons) {
    final episodes = <EpisodeHiveModel>[];
    final episodeTitles = [
      'El inicio de todo', 'La verdad duele', 'Cuando todo salió mal',
      'El invitado sorpresa', 'Sin filtros', 'La revancha',
      'Episodio de oro', 'Lo mejor de lo mejor', 'El final épico',
      'Especial de Navidad', 'La bomba', 'Esto no se puede creer',
    ];

    for (final season in seasons) {
      for (int ep = 1; ep <= season.totalEpisodes; ep++) {
        final id = '${season.id}_ep$ep';
        final titleIdx = (ep - 1) % episodeTitles.length;
        final model = EpisodeHiveModel()
          ..id = id
          ..seasonId = season.id
          ..programId = season.programId
          ..episodeNumber = ep
          ..title = 'Ep. $ep: ${episodeTitles[titleIdx]}'
          ..description = 'Un episodio brutal lleno de humor, caos y momentos que no olvidarás. Temporada ${season.seasonNumber}, episodio $ep.'
          ..thumbnailUrl = 'https://picsum.photos/seed/$id/640/360'
          ..bunnyVideoId = 'demo-video-id-$id'
          ..bunnyLibraryId = '12345'
          ..durationSeconds = 1800 + (ep * 120)
          ..watchProgressSeconds = ep == 1 ? 450 : null
          ..isWatched = false
          ..publishedAt = DateTime(2021, 1, 1).add(Duration(days: ep * 7));
        episodes.add(model);
      }
    }
    return episodes;
  }

  ProgramHiveModel _program({
    required String id,
    required String title,
    required String description,
    required String thumbnail,
    required String banner,
    required String category,
    required List<String> tags,
    required double rating,
    required int totalEpisodes,
    required int totalSeasons,
    required bool isNew,
    required bool isFeatured,
  }) =>
      ProgramHiveModel()
        ..id = id
        ..title = title
        ..description = description
        ..thumbnailUrl = thumbnail
        ..bannerUrl = banner
        ..category = category
        ..tags = tags
        ..rating = rating
        ..totalEpisodes = totalEpisodes
        ..totalSeasons = totalSeasons
        ..isNew = isNew
        ..isFeatured = isFeatured
        ..createdAt = DateTime(2021, 1, 1)
        ..updatedAt = DateTime.now();
}