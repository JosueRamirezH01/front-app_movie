import 'package:dartz/dartz.dart';
import '../core/failures.dart';
import '../domain/entities.dart';
import '../domain/repositories.dart';
import '../hive/hive_models.dart';
import '../hive/local_datasource.dart';

// ─── PROGRAM REPOSITORY IMPL ───────────────────────────────────────────────────
class ProgramRepositoryImpl implements ProgramRepository {
  final HiveLocalDataSource _local;
  ProgramRepositoryImpl(this._local);

  @override
  Future<Either<Failure, List<Program>>> getPrograms() async {
    try {
      final models = await _local.getPrograms();
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Program>> getProgramById(String id) async {
    try {
      final model = await _local.getProgramById(id);
      if (model == null) return const Left(NotFoundFailure());
      return Right(model.toEntity());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Program>>> getFeaturedPrograms() async {
    try {
      final models = await _local.getPrograms();
      final featured = models.where((m) => m.isFeatured).map((m) => m.toEntity()).toList();
      return Right(featured);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Program>>> searchPrograms(String query) async {
    try {
      final models = await _local.getPrograms();
      final q = query.toLowerCase();
      final results = models
          .where((m) =>
      m.title.toLowerCase().contains(q) ||
          m.description.toLowerCase().contains(q) ||
          m.tags.any((t) => t.toLowerCase().contains(q)))
          .map((m) => m.toEntity())
          .toList();
      return Right(results);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}

// ─── SEASON REPOSITORY IMPL ────────────────────────────────────────────────────
class SeasonRepositoryImpl implements SeasonRepository {
  final HiveLocalDataSource _local;
  SeasonRepositoryImpl(this._local);

  @override
  Future<Either<Failure, List<Season>>> getSeasonsByProgram(String programId) async {
    try {
      final models = await _local.getSeasonsByProgram(programId);
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Season>> getSeasonById(String id) async {
    try {
      final models = await _local.getSeasonsByProgram('');
      final model = models.cast<SeasonHiveModel?>().firstWhere(
            (m) => m?.id == id, orElse: () => null,
      );
      if (model == null) return const Left(NotFoundFailure());
      return Right(model.toEntity());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}

// ─── EPISODE REPOSITORY IMPL ───────────────────────────────────────────────────
class EpisodeRepositoryImpl implements EpisodeRepository {
  final HiveLocalDataSource _local;
  EpisodeRepositoryImpl(this._local);

  @override
  Future<Either<Failure, List<Episode>>> getEpisodesBySeason(String seasonId) async {
    try {
      final models = await _local.getEpisodesBySeason(seasonId);
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Episode>> getEpisodeById(String id) async {
    try {
      // Search across all episodes
      final box = await Future.value(_local);
      // For simplicity, we'd need to expose this in the datasource
      // This is a stub - in real impl you'd get from hive box directly
      return const Left(NotFoundFailure('Implementar búsqueda directa por ID'));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateWatchProgress(
      String episodeId,
      Duration progress,
      ) async {
    try {
      await _local.updateEpisodeProgress(episodeId, progress.inSeconds);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Episode>>> getContinueWatching() async {
    try {
      final models = await _local.getContinueWatching();
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}