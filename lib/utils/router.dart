// lib/utils/router.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../screens/student/splash_screen.dart';
import '../screens/student/onboarding_screen.dart';
import '../screens/student/login_screen.dart';
import '../screens/student/consent_screen.dart';
import '../screens/student/setup_screen.dart';
import '../screens/student/main_shell.dart';
import '../screens/student/ar_screen.dart';
import '../screens/student/quiz_screen.dart';
import '../screens/student/profile_screen.dart';
import '../viewmodels/app_viewmodel.dart';
import '../services/local_database.dart';

abstract final class Routes {
  static const splash    = '/';
  static const onboarding = '/onboarding';
  static const login     = '/login';
  static const consent   = '/consent';
  static const setup     = '/setup';
  static const home      = '/home';
  static const ar        = '/ar';
  static const quiz      = '/quiz';
  static const settings  = '/settings';

  static String fromAuthStatus(AuthStatus s) => switch (s) {
    AuthStatus.loggedOut      => login,
    AuthStatus.needsConsent   => consent,
    AuthStatus.needsSetup     => setup,
    AuthStatus.ready          => home,
    AuthStatus.unknown        => splash,
  };
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: Routes.splash,
    refreshListenable: _AuthListenable(ref),
    redirect: (context, state) {
      final path   = state.matchedLocation;
      final auth   = ref.read(appProvider).authStatus;
      final onboarded = LocalDatabase.hasOnboarded;

      if (path == Routes.splash) return null;

      if (!onboarded && path != Routes.onboarding) return Routes.onboarding;

      switch (auth) {
        case AuthStatus.unknown:
          return null;
        case AuthStatus.loggedOut:
          if (path == Routes.login || path == Routes.onboarding) return null;
          return Routes.login;
        case AuthStatus.needsConsent:
          if (path == Routes.consent) return null;
          return Routes.consent;
        case AuthStatus.needsSetup:
          if (path == Routes.setup) return null;
          return Routes.setup;
        case AuthStatus.ready:
          if (path == Routes.login || path == Routes.consent ||
              path == Routes.setup || path == Routes.onboarding) {
            return Routes.home;
          }
          return null;
      }
    },
    routes: [
      GoRoute(path: Routes.splash,     builder: (_, __) => const SplashScreen()),
      GoRoute(path: Routes.onboarding, builder: (_, __) => const OnboardingScreen()),
      GoRoute(path: Routes.login,      builder: (_, __) => const LoginScreen()),
      GoRoute(path: Routes.consent,    builder: (_, __) => const ConsentScreen()),
      GoRoute(path: Routes.setup,      builder: (_, __) => const SetupScreen()),
      GoRoute(path: Routes.home,       builder: (_, __) => const MainShell()),
      GoRoute(path: Routes.ar,
        builder: (_, state) => ArScreen(
          topicName: state.uri.queryParameters['topic'] ?? 'AR Experience')),
      GoRoute(path: Routes.quiz,
        builder: (_, state) => QuizScreen(
          topicId: state.uri.queryParameters['id'] ?? 't1')),
      GoRoute(path: Routes.settings,   builder: (_, __) => const SettingsScreen()),
    ],
    errorBuilder: (_, state) => Scaffold(
      backgroundColor: MC.bgDeep,
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('🔍', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          Text('Page not found', style: MT.display(18, weight: FontWeight.w700)),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => state.error,
            child: Text('← Go Home', style: MT.body(14, color: MC.saffron)),
          ),
        ]),
      ),
    ),
  );
});

class _AuthListenable extends ChangeNotifier {
  _AuthListenable(Ref ref) {
    ref.listen(appProvider, (_, __) => notifyListeners());
  }
}
