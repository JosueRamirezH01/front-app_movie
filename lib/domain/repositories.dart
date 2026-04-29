import 'package:dartz/dartz.dart';
import '../core/failures.dart';
import 'entities.dart';

abstract class ProgramRepository {
  Future<Either<Failure, List<Program>>> getPrograms();
  Future<Either<Failure, Program>> getProgramById(String id);
  Future<Either<Failure, List<Program>>> getFeaturedPrograms();
  Future<Either<Failure, List<Program>>> searchPrograms(String query);
}

abstract class SeasonRepository {
  Future<Either<Failure, List<Season>>> getSeasonsByProgram(String programId);
  Future<Either<Failure, Season>> getSeasonById(String id);
}

abstract class EpisodeRepository {
  Future<Either<Failure, List<Episode>>> getEpisodesBySeason(String seasonId);
  Future<Either<Failure, Episode>> getEpisodeById(String id);
  Future<Either<Failure, void>> updateWatchProgress(
      String episodeId,
      Duration progress,
      );
  Future<Either<Failure, List<Episode>>> getContinueWatching();
}