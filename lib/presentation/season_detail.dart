import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../core/router/router.dart';
import '../provider/providers.dart';
import '../widget/card.dart';

class SeasonDetailPage extends ConsumerWidget {
  final String programId;
  final String seasonId;

  const SeasonDetailPage({
    super.key,
    required this.programId,
    required this.seasonId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programAsync = ref.watch(programByIdProvider(programId));
    final seasonsAsync = ref.watch(seasonsByProgramProvider(programId));
    final episodesAsync = ref.watch(episodesBySeasonProvider(seasonId));

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          // ── App Bar ──────────────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: AppTheme.surface,
            leading: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceVariant,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: AppTheme.textPrimary,
                  size: 20,
                ),
              ),
            ),
            title: programAsync.whenOrNull(
              data: (p) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.title,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  seasonsAsync.whenOrNull(
                    data: (seasons) {
                      final season = seasons.firstWhere(
                            (s) => s.id == seasonId,
                        orElse: () => seasons.first,
                      );
                      return Text(
                        season.title,
                        style: const TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 11,
                        ),
                      );
                    },
                  ) ?? const SizedBox.shrink(),
                ],
              ),
            ),
          ),

          // ── Season Header ─────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: seasonsAsync.when(
              loading: () => const ShimmerCard(height: 180),
              error: (_, __) => const SizedBox.shrink(),
              data: (seasons) {
                final season = seasons.firstWhere(
                      (s) => s.id == seasonId,
                  orElse: () => seasons.first,
                );
                return Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primary.withOpacity(0.15),
                        AppTheme.cardBg,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.primary.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: season.thumbnailUrl,
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => Container(
                            width: 90, height: 90,
                            color: AppTheme.surfaceVariant,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.primary.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'TEMPORADA ${season.seasonNumber}',
                                style: const TextStyle(
                                  color: AppTheme.primary,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              season.title,
                              style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${season.totalEpisodes} episodios • ${season.releaseDate.year}',
                              style: const TextStyle(
                                color: AppTheme.textMuted,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              season.description,
                              style: const TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 12,
                                height: 1.4,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // ── Episodes Title ────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 8),
              child: episodesAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
                data: (episodes) => Text(
                  '${episodes.length} Episodios',
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),

          // ── Episodes List ─────────────────────────────────────────────────
          episodesAsync.when(
            loading: () => SliverList(
              delegate: SliverChildBuilderDelegate(
                    (_, __) => const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ShimmerCard(height: 90, borderRadius: 12),
                ),
                childCount: 4,
              ),
            ),
            error: (e, _) => SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(e.toString()),
                ),
              ),
            ),
            data: (episodes) => SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, i) => EpisodeCard(
                  episode: episodes[i],
                  onTap: () =>
                      context.push(AppRouter.playerPath(episodes[i].id)),
                ),
                childCount: episodes.length,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }
}