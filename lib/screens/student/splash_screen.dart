// lib/screens/student/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme.dart';
import '../../viewmodels/app_viewmodel.dart';
import '../../utils/router.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ring;

  @override
  void initState() {
    super.initState();
    _ring = AnimationController(vsync: this, duration: const Duration(seconds: 3))
      ..repeat();
    _navigate();
  }

  @override
  void dispose() {
    _ring.dispose();
    super.dispose();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    final status = ref.read(appProvider).authStatus;
    if (status == AuthStatus.unknown) {
      await Future.delayed(const Duration(milliseconds: 500));
    }
    final finalStatus = ref.read(appProvider).authStatus;
    context.go(Routes.fromAuthStatus(finalStatus));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MC.bgDeep,
      body: Stack(
        children: [
          // Mandala rings
          Center(
            child: AnimatedBuilder(
              animation: _ring,
              builder: (_, __) => Stack(alignment: Alignment.center, children: [
                _Ring(320, 0.0, _ring.value),
                _Ring(260, 0.5, _ring.value),
                _Ring(200, 1.0, _ring.value),
              ]),
            ),
          ),

          // Hero gradient background
          Container(
            decoration: const BoxDecoration(gradient: MG.hero),
            child: Container(color: MC.bgDeep.withValues(alpha: 0.6)),
          ),

          // Dot-grid pattern
          Positioned.fill(child: CustomPaint(painter: _DotGridPainter())),

          // Logo
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(
                    gradient:     MG.saffron,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color:      MC.saffron.withValues(alpha: 0.5),
                        blurRadius: 32, offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text('🎓', style: TextStyle(fontSize: 40)),
                  ),
                )
                    .animate()
                    .scale(duration: 600.ms, curve: Curves.elasticOut)
                    .fadeIn(),

                const SizedBox(height: 16),

                RichText(
                  text: TextSpan(
                    style: MT.display(34, weight: FontWeight.w800),
                    children: const [
                      TextSpan(text: 'MIT', style: TextStyle(color: MC.textPrimary)),
                      TextSpan(text: 'RA', style: TextStyle(color: MC.saffron)),
                    ],
                  ),
                ).animate(delay: 300.ms).fadeIn().slideY(begin: 0.3),

                const SizedBox(height: 6),
                Text('AR Learning Platform',
                  style: MT.body(13, color: MC.textSecondary))
                    .animate(delay: 400.ms).fadeIn(),

                const SizedBox(height: 48),

                // Loader dots
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (i) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 6, height: 6,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: MC.saffron),
                  ).animate(delay: (i * 200).ms, onPlay: (c) => c.repeat(reverse: true))
                    .scaleXY(begin: 0.4, end: 1.0, duration: 600.ms)),
                ),

                const SizedBox(height: 24),
                Text('Ministry of Education, Govt. of India',
                  style: MT.body(11, color: MC.textMuted))
                    .animate(delay: 600.ms).fadeIn(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Ring extends StatelessWidget {
  const _Ring(this.size, this.phaseOffset, this.progress);
  final double size, phaseOffset, progress;

  @override
  Widget build(BuildContext context) {
    final opacity = 0.05 + 0.04 * (1 - ((progress + phaseOffset) % 1.0));
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        shape:  BoxShape.circle,
        border: Border.all(color: MC.saffron.withValues(alpha: opacity), width: 1),
      ),
    );
  }
}

class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = MC.indigoLt.withValues(alpha: 0.04);
    for (double x = 0; x < size.width; x += 20) {
      for (double y = 0; y < size.height; y += 20) {
        canvas.drawCircle(Offset(x, y), 1, p);
      }
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
