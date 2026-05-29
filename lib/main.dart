// lib/main.dart
// ════════════════════════════════════════════════════════════
// MITRA Student App — Entry Point
// ════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'theme.dart';
import 'utils/router.dart';
import 'services/local_database.dart';
import 'services/background_sync.dart';
import 'viewmodels/app_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Portrait only (can be relaxed on tablets) ──────────────
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // ── Transparent status bar ─────────────────────────────────
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor:           Colors.transparent,
    statusBarIconBrightness:  Brightness.light,
    statusBarBrightness:      Brightness.dark,
    systemNavigationBarColor: MC.bgCard,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  // ── Initialise local database (Hive) ───────────────────────
  await LocalDatabase.init();

  // ── Initialise background sync (WorkManager) ───────────────
  await BackgroundSync.init();

  runApp(
    const ProviderScope(child: MitraApp()),
  );
}

class MitraApp extends ConsumerWidget {
  const MitraApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router   = ref.watch(routerProvider);
    final appState = ref.watch(appProvider);

    // ── Dynamic theme (from AppConfig branding JSON) ──────────
    final branding = appState.config?.branding;
    final theme    = buildDynamicTheme(
      dark:          appState.isDark,
      primaryHex:    branding?.primaryColor,
      secondaryHex:  branding?.secondaryColor,
    );

    // ── Locale from stored language preference ─────────────────
    final locale = Locale(appState.language);

    return MaterialApp.router(
      title:            branding?.appName ?? 'MITRA',
      debugShowCheckedModeBanner: false,
      theme:            theme,
      routerConfig:     router,

      // ── i18n ────────────────────────────────────────────────
      locale:             locale,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), Locale('hi'), Locale('ta'),
        Locale('te'), Locale('kn'), Locale('bn'),
        Locale('mr'), Locale('gu'), Locale('pa'),
        Locale('or'), Locale('as'),
      ],

      // ── Text scale clamp (accessibility) ──────────────────
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(
            MediaQuery.of(context).textScaler.scale(1.0).clamp(0.85, 1.25),
          ),
        ),
        child: child!,
      ),
    );
  }
}