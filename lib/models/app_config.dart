// lib/models/app_config.dart
// ════════════════════════════════════════════════════════════
// Server-Driven UI (SDUI) Config Model
// The /api/v1/app-config endpoint returns this JSON which
// drives the entire app's layout, features, and branding.
// ════════════════════════════════════════════════════════════

import 'package:hive/hive.dart';

part 'app_config.g.dart';

// ── Feature Toggle Map ────────────────────────────────────────
@HiveType(typeId: 0)
class FeatureFlags extends HiveObject {
  @HiveField(0) bool isArEnabled;
  @HiveField(1) bool isQuizEnabled;
  @HiveField(2) bool isLeaderboardEnabled;
  @HiveField(3) bool isAdsEnabled;
  @HiveField(4) bool isOfflineEnabled;
  @HiveField(5) bool isTeacherModeEnabled;
  @HiveField(6) bool isParentalConsentRequired;
  @HiveField(7) bool isBilingualEnabled;
  @HiveField(8) bool isRentalBookingActive;   // future feature
  @HiveField(9) bool isExpeditionVideoActive; // future feature

  FeatureFlags({
    this.isArEnabled              = true,
    this.isQuizEnabled            = true,
    this.isLeaderboardEnabled     = true,
    this.isAdsEnabled             = false,
    this.isOfflineEnabled         = true,
    this.isTeacherModeEnabled     = false,
    this.isParentalConsentRequired = true,
    this.isBilingualEnabled       = false,
    this.isRentalBookingActive    = false,
    this.isExpeditionVideoActive  = false,
  });

  factory FeatureFlags.fromJson(Map<String, dynamic> j) => FeatureFlags(
    isArEnabled:               j['is_ar_enabled']               ?? true,
    isQuizEnabled:             j['is_quiz_enabled']             ?? true,
    isLeaderboardEnabled:      j['is_leaderboard_enabled']      ?? true,
    isAdsEnabled:              j['is_ads_enabled']              ?? false,
    isOfflineEnabled:          j['is_offline_enabled']          ?? true,
    isTeacherModeEnabled:      j['is_teacher_mode_enabled']     ?? false,
    isParentalConsentRequired: j['is_parental_consent_required'] ?? true,
    isBilingualEnabled:        j['is_bilingual_enabled']        ?? false,
    isRentalBookingActive:     j['is_rental_booking_active']    ?? false,
    isExpeditionVideoActive:   j['is_expedition_video_active']  ?? false,
  );

  Map<String, dynamic> toJson() => {
    'is_ar_enabled':                isArEnabled,
    'is_quiz_enabled':              isQuizEnabled,
    'is_leaderboard_enabled':       isLeaderboardEnabled,
    'is_ads_enabled':               isAdsEnabled,
    'is_offline_enabled':           isOfflineEnabled,
    'is_teacher_mode_enabled':      isTeacherModeEnabled,
    'is_parental_consent_required': isParentalConsentRequired,
    'is_bilingual_enabled':         isBilingualEnabled,
    'is_rental_booking_active':     isRentalBookingActive,
    'is_expedition_video_active':   isExpeditionVideoActive,
  };
}

// ── Branding Override ─────────────────────────────────────────
@HiveType(typeId: 1)
class BrandingConfig extends HiveObject {
  @HiveField(0) String primaryColor;    // hex e.g. '#FF6B35'
  @HiveField(1) String secondaryColor;  // hex
  @HiveField(2) String logoUrl;
  @HiveField(3) String appName;
  @HiveField(4) String tagline;

  BrandingConfig({
    this.primaryColor   = '#FF6B35',
    this.secondaryColor = '#7C5CDD',
    this.logoUrl        = '',
    this.appName        = 'MITRA',
    this.tagline        = 'AR Learning Platform',
  });

  factory BrandingConfig.fromJson(Map<String, dynamic> j) => BrandingConfig(
    primaryColor:   j['primary_color']   ?? '#FF6B35',
    secondaryColor: j['secondary_color'] ?? '#7C5CDD',
    logoUrl:        j['logo_url']        ?? '',
    appName:        j['app_name']        ?? 'MITRA',
    tagline:        j['tagline']         ?? 'AR Learning Platform',
  );

  Map<String, dynamic> toJson() => {
    'primary_color':   primaryColor,
    'secondary_color': secondaryColor,
    'logo_url':        logoUrl,
    'app_name':        appName,
    'tagline':         tagline,
  };
}

// ── Nav Item (dynamic bottom navigation) ─────────────────────
@HiveType(typeId: 2)
class NavItem extends HiveObject {
  @HiveField(0) String id;        // 'home' | 'learn' | 'ar' | 'ranks' | 'profile'
  @HiveField(1) String labelKey;  // i18n key e.g. 'navHome'
  @HiveField(2) String icon;      // emoji or icon name
  @HiveField(3) int    order;

  NavItem({
    required this.id,
    required this.labelKey,
    required this.icon,
    required this.order,
  });

  factory NavItem.fromJson(Map<String, dynamic> j) => NavItem(
    id:       j['id']        ?? '',
    labelKey: j['label_key'] ?? '',
    icon:     j['icon']      ?? '',
    order:    j['order']     ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'id':        id,
    'label_key': labelKey,
    'icon':      icon,
    'order':     order,
  };
}

// ── Main App Config ───────────────────────────────────────────
@HiveType(typeId: 3)
class AppConfig extends HiveObject {
  @HiveField(0) String        stateCode;
  @HiveField(1) String        stateName;
  @HiveField(2) FeatureFlags  features;
  @HiveField(3) BrandingConfig branding;
  @HiveField(4) List<NavItem> navItems;
  @HiveField(5) List<String>  supportedLanguages;
  @HiveField(6) String        defaultLanguage;
  @HiveField(7) String        curriculumBoard;  // 'NCERT' | 'CBSE' | state board
  @HiveField(8) int           minClassGrade;
  @HiveField(9) int           maxClassGrade;
  @HiveField(10) String       syncedAt;
  @HiveField(11) String       emergencyAlert;   // empty = no alert
  @HiveField(12) String       deviceTier;       // 'low' | 'mid' | 'high'

  AppConfig({
    required this.stateCode,
    required this.stateName,
    required this.features,
    required this.branding,
    required this.navItems,
    required this.supportedLanguages,
    required this.defaultLanguage,
    required this.curriculumBoard,
    required this.minClassGrade,
    required this.maxClassGrade,
    required this.syncedAt,
    this.emergencyAlert = '',
    this.deviceTier     = 'mid',
  });

  factory AppConfig.fromJson(Map<String, dynamic> j) => AppConfig(
    stateCode:   j['state_code']    ?? '',
    stateName:   j['state_name']    ?? '',
    features:    FeatureFlags.fromJson(j['features'] ?? {}),
    branding:    BrandingConfig.fromJson(j['branding'] ?? {}),
    navItems:    ((j['nav_items'] as List?) ?? _defaultNav)
        .map((e) => NavItem.fromJson(e as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => a.order.compareTo(b.order)),
    supportedLanguages: List<String>.from(j['supported_languages'] ?? ['en', 'hi']),
    defaultLanguage:    j['default_language']  ?? 'en',
    curriculumBoard:    j['curriculum_board']  ?? 'NCERT',
    minClassGrade:      j['min_class_grade']   ?? 6,
    maxClassGrade:      j['max_class_grade']   ?? 12,
    syncedAt:           j['synced_at']         ?? DateTime.now().toIso8601String(),
    emergencyAlert:     j['emergency_alert']   ?? '',
    deviceTier:         j['device_tier']       ?? 'mid',
  );

  Map<String, dynamic> toJson() => {
    'state_code':          stateCode,
    'state_name':          stateName,
    'features':            features.toJson(),
    'branding':            branding.toJson(),
    'nav_items':           navItems.map((e) => e.toJson()).toList(),
    'supported_languages': supportedLanguages,
    'default_language':    defaultLanguage,
    'curriculum_board':    curriculumBoard,
    'min_class_grade':     minClassGrade,
    'max_class_grade':     maxClassGrade,
    'synced_at':           syncedAt,
    'emergency_alert':     emergencyAlert,
    'device_tier':         deviceTier,
  };

  /// Default nav when backend doesn't specify
  static const _defaultNav = [
    {'id': 'home',    'label_key': 'navHome',    'icon': '🏠', 'order': 0},
    {'id': 'learn',   'label_key': 'navLearn',   'icon': '📚', 'order': 1},
    {'id': 'ar',      'label_key': 'navAR',      'icon': '🥽', 'order': 2},
    {'id': 'ranks',   'label_key': 'navRanks',   'icon': '🏆', 'order': 3},
    {'id': 'profile', 'label_key': 'navProfile', 'icon': '👤', 'order': 4},
  ];

  /// Fallback config for offline first launch
  static AppConfig get fallback => AppConfig.fromJson({
    'state_code': 'XX', 'state_name': 'India',
    'features': {}, 'branding': {}, 'nav_items': _defaultNav,
    'supported_languages': ['en', 'hi'],
    'default_language': 'en',
    'curriculum_board': 'NCERT',
    'min_class_grade': 6, 'max_class_grade': 12,
    'synced_at': DateTime.now().toIso8601String(),
  });
}
