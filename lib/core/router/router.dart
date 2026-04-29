import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/home.dart';
import '../../presentation/player.dart';
import '../../presentation/program_detail.dart';
import '../../presentation/search.dart';
import '../../presentation/season_detail.dart';
import '../../util/navigator.dart';

class AppRouter {
  static const String home = '/';
  static const String search = '/search';
  static const String program = '/program/:programId';
  static const String season = '/program/:programId/season/:seasonId';
  static const String player = '/player/:episodeId';

  static String programPath(String id) => '/program/$id';
  static String seasonPath(String programId, String seasonId) =>
      '/program/$programId/season/$seasonId';
  static String playerPath(String episodeId) => '/player/$episodeId';

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: home,
    debugLogDiagnostics: false,
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          GoRoute(
            path: home,
            pageBuilder: (context, state) => _buildPage(
              state, const HomePage(), key: 'home',
            ),
          ),
          GoRoute(
            path: search,
            pageBuilder: (context, state) => _buildPage(
              state, const SearchPage(), key: 'search',
            ),
          ),
        ],
      ),
      GoRoute(
        path: program,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => _buildSlidePage(
          ProgramDetailPage(
            programId: state.pathParameters['programId']!,
          ),
        ),
      ),
      GoRoute(
        path: season,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => _buildSlidePage(
          SeasonDetailPage(
            programId: state.pathParameters['programId']!,
            seasonId: state.pathParameters['seasonId']!,
          ),
        ),
      ),
      GoRoute(
        path: player,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: PlayerPage(episodeId: state.pathParameters['episodeId']!),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
    ],
  );

  static CustomTransitionPage _buildPage(
      GoRouterState state,
      Widget child, {
        required String key,
      }) =>
      CustomTransitionPage(
        key: ValueKey(key),
        child: child,
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondary, child) =>
            FadeTransition(opacity: animation, child: child),
      );

  static CustomTransitionPage _buildSlidePage(Widget child) =>
      CustomTransitionPage(
        child: child,
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (context, animation, secondary, child) {
          final tween = Tween(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeOutCubic));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );
}