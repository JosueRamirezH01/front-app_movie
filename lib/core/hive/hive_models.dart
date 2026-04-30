import 'package:hive/hive.dart';
import '../domain/entities.dart';

part 'hive_models.g.dart';

// ─── PROGRAM HIVE MODEL ────────────────────────────────────────────────────────
@HiveType(typeId: 0)
class ProgramHiveModel extends HiveObject {
  @HiveField(0) late String id;
  @HiveField(1) late String title;
  @HiveField(2) late String description;
  @HiveField(3) late String thumbnailUrl;
  @HiveField(4) late String bannerUrl;
  @HiveField(5) late String category;
  @HiveField(6) late List<String> tags;
  @HiveField(7) late double rating;
  @HiveField(8) late int totalEpisodes;
  @HiveField(9) late int totalSeasons;
  @HiveField(10) late bool isNew;
  @HiveField(11) late bool isFeatured;
  @HiveField(12) late DateTime createdAt;
  @HiveField(13) late DateTime updatedAt;

  ProgramHiveModel();

  factory ProgramHiveModel.fromEntity(Program p) => ProgramHiveModel()
    ..id = p.id
    ..title = p.title
    ..description = p.description
    ..thumbnailUrl = p.thumbnailUrl
    ..bannerUrl = p.bannerUrl
    ..category = p.category
    ..tags = p.tags
    ..rating = p.rating
    ..totalEpisodes = p.totalEpisodes
    ..totalSeasons = p.totalSeasons
    ..isNew = p.isNew
    ..isFeatured = p.isFeatured
    ..createdAt = p.createdAt
    ..updatedAt = p.updatedAt;

  Program toEntity() => Program(
    id: id, title: title, description: description,
    thumbnailUrl: thumbnailUrl, bannerUrl: bannerUrl,
    category: category, tags: tags, rating: rating,
    totalEpisodes: totalEpisodes, totalSeasons: totalSeasons,
    isNew: isNew, isFeatured: isFeatured,
    createdAt: createdAt, updatedAt: updatedAt,
  );
}

// ─── SEASON HIVE MODEL ─────────────────────────────────────────────────────────
@HiveType(typeId: 1)
class SeasonHiveModel extends HiveObject {
  @HiveField(0) late String id;
  @HiveField(1) late String programId;
  @HiveField(2) late int seasonNumber;
  @HiveField(3) late String title;
  @HiveField(4) late String description;
  @HiveField(5) late String thumbnailUrl;
  @HiveField(6) late int totalEpisodes;
  @HiveField(7) late DateTime releaseDate;

  SeasonHiveModel();

  factory SeasonHiveModel.fromEntity(Season s) => SeasonHiveModel()
    ..id = s.id
    ..programId = s.programId
    ..seasonNumber = s.seasonNumber
    ..title = s.title
    ..description = s.description
    ..thumbnailUrl = s.thumbnailUrl
    ..totalEpisodes = s.totalEpisodes
    ..releaseDate = s.releaseDate;

  Season toEntity() => Season(
    id: id, programId: programId, seasonNumber: seasonNumber,
    title: title, description: description, thumbnailUrl: thumbnailUrl,
    totalEpisodes: totalEpisodes, releaseDate: releaseDate,
  );
}

// ─── EPISODE HIVE MODEL ────────────────────────────────────────────────────────
@HiveType(typeId: 2)
class EpisodeHiveModel extends HiveObject {
  @HiveField(0) late String id;
  @HiveField(1) late String seasonId;
  @HiveField(2) late String programId;
  @HiveField(3) late int episodeNumber;
  @HiveField(4) late String title;
  @HiveField(5) late String description;
  @HiveField(6) late String thumbnailUrl;
  @HiveField(7) late String bunnyVideoId;
  @HiveField(8) late String bunnyLibraryId;
  @HiveField(9) late int durationSeconds;
  @HiveField(10) late int? watchProgressSeconds;
  @HiveField(11) late bool isWatched;
  @HiveField(12) late DateTime publishedAt;

  EpisodeHiveModel();

  factory EpisodeHiveModel.fromEntity(Episode e) => EpisodeHiveModel()
    ..id = e.id
    ..seasonId = e.seasonId
    ..programId = e.programId
    ..episodeNumber = e.episodeNumber
    ..title = e.title
    ..description = e.description
    ..thumbnailUrl = e.thumbnailUrl
    ..bunnyVideoId = e.bunnyVideoId
    ..bunnyLibraryId = e.bunnyLibraryId
    ..durationSeconds = e.duration.inSeconds
    ..watchProgressSeconds = e.watchProgress?.inSeconds
    ..isWatched = e.isWatched
    ..publishedAt = e.publishedAt;

  Episode toEntity() => Episode(
    id: id, seasonId: seasonId, programId: programId,
    episodeNumber: episodeNumber, title: title, description: description,
    thumbnailUrl: thumbnailUrl, bunnyVideoId: bunnyVideoId,
    bunnyLibraryId: bunnyLibraryId,
    duration: Duration(seconds: durationSeconds),
    watchProgress: watchProgressSeconds != null
        ? Duration(seconds: watchProgressSeconds!)
        : null,
    isWatched: isWatched, publishedAt: publishedAt,
  );
}