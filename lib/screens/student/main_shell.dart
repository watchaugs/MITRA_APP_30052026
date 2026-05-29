// lib/screens/student/main_shell.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme.dart';
import '../../models/app_config.dart';
import '../../viewmodels/app_viewmodel.dart';
import '../../widgets/mitra_widgets.dart';
import 'home_screen.dart';
import 'learn_screen.dart';
import 'ar_screen.dart';
import 'learn_screen.dart'; import '../../models/app_config.dart';
import 'profile_screen.dart';

// ── Screen registry ───────────────────────────────────────────
final _screenMap = {
  'home':    HomeScreen(),
  'learn':   LearnScreen(),
  'ar':      ArScreen(),
  'ranks':   RanksScreen(),
  'profile': ProfileScreen(),
};

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _idx = 0;

  @override
  Widget build(BuildContext context) {
    final config   = ref.watch(appConfigProvider);
    final flags    = ref.watch(featureFlagsProvider);
    final isOffline = ref.watch(appProvider).isOffline;

    // Build nav items dynamically from AppConfig.navItems
    // If backend didn't send nav config, use defaults
    final rawNav = config?.navItems ?? [];
    final navItems = rawNav.isEmpty
        ? _defaultNav(flags)
        : rawNav
            .where((n) => _shouldShow(n.id, flags))
            .map((n) => (icon: n.icon, label: n.id))
            .toList();

    // Clamp index to valid range
    final safeIdx = _idx.clamp(0, navItems.length - 1);
    final activeId = navItems[safeIdx].icon == '' ? 'home' : navItems[safeIdx].label;

    // Look up the screen for the active nav item id
    final screen = _screenMap[activeId] ?? const HomeScreen();

    return Scaffold(
      backgroundColor: MC.bgDeep,
      body: Column(
        children: [
          if (isOffline) const OfflineBanner(),
          Expanded(child: IndexedStack(
            index: safeIdx,
            children: navItems.map((n) => _screenMap[n.label] ?? const HomeScreen()).toList(),
          )),
        ],
      ),
      bottomNavigationBar: MitraBottomNav(
        currentIndex: safeIdx,
        items:        navItems,
        onTap: (i) {
          HapticFeedback.selectionClick();
          setState(() => _idx = i);
        },
      ),
    );
  }

  List<({String icon, String label})> _defaultNav(FeatureFlags flags) {
    return [
      (icon: '🏠', label: 'home'),
      (icon: '📚', label: 'learn'),
      if (flags.isArEnabled)   (icon: '🥽', label: 'ar'),
      if (flags.isLeaderboardEnabled) (icon: '🏆', label: 'ranks'),
      (icon: '👤', label: 'profile'),
    ];
  }

  bool _shouldShow(String id, FeatureFlags flags) {
    return switch (id) {
      'ar'      => flags.isArEnabled,
      'ranks'   => flags.isLeaderboardEnabled,
      'booking' => flags.isRentalBookingActive,
      'video'   => flags.isExpeditionVideoActive,
      _         => true,
    };
  }
}
