import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../core/router/router.dart';
import '../provider/providers.dart';
import '../widget/card.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider);
    final resultsAsync = ref.watch(searchResultsProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ────────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Buscar',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Search field
                  TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    onChanged: (v) => ref
                        .read(searchQueryProvider.notifier)
                        .state = v,
                    style: const TextStyle(color: AppTheme.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Busca un programa...',
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: AppTheme.textMuted,
                      ),
                      suffixIcon: query.isNotEmpty
                          ? GestureDetector(
                        onTap: () {
                          _controller.clear();
                          ref
                              .read(searchQueryProvider.notifier)
                              .state = '';
                        },
                        child: const Icon(
                          Icons.cancel_rounded,
                          color: AppTheme.textMuted,
                        ),
                      )
                          : null,
                    ),
                  ),
                ],
              ),
            ),

            // ── Results ────────────────────────────────────────────────────────
            const SizedBox(height: 20),
            Expanded(
              child: query.isEmpty
                  ? _BrowseAll()
                  : resultsAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.primary,
                  ),
                ),
                error: (e, _) => Center(
                  child: Text(e.toString()),
                ),
                data: (programs) => programs.isEmpty
                    ? _EmptyState(query: query)
                    : _ResultsGrid(programs: programs),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── BROWSE ALL (when no query) ────────────────────────────────────────────────
class _BrowseAll extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programsAsync = ref.watch(programsProvider);
    return programsAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppTheme.primary),
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (programs) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Todos los programas',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
                childAspectRatio: 0.52,
              ),
              itemCount: programs.length,
              itemBuilder: (context, i) => ProgramCard(
                program: programs[i],
                onTap: () =>
                    context.push(AppRouter.programPath(programs[i].id)),
                width: double.infinity,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── SEARCH RESULTS GRID ──────────────────────────────────────────────────────
class _ResultsGrid extends StatelessWidget {
  final programs;
  const _ResultsGrid({required this.programs});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            '${programs.length} resultado${programs.length != 1 ? 's' : ''}',
            style: const TextStyle(
              color: AppTheme.textMuted,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 16,
              childAspectRatio: 0.52,
            ),
            itemCount: programs.length,
            itemBuilder: (context, i) => ProgramCard(
              program: programs[i],
              onTap: () =>
                  context.push(AppRouter.programPath(programs[i].id)),
              width: double.infinity,
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String query;
  const _EmptyState({required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.search_off_rounded,
            color: AppTheme.textMuted,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'Sin resultados para\n"$query"',
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Intenta con otro término',
            style: TextStyle(color: AppTheme.textMuted, fontSize: 13),
          ),
        ],
      ),
    );
  }
}