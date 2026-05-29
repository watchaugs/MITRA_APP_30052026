// lib/screens/student/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../theme.dart';
import '../../utils/router.dart';
import '../../services/local_database.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _ctrl = PageController();
  int _page   = 0;

  static const _slides = [
    _Slide(
      emoji:    '🥽',
      title:    'See Your Textbook\nCome Alive',
      titleHl:  'Come Alive',
      body:     'Point your camera at any NCERT textbook page and watch 3D models, animations, and interactive AR experiences appear right in your classroom.',
      gradient: MG.saffron,
    ),
    _Slide(
      emoji:    '⭐',
      title:    'Learn, Play,\nEarn XP',
      titleHl:  'Earn XP',
      body:     'Complete topics, ace quizzes, and unlock badges. Climb the leaderboard and prove you\'re the best in your class!',
      gradient: MG.indigo,
    ),
    _Slide(
      emoji:    '🌐',
      title:    'Available in\nYour Language',
      titleHl:  'Your Language',
      body:     'MITRA speaks your language — Hindi, Tamil, Telugu, Kannada, Bengali, Gujarati, Marathi and more. Learning has never felt this close to home.',
      gradient: MG.emerald,
    ),
  ];

  Future<void> _next() async {
    if (_page < _slides.length - 1) {
      _ctrl.nextPage(
        duration: const Duration(milliseconds: 400),
        curve:    Curves.easeInOut,
      );
    } else {
      await LocalDatabase.setOnboarded(true);
      if (mounted) context.go(Routes.login);
    }
  }

  Future<void> _skip() async {
    await LocalDatabase.setOnboarded(true);
    if (mounted) context.go(Routes.login);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MC.bgDeep,
      body: SafeArea(
        child: Column(
          children: [
            // Skip
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 12, 20, 0),
                child: GestureDetector(
                  onTap: _skip,
                  child: Text('Skip intro',
                    style: MT.body(13, color: MC.textMuted)),
                ),
              ),
            ),

            // Pages
            Expanded(
              child: PageView.builder(
                controller: _ctrl,
                onPageChanged: (i) => setState(() => _page = i),
                itemCount: _slides.length,
                itemBuilder: (_, i) => _OnboardPage(slide: _slides[i]),
              ),
            ),

            // Indicator + button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: Column(
                children: [
                  SmoothPageIndicator(
                    controller: _ctrl,
                    count:      _slides.length,
                    effect: WormEffect(
                      dotColor:       MC.border,
                      activeDotColor: MC.saffron,
                      dotHeight:      7,
                      dotWidth:       7,
                    ),
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: _next,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width:    double.infinity,
                      padding:  const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        gradient:     _slides[_page].gradient,
                        borderRadius: BorderRadius.circular(MR.sm),
                        boxShadow: [
                          BoxShadow(
                            color:      MC.saffron.withValues(alpha: 0.3),
                            blurRadius: 16, offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _page == _slides.length - 1 ? 'Get Started →' : 'Next →',
                        style: MT.body(15, weight: FontWeight.w600,
                            color: Colors.white),
                      ),
                    ),
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

class _OnboardPage extends StatelessWidget {
  const _OnboardPage({required this.slide});
  final _Slide slide;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Illustration
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [MC.bgSurface, MC.bgDeep],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: MC.border),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // AR frame
                  Container(
                    width: 160, height: 160,
                    decoration: BoxDecoration(
                      border: Border.all(color: MC.saffron.withValues(alpha: 0.5), width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  Text(slide.emoji, style: const TextStyle(fontSize: 72))
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .scaleXY(begin: 0.95, end: 1.05, duration: 2.seconds),
                  // AR corners
                  ...const [
                    Alignment.topLeft, Alignment.topRight,
                    Alignment.bottomLeft, Alignment.bottomRight,
                  ].map((a) => Align(
                    alignment: a,
                    child: Container(
                      width: 20, height: 20,
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border(
                          top:    a.y < 0 ? const BorderSide(color: MC.saffron, width: 2) : BorderSide.none,
                          bottom: a.y > 0 ? const BorderSide(color: MC.saffron, width: 2) : BorderSide.none,
                          left:   a.x < 0 ? const BorderSide(color: MC.saffron, width: 2) : BorderSide.none,
                          right:  a.x > 0 ? const BorderSide(color: MC.saffron, width: 2) : BorderSide.none,
                        ),
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),
          // Title with highlight
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: MT.display(26, weight: FontWeight.w800),
              children: _buildTitle(slide.title, slide.titleHl),
            ),
          ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2),

          const SizedBox(height: 12),
          Text(slide.body,
            textAlign: TextAlign.center,
            style: MT.body(14, color: MC.textSecondary),
          ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  List<TextSpan> _buildTitle(String text, String highlight) {
    final parts = text.split(highlight);
    return [
      if (parts[0].isNotEmpty) TextSpan(text: parts[0]),
      TextSpan(
        text:  highlight,
        style: TextStyle(
          foreground: Paint()
            ..shader = MG.saffron.createShader(
                const Rect.fromLTWH(0, 0, 200, 50)),
        ),
      ),
      if (parts.length > 1 && parts[1].isNotEmpty) TextSpan(text: parts[1]),
    ];
  }
}

class _Slide {
  final String   emoji, title, titleHl, body;
  final Gradient gradient;
  const _Slide({
    required this.emoji, required this.title, required this.titleHl,
    required this.body, required this.gradient,
  });
}
