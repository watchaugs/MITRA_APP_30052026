// lib/viewmodels/app_viewmodel.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_config.dart';
import '../models/student_models.dart';
import '../services/api_service.dart';
import '../services/local_database.dart';

enum AuthStatus { unknown, loggedOut, needsConsent, needsSetup, ready }

class AppState {
  final AuthStatus     authStatus;
  final AppConfig?     config;
  final StudentProfile? profile;
  final bool           isOffline;
  final String         language;
  final bool           isDark;

  AppState({
    this.authStatus = AuthStatus.unknown,
    this.config,
    this.profile,
    this.isOffline = false,
    this.language  = 'en',
    this.isDark    = true,
  });

  AppState copyWith({
    AuthStatus?     authStatus,
    AppConfig?      config,
    StudentProfile? profile,
    bool?           isOffline,
    String?         language,
    bool?           isDark,
  }) => AppState(
    authStatus: authStatus ?? this.authStatus,
    config:     config     ?? this.config,
    profile:    profile    ?? this.profile,
    isOffline:  isOffline  ?? this.isOffline,
    language:   language   ?? this.language,
    isDark:     isDark     ?? this.isDark,
  );
}

class AppNotifier extends Notifier<AppState> {
  @override
  AppState build() {
    Future.microtask(() => _init());
    return AppState(
      language: LocalDatabase.selectedLang,
      isDark:   LocalDatabase.isDarkTheme,
    );
  }

  Future<void> _init() async {
    final profileData = LocalDatabase.loadProfile();
    if (profileData != null) {
      final profile = StudentProfile.fromJson(profileData);
      state = state.copyWith(
        profile:    profile,
        authStatus: AuthStatus.ready,
      );
      _refreshFromNetwork();
    } else {
      final hasToken = await TokenStore.getAccess() != null;
      state = state.copyWith(
        authStatus: hasToken ? AuthStatus.needsSetup : AuthStatus.loggedOut,
      );
    }
  }

  Future<void> _refreshFromNetwork() async {
    final api       = ref.read(apiServiceProvider);
    final stateCode = LocalDatabase.stateCode;

    final cfgResult = await api.getAppConfig(stateCode);
    if (cfgResult is ApiOk<AppConfig>) {
      await LocalDatabase.saveAppConfig(cfgResult.data.toJson());
      state = state.copyWith(config: cfgResult.data);
    }

    final profileResult = await api.getProfile();
    if (profileResult is ApiOk<StudentProfile>) {
      state = state.copyWith(profile: profileResult.data);
    } else if (profileResult is ApiErr) {
      debugPrint('Profile error: ${(profileResult as ApiErr).msg}');
    }
  }

  // ── Auth ──────────────────────────────────────────────────
  Future<String?> requestOtp(String phone, String role) async {
    final result = await ref.read(apiServiceProvider).requestOtp(phone, role);
    if (result is ApiErr) return (result as ApiErr).msg;
    return null;
  }

  Future<String?> verifyOtp({
    required String phone,
    required String otp,
    required String role,
  }) async {
    final result = await ref.read(apiServiceProvider).verifyOtp(
      phone: phone, otp: otp, role: role,
    );
    if (result is ApiErr) return (result as ApiErr).msg;
    final data       = (result as ApiOk<Map<String, dynamic>>).data;
    final isNewUser  = data['is_new_user'] as bool? ?? true;
    final needConsent = state.config?.features.isParentalConsentRequired ?? true;
    state = state.copyWith(
      authStatus: isNewUser
          ? (needConsent ? AuthStatus.needsConsent : AuthStatus.needsSetup)
          : AuthStatus.ready,
    );
    return null;
  }

  // ── Consent ───────────────────────────────────────────────
  Future<void> submitConsent() async {
    await ref.read(apiServiceProvider).submitConsent(true);
    await LocalDatabase.setConsented(true);
    state = state.copyWith(authStatus: AuthStatus.needsSetup);
  }

  Future<String?> submitParentalConsent(String parentPhone, String otp) async {
    final result = await ref.read(apiServiceProvider)
        .submitParentalConsent(parentPhone: parentPhone, otp: otp);
    if (result is ApiErr) return (result as ApiErr).msg;
    state = state.copyWith(authStatus: AuthStatus.needsSetup);
    return null;
  }

  // ── Profile Setup ─────────────────────────────────────────
  Future<String?> setupProfile({
    required String name,
    required String avatar,
    required int    classGrade,
    required String stateCode,
    required String schoolName,
    String? district,
  }) async {
    final result = await ref.read(apiServiceProvider).setupProfile(
      name: name, avatar: avatar, classGrade: classGrade,
      stateCode: stateCode, schoolName: schoolName, district: district,
    );
    if (result is ApiErr) return (result as ApiErr).msg;
    final profile = (result as ApiOk<StudentProfile>).data;
    await LocalDatabase.saveProfile(profile.toJson());
    state = state.copyWith(profile: profile, authStatus: AuthStatus.ready);
    return null;
  }

  Future<String?> selectState(String stateCode) async {
    // In production, update state in backend if profile exists
    // For now, we just update local state code and refresh config
    await LocalDatabase.setStateCode(stateCode);
    _refreshFromNetwork();
    return null;
  }

  // ── Settings ──────────────────────────────────────────────
  void toggleTheme() {
    final v = !state.isDark;
    LocalDatabase.setDarkTheme(v);
    state = state.copyWith(isDark: v);
  }

  void setLanguage(String l) {
    LocalDatabase.setLanguage(l);
    state = state.copyWith(language: l);
  }

  Future<void> logout() async {
    await TokenStore.clear();
    await LocalDatabase.clear();
    state = AppState(authStatus: AuthStatus.loggedOut);
  }
}

final appProvider = NotifierProvider<AppNotifier, AppState>(AppNotifier.new);

final studentProfileProvider = Provider<StudentProfile?>((ref) => ref.watch(appProvider).profile);
final appConfigProvider      = Provider<AppConfig?>((ref) => ref.watch(appProvider).config);
final featureFlagsProvider   = Provider<FeatureFlags>((ref) => ref.watch(appConfigProvider)?.features ?? FeatureFlags());
