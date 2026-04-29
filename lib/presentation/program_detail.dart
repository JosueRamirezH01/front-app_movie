import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../core/router/router.dart';
import '../provider/providers.dart';
import '../widget/card.dart';

class ProgramDetailPage extends ConsumerWidget {
  final String programId;
  const ProgramDetailPage({super.key, required this.programId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programAsync = ref.watch(programByIdProvider(programId));
    final seasonsAsync = ref.watch(seasonsByProgramProvider(programId));
    final selectedSeasonIdx = ref.watch(selectedSeasonIndexProvider(programId));

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: programAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppTheme.primary),
        ),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (program) => CustomScrollView(
          slivers: [
            // ── Hero Banner ───────────────────────────────────────────────────
            SliverAppBar(
              expandedHeight: 380,
              pinned: true,
              backgroundColor: AppTheme.background,
              leading: GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.divider,
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: program.bannerUrl,
                      fit: BoxFit.cover,
                    ),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0x30000000),
                            Color(0x90000000),
                            AppTheme.background,
                          ],
                          stops: [0.0, 0.6, 1.0],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Program Info ──────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: AppTheme.primary.withOpacity(0.4),
                        ),
                      ),
                      child: Text(
                        program.category.toUpperCase(),
                        style: const TextStyle(
                          color: AppTheme.primary,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      program.title,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Stats row
                    Row(
                      children: [
                        const Icon(Icons.star_rounded,
                            size: 16, color: AppTheme.accent),
                        const SizedBox(width: 4),
                        Text(
                          program.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            color: AppTheme.accent,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.layers_rounded,
                            size: 14, color: AppTheme.textMuted),
                        const SizedBox(width: 4),
                        Text(
                          '${program.totalSeasons} Temporadas',
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.play_circle_outline_rounded,
                            size: 14, color: AppTheme.textMuted),
                        const SizedBox(width: 4),
                        Text(
                          '${program.totalEpisodes} Eps.',
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      program.description,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Tags
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: program.tags
                          .map((t) => Chip(
                        label: Text('#$t'),
                        backgroundColor: AppTheme.surfaceVariant,
                        side: BorderSide.none,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                        ),
                      ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),

            // ── Seasons Selector ──────────────────────────────────────────────
            SliverToBoxAdapter(
              child: seasonsAsync.when(
                loading: () => const SizedBox(height: 60),
                error: (_, __) => const SizedBox.shrink(),
                data: (seasons) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 28),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Temporadas',
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 40,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: seasons.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (context, i) => SeasonChip(
                          season: seasons[i],
                          isSelected: i == selectedSeasonIdx,
                          onTap: () => ref
                              .read(selectedSeasonIndexProvider(programId).notifier)
                              .state = i,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Season detail card
                    if (seasons.isNotEmpty)
                      _SeasonCard(
                        season: seasons[selectedSeasonIdx],
                        onTap: () => context.push(
                          AppRouter.seasonPath(
                            programId,
                            seasons[selectedSeasonIdx].id,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }
}

class _SeasonCard extends StatelessWidget {
  final season;
  final VoidCallback onTap;
  const _SeasonCard({required this.season, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.divider),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: season.thumbnailUrl,
                width: 100,
                height: 60,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => Container(
                  width: 100, height: 60,
                  color: AppTheme.surfaceVariant,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    season.title,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${season.totalEpisodes} episodios',
                    style: const TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
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
            const Icon(Icons.chevron_right_rounded, color: AppTheme.textMuted),
          ],
        ),
      ),
    );
  }
}