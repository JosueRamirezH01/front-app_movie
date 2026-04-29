import 'package:equatable/equatable.dart';

// ─── PROGRAM ENTITY ────────────────────────────────────────────────────────────
class Program extends Equatable {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String bannerUrl;
  final String category;
  final List<String> tags;
  final double rating;
  final int totalEpisodes;
  final int totalSeasons;
  final bool isNew;
  final bool isFeatured;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Program({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.bannerUrl,
    required this.category,
    required this.tags,
    required this.rating,
    required this.totalEpisodes,
    required this.totalSeasons,
    required this.isNew,
    required this.isFeatured,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id];
}

// ─── SEASON ENTITY ─────────────────────────────────────────────────────────────
class Season extends Equatable {
  final String id;
  final String programId;
  final int seasonNumber;
  final String title;
  final String description;
  final String thumbnailUrl;
  final int totalEpisodes;
  final DateTime releaseDate;

  const Season({
    required this.id,
    required this.programId,
    required this.seasonNumber,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.totalEpisodes,
    required this.releaseDate,
  });

  @override
  List<Object?> get props => [id];
}

// ─── EPISODE ENTITY ────────────────────────────────────────────────────────────
class Episode extends Equatable {
  final String id;
  final String seasonId;
  final String programId;
  final int episodeNumber;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String bunnyVideoId;
  final String bunnyLibraryId;
  final Duration duration;
  final Duration? watchProgress;
  final bool isWatched;
  final DateTime publishedAt;

  const Episode({
    required this.id,
    required this.seasonId,
    required this.programId,
    required this.episodeNumber,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.bunnyVideoId,
    required this.bunnyLibraryId,
    required this.duration,
    this.watchProgress,
    required this.isWatched,
    required this.publishedAt,
  });

  String get bunnyStreamUrl =>
      'https://iframe.mediadelivery.net/embed/$bunnyLibraryId/$bunnyVideoId';

  String get bunnyDirectUrl =>
      'https://vz-${bunnyLibraryId}.b-cdn.net/$bunnyVideoId/playlist.m3u8';

  double get progressPercentage {
    if (watchProgress == null || duration.inSeconds == 0) return 0;
    return watchProgress!.inSeconds / duration.inSeconds;
  }

  @override
  List<Object?> get props => [id];
}