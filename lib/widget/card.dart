import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_theme.dart';
import '../domain/entities.dart';

// ─── PROGRAM CARD (Vertical Poster) ───────────────────────────────────────────
class ProgramCard extends StatelessWidget {
  final Program program;
  final VoidCallback onTap;
  final double width;

  const ProgramCard({
    super.key,
    required this.program,
    required this.onTap,
    this.width = 130,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster
            Expanded(
              flex: 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: AspectRatio(
                  aspectRatio: 2 / 3,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: program.thumbnailUrl,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => _shimmer(),
                        errorWidget: (_, __, ___) => _placeholder(),
                      ),
                      // Gradient overlay
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Color(0x80000000)],
                            stops: [0.5, 1.0],
                          ),
                        ),
                      ),
                      // Badges
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Row(
                          children: [
                            if (program.isNew)
                              _badge('NUEVO', AppTheme.primary),
                          ],
                        ),
                      ),
                      // Rating
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: _ratingBadge(program.rating),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                program.title,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 2),
            Expanded(
              child: Text(
                program.category,
                style: const TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge(String text, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 9,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.5,
      ),
    ),
  );

  Widget _ratingBadge(double rating) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
    decoration: BoxDecoration(
      color: Colors.black54,
      borderRadius: BorderRadius.circular(4),
      border: Border.all(color: AppTheme.accent.withOpacity(0.6)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.star_rounded, size: 10, color: AppTheme.accent),
        const SizedBox(width: 3),
        Text(
          rating.toStringAsFixed(1),
          style: const TextStyle(
            color: AppTheme.accent,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );

  Widget _shimmer() => Shimmer.fromColors(
    baseColor: AppTheme.surfaceVariant,
    highlightColor: AppTheme.cardBg,
    child: Container(color: AppTheme.surfaceVariant),
  );

  Widget _placeholder() => Container(
    color: AppTheme.surfaceVariant,
    child: const Icon(Icons.movie_rounded, color: AppTheme.textMuted, size: 40),
  );
}

// ─── EPISODE CARD ─────────────────────────────────────────────────────────────
class EpisodeCard extends StatelessWidget {
  final Episode episode;
  final VoidCallback onTap;

  const EpisodeCard({
    super.key,
    required this.episode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm / 2,
        ),
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.divider, width: 0.5),
        ),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(12),
              ),
              child: SizedBox(
                width: 140,
                height: 90,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: episode.thumbnailUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Shimmer.fromColors(
                        baseColor: AppTheme.surfaceVariant,
                        highlightColor: AppTheme.cardBg,
                        child: Container(color: AppTheme.surfaceVariant),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        color: AppTheme.surfaceVariant,
                        child: const Icon(Icons.play_circle_outline_rounded,
                            color: AppTheme.textMuted),
                      ),
                    ),
                    // Play button overlay
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                    // Progress bar
                    if (episode.progressPercentage > 0)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: LinearProgressIndicator(
                          value: episode.progressPercentage,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          valueColor: const AlwaysStoppedAnimation(AppTheme.primary),
                          minHeight: 3,
                        ),
                      ),
                    // Watched indicator
                    if (episode.isWatched)
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: AppTheme.success,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 10,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ep. ${episode.episodeNumber}',
                      style: const TextStyle(
                        color: AppTheme.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      episode.title,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.schedule_rounded,
                            size: 11, color: AppTheme.textMuted),
                        const SizedBox(width: 4),
                        Text(
                          _formatDuration(episode.duration),
                          style: const TextStyle(
                            color: AppTheme.textMuted, fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    if (h > 0) return '${h}h ${m}min';
    return '${m} min';
  }
}

// ─── FEATURED BANNER CARD ─────────────────────────────────────────────────────
class FeaturedBannerCard extends StatelessWidget {
  final Program program;
  final VoidCallback onTap;
  final VoidCallback onInfo;

  const FeaturedBannerCard({
    super.key,
    required this.program,
    required this.onTap,
    required this.onInfo,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onInfo,
      child: SizedBox(
        height: 500,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Banner image
            CachedNetworkImage(
              imageUrl: program.bannerUrl,
              fit: BoxFit.cover,
              placeholder: (_, __) => Shimmer.fromColors(
                baseColor: AppTheme.surfaceVariant,
                highlightColor: AppTheme.cardBg,
                child: Container(color: AppTheme.surfaceVariant),
              ),
              errorWidget: (_, __, ___) => Container(
                color: AppTheme.surfaceVariant,
              ),
            ),
            // Gradient bottom
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Color(0x40000000),
                    Color(0xCC000000),
                    AppTheme.background,
                  ],
                  stops: [0.0, 0.4, 0.75, 1.0],
                ),
              ),
            ),
            // Content
            Positioned(
              bottom: 24,
              left: 24,
              right: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      program.category.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    program.title,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    program.description,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 13,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: onTap,
                        icon: const Icon(Icons.play_arrow_rounded, size: 22),
                        label: const Text('Ver ahora'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: onInfo,
                        icon: const Icon(Icons.info_outline_rounded, size: 18),
                        label: const Text('Más info'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.textPrimary,
                          side: const BorderSide(
                            color: AppTheme.textSecondary,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── SEASON CHIP ─────────────────────────────────────────────────────────────
class SeasonChip extends StatelessWidget {
  final Season season;
  final bool isSelected;
  final VoidCallback onTap;

  const SeasonChip({
    super.key,
    required this.season,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppDuration.fast,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : AppTheme.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.divider,
          ),
        ),
        child: Text(
          'T${season.seasonNumber}',
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textSecondary,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// ─── SHIMMER LIST ─────────────────────────────────────────────────────────────
class ShimmerCard extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerCard({
    super.key,
    this.width = double.infinity,
    this.height = 100,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppTheme.surfaceVariant,
      highlightColor: AppTheme.cardBg,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppTheme.surfaceVariant,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}