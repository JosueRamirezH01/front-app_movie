// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProgramHiveModelAdapter extends TypeAdapter<ProgramHiveModel> {
  @override
  final int typeId = 0;

  @override
  ProgramHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProgramHiveModel()
      ..id = fields[0] as String
      ..title = fields[1] as String
      ..description = fields[2] as String
      ..thumbnailUrl = fields[3] as String
      ..bannerUrl = fields[4] as String
      ..category = fields[5] as String
      ..tags = (fields[6] as List).cast<String>()
      ..rating = fields[7] as double
      ..totalEpisodes = fields[8] as int
      ..totalSeasons = fields[9] as int
      ..isNew = fields[10] as bool
      ..isFeatured = fields[11] as bool
      ..createdAt = fields[12] as DateTime
      ..updatedAt = fields[13] as DateTime;
  }

  @override
  void write(BinaryWriter writer, ProgramHiveModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.thumbnailUrl)
      ..writeByte(4)
      ..write(obj.bannerUrl)
      ..writeByte(5)
      ..write(obj.category)
      ..writeByte(6)
      ..write(obj.tags)
      ..writeByte(7)
      ..write(obj.rating)
      ..writeByte(8)
      ..write(obj.totalEpisodes)
      ..writeByte(9)
      ..write(obj.totalSeasons)
      ..writeByte(10)
      ..write(obj.isNew)
      ..writeByte(11)
      ..write(obj.isFeatured)
      ..writeByte(12)
      ..write(obj.createdAt)
      ..writeByte(13)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProgramHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SeasonHiveModelAdapter extends TypeAdapter<SeasonHiveModel> {
  @override
  final int typeId = 1;

  @override
  SeasonHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SeasonHiveModel()
      ..id = fields[0] as String
      ..programId = fields[1] as String
      ..seasonNumber = fields[2] as int
      ..title = fields[3] as String
      ..description = fields[4] as String
      ..thumbnailUrl = fields[5] as String
      ..totalEpisodes = fields[6] as int
      ..releaseDate = fields[7] as DateTime;
  }

  @override
  void write(BinaryWriter writer, SeasonHiveModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.programId)
      ..writeByte(2)
      ..write(obj.seasonNumber)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.thumbnailUrl)
      ..writeByte(6)
      ..write(obj.totalEpisodes)
      ..writeByte(7)
      ..write(obj.releaseDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SeasonHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EpisodeHiveModelAdapter extends TypeAdapter<EpisodeHiveModel> {
  @override
  final int typeId = 2;

  @override
  EpisodeHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EpisodeHiveModel()
      ..id = fields[0] as String
      ..seasonId = fields[1] as String
      ..programId = fields[2] as String
      ..episodeNumber = fields[3] as int
      ..title = fields[4] as String
      ..description = fields[5] as String
      ..thumbnailUrl = fields[6] as String
      ..bunnyVideoId = fields[7] as String
      ..bunnyLibraryId = fields[8] as String
      ..durationSeconds = fields[9] as int
      ..watchProgressSeconds = fields[10] as int?
      ..isWatched = fields[11] as bool
      ..publishedAt = fields[12] as DateTime;
  }

  @override
  void write(BinaryWriter writer, EpisodeHiveModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.seasonId)
      ..writeByte(2)
      ..write(obj.programId)
      ..writeByte(3)
      ..write(obj.episodeNumber)
      ..writeByte(4)
      ..write(obj.title)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.thumbnailUrl)
      ..writeByte(7)
      ..write(obj.bunnyVideoId)
      ..writeByte(8)
      ..write(obj.bunnyLibraryId)
      ..writeByte(9)
      ..write(obj.durationSeconds)
      ..writeByte(10)
      ..write(obj.watchProgressSeconds)
      ..writeByte(11)
      ..write(obj.isWatched)
      ..writeByte(12)
      ..write(obj.publishedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EpisodeHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
