import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/theme/app_theme.dart';
import '../core/router/router.dart';
import '../provider/providers.dart';
import '../widget/card.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _featuredController = PageController();

  @override
  void dispose() {
    _featuredController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        color: AppTheme.primary,
        backgroundColor: AppTheme.surface,
        onRefresh: () async {
          ref.invalidate(programsProvider);
          ref.invalidate(featuredProgramsProvider);
          ref.invalidate(continueWatchingProvider);
        },
        child: CustomScrollView(
          slivers: [
            // ── Featured Hero ──────────────────────────────────────────────────
            SliverToBoxAdapter(child: _FeaturedSection(controller: _featuredController)),

            // ── Continue Watching ─────────────────────────────────────────────
            const SliverToBoxAdapter(child: _ContinueWatchingSection()),

            // ── All Programs ──────────────────────────────────────────────────
            const SliverToBoxAdapter(child: SizedBox(height: 8)),
            const SliverToBoxAdapter(child: _AllProgramsSection()),
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.background, Colors.transparent],
          ),
        ),
      ),
      title: Row(
        children: [
          // Logo
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'HH',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: -1,
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'Hablando\nHuevadas',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none_rounded,
              color: AppTheme.textPrimary),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}

// ─── FEATURED SECTION ─────────────────────────────────────────────────────────
class _FeaturedSection extends ConsumerWidget {
  final PageController controller;
  const _FeaturedSection({required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featuredAsync = ref.watch(featuredProgramsProvider);

    return featuredAsync.when(
      loading: () => const ShimmerCard(height: 500),
      error: (e, _) => _ErrorWidget(message: e.toString()),
      data: (programs) {
        if (programs.isEmpty) return const SizedBox.shrink();
        return Column(
          children: [
            SizedBox(
              height: 500,
              child: PageView.builder(
                controller: controller,
                itemCount: programs.length,
                itemBuilder: (context, index) {
                  final program = programs[index];
                  return FeaturedBannerCard(
                    program: program,
                    onTap: () => context.push(AppRouter.programPath(program.id)),
                    onInfo: () => context.push(AppRouter.programPath(program.id)),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            SmoothPageIndicator(
              controller: controller,
              count: programs.length,
              effect: const ExpandingDotsEffect(
                dotHeight: 4,
                dotWidth: 4,
                activeDotColor: AppTheme.primary,
                dotColor: AppTheme.textMuted,
                expansionFactor: 4,
              ),
            ),
          ],
        );
      },
    );
  }
}

// ─── CONTINUE WATCHING SECTION ────────────────────────────────────────────────
class _ContinueWatchingSection extends ConsumerWidget {
  const _ContinueWatchingSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final continueAsync = ref.watch(continueWatchingProvider);

    return continueAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (episodes) {
        if (episodes.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Continuar viendo',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 110,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: episodes.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, i) {
                  final ep = episodes[i];
                  return GestureDetector(
                    onTap: () => context.push(AppRouter.playerPath(ep.id)),
                    child: _ContinueCard(episode: ep),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ContinueCard extends StatelessWidget {
  final episode;
  const _ContinueCard({required this.episode});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.divider, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    episode.thumbnailUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppTheme.surfaceVariant,
                      child: const Icon(Icons.play_circle_outline_rounded,
                          color: AppTheme.textMuted),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: LinearProgressIndicator(
                      value: episode.progressPercentage,
                      backgroundColor: Colors.white24,
                      valueColor: const AlwaysStoppedAnimation(AppTheme.primary),
                      minHeight: 3,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              episode.title,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── ALL PROGRAMS SECTION ─────────────────────────────────────────────────────
class _AllProgramsSection extends ConsumerWidget {
  const _AllProgramsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programsAsync = ref.watch(programsProvider);

    return programsAsync.when(
      loading: () => _loadingGrid(),
      error: (e, _) => _ErrorWidget(message: e.toString()),
      data: (programs) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Todos los programas',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 16,
              childAspectRatio: 0.52,
            ),
            itemCount: programs.length,
            itemBuilder: (context, i) {
              final program = programs[i];
              return ProgramCard(
                program: program,
                onTap: () => context.push(AppRouter.programPath(program.id)),
                width: double.infinity,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _loadingGrid() => GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    padding: const EdgeInsets.symmetric(horizontal: 20),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      crossAxisSpacing: 12,
      mainAxisSpacing: 16,
      childAspectRatio: 0.65,
    ),
    itemCount: 6,
    itemBuilder: (_, __) => const ShimmerCard(borderRadius: 8),
  );
}

// ─── ERROR WIDGET ─────────────────────────────────────────────────────────────
class _ErrorWidget extends StatelessWidget {
  final String message;
  const _ErrorWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded,
                color: AppTheme.primary, size: 48),
            const SizedBox(height: 12),
            Text(
              'Algo salió mal',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(color: AppTheme.textMuted, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}