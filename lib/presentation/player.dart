import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../../../core/theme/app_theme.dart';
import '../provider/providers.dart';

class PlayerPage extends ConsumerStatefulWidget {
  final String episodeId;
  const PlayerPage({super.key, required this.episodeId});

  @override
  ConsumerState<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends ConsumerState<PlayerPage> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _isInitializing = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _loadEpisode();
  }

  Future<void> _loadEpisode() async {
    // Find episode from Hive
    // In a real app, we'd have a direct lookup by ID
    // For now, we'll search through existing season episodes
    try {
      // Get episode from providers - search through seasons
      // This is a simplified approach; in production use a direct ID lookup
      await Future.delayed(const Duration(milliseconds: 300));

      // Using mock Bunny.net HLS URL format
      // Real URL: https://vz-{libraryId}.b-cdn.net/{videoId}/playlist.m3u8
      // For demo, we use a public test HLS stream
      const demoUrl = 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8';

      _videoController = VideoPlayerController.networkUrl(Uri.parse(demoUrl));
      await _videoController!.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: true,
        looping: false,
        aspectRatio: 16 / 9,
        allowFullScreen: true,
        allowMuting: true,
        showControls: true,
        placeholder: Container(color: Colors.black),
        autoInitialize: true,
        errorBuilder: (context, errorMessage) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline_rounded,
                  color: AppTheme.primary, size: 48),
              const SizedBox(height: 12),
              Text(
                errorMessage,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        materialProgressColors: ChewieProgressColors(
          playedColor: AppTheme.primary,
          handleColor: AppTheme.primary,
          bufferedColor: AppTheme.textMuted,
          backgroundColor: AppTheme.divider,
        ),
        routePageBuilder: (context, animation, _, provider) {
          return AnimatedBuilder(
            animation: animation,
            builder: (context, child) => Scaffold(
              backgroundColor: Colors.black,
              body: provider,
            ),
          );
        },
      );

      // Listen to position for progress saving
      _videoController!.addListener(_onVideoProgress);

      if (mounted) setState(() => _isInitializing = false);
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isInitializing = false;
        });
      }
    }
  }

  void _onVideoProgress() {
    if (_videoController == null) return;
    final position = _videoController!.value.position;
    // Throttle: save every 10 seconds
    if (position.inSeconds % 10 == 0 && position.inSeconds > 0) {
      ref.read(playerProvider.notifier).updatePosition(position);
    }
  }

  @override
  void dispose() {
    _videoController?.removeListener(_onVideoProgress);
    _videoController?.dispose();
    _chewieController?.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ── Video Area ────────────────────────────────────────────────────
          if (_isInitializing)
            const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: AppTheme.primary),
                  SizedBox(height: 16),
                  Text(
                    'Cargando video...',
                    style: TextStyle(color: Colors.white54, fontSize: 14),
                  ),
                ],
              ),
            )
          else if (_error != null)
            _ErrorView(error: _error!, onRetry: _loadEpisode)
          else if (_chewieController != null)
              Center(
                child: Chewie(controller: _chewieController!),
              ),

          // ── Top Bar ────────────────────────────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8,
                ),
                child: Row(
                  children: [
                    _ControlButton(
                      icon: Icons.arrow_back_rounded,
                      onTap: () => context.pop(),
                    ),
                    const SizedBox(width: 12),
                    // Episode info will be shown when we have it
                    const Expanded(
                      child: Text(
                        'Reproduciendo',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _ControlButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black54,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white24),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;
  const _ErrorView({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0x30E50914),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_circle_outline_rounded,
                color: AppTheme.primary,
                size: 56,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '¡Ups! No se pudo cargar',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Conecta tu biblioteca de Bunny.net\npara reproducir los videos.',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 13,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Reintentar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}