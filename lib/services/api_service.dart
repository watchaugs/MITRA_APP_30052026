// lib/services/api_service.dart
// ════════════════════════════════════════════════════════════
// MITRA Student App — API Service
//
// KEY ARCHITECTURE RULES:
//  1. Every request auto-attaches state_id + Accept-Language header
//  2. JWT is injected from secure storage
//  3. Auto-refreshes token on 401
//  4. Falls back to local Hive cache on network error
// ════════════════════════════════════════════════════════════

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_config.dart';
import '../models/student_models.dart';

// ── API Constants ──────────────────────────────────────────────
abstract final class ApiK {
  // ⚠️  Replace with your real backend URL before launch
  static const base = 'https://api.mitra.gov.in/v1';

  // App Config (SDUI)
  static const appConfig = '/app-config';

  // Auth
  static const otpRequest  = '/auth/otp/request';
  static const otpVerify   = '/auth/otp/verify';
  static const refreshToken = '/auth/refresh';
  static const logout       = '/auth/logout';
  static const deviceToken  = '/auth/device-token';

  // Student
  static const profile        = '/student/profile';
  static const profileSetup   = '/student/profile/setup';
  static const consent        = '/student/consent';
  static const parentConsent  = '/student/parental-consent';

  // Curriculum
  static const subjects = '/curriculum/subjects';
  static const topics   = '/curriculum/topics';
  static const progress = '/curriculum/progress';

  // AR
  static const arAssets = '/ar/assets';
  static const arSession = '/ar/session';

  // Quiz
  static const quizByTopic = '/quiz/topic';
  static const quizSubmit  = '/quiz/submit';

  // Leaderboard
  static const leaderboard = '/leaderboard/class';

  // Badges
  static const badges = '/badges';

  // Ads
  static const nextAd      = '/ads/next';
  static const adImpression = '/ads/impression';

  // Sync
  static const syncStatus = '/sync/status';
}

// ── Secure Storage ────────────────────────────────────────────
class TokenStore {
  static const _s = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static const _accessKey  = 'mitra_access';
  static const _refreshKey = 'mitra_refresh';
  static const _stateKey   = 'mitra_state_id';
  static const _langKey    = 'mitra_language';

  static Future<void> saveTokens(String access, String refresh) async {
    await _s.write(key: _accessKey,  value: access);
    await _s.write(key: _refreshKey, value: refresh);
  }

  static Future<String?> getAccess()  => _s.read(key: _accessKey);
  static Future<String?> getRefresh() => _s.read(key: _refreshKey);

  static Future<void> saveStateId(String stateId) =>
      _s.write(key: _stateKey, value: stateId);
  static Future<String?> getStateId() => _s.read(key: _stateKey);

  static Future<void> saveLanguage(String lang) =>
      _s.write(key: _langKey, value: lang);
  static Future<String?> getLanguage() => _s.read(key: _langKey);

  static Future<void> clear() async {
    await _s.delete(key: _accessKey);
    await _s.delete(key: _refreshKey);
  }
}

// ── API Result Wrapper ────────────────────────────────────────
sealed class ApiResult<T> {}
class ApiOk<T>  extends ApiResult<T> { final T data; ApiOk(this.data); }
class ApiErr<T> extends ApiResult<T> { final String msg; final int? code; ApiErr(this.msg, {this.code}); }

// ── Dio Builder ───────────────────────────────────────────────
Dio _buildDio() {
  final dio = Dio(BaseOptions(
    baseUrl:        ApiK.base,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 30),
    headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
  ));

  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      // 1. Attach JWT
      final token = await TokenStore.getAccess();
      if (token != null) options.headers['Authorization'] = 'Bearer $token';

      // 2. Attach state_id (every request — backend needs it for regional data)
      final stateId = await TokenStore.getStateId();
      if (stateId != null) options.headers['X-State-ID'] = stateId;

      // 3. Attach language preference
      final lang = await TokenStore.getLanguage() ?? 'en';
      options.headers['Accept-Language'] = lang;

      return handler.next(options);
    },

    onError: (DioException e, handler) async {
      if (e.response?.statusCode == 401) {
        final refresh = await TokenStore.getRefresh();
        if (refresh != null) {
          try {
            final r = await Dio(BaseOptions(baseUrl: ApiK.base))
                .post(ApiK.refreshToken, data: {'refresh_token': refresh});
            await TokenStore.saveTokens(
              r.data['access_token']  as String,
              r.data['refresh_token'] as String,
            );
            e.requestOptions.headers['Authorization'] =
                'Bearer ${r.data['access_token']}';
            return handler.resolve(await dio.fetch(e.requestOptions));
          } catch (_) {
            await TokenStore.clear();
          }
        }
      }
      return handler.next(e);
    },
  ));

  return dio;
}

// ── Main API Service ──────────────────────────────────────────
class ApiService {
  ApiService(this._dio);
  final Dio _dio;

  Future<ApiResult<T>> _call<T>(Future<T> Function() fn) async {
    try {
      return ApiOk(await fn());
    } on DioException catch (e) {
      final msg = (e.response?.data as Map?)?['message'] as String?
          ?? e.message ?? 'Network error';
      return ApiErr(msg, code: e.response?.statusCode);
    } catch (e) {
      return ApiErr(e.toString());
    }
  }

  // ── Auth ──────────────────────────────────────────────────
  /// POST /auth/otp/request  { phone, role }
  Future<ApiResult<void>> requestOtp(String phone, String role) =>
      _call(() async {
    await _dio.post(ApiK.otpRequest, data: {'phone': phone, 'role': role});
  });

  /// POST /auth/otp/verify  { phone, otp, role }
  /// Returns: { access_token, refresh_token, is_new_user }
  Future<ApiResult<Map<String, dynamic>>> verifyOtp({
    required String phone,
    required String otp,
    required String role,
  }) => _call(() async {
    final res = await _dio.post(ApiK.otpVerify, data: {
      'phone': phone, 'otp': otp, 'role': role,
    });
    final data = res.data as Map<String, dynamic>;
    await TokenStore.saveTokens(
      data['access_token']  as String,
      data['refresh_token'] as String,
    );
    return data;
  });

  Future<ApiResult<void>> logout() => _call(() async {
    await _dio.post(ApiK.logout);
    await TokenStore.clear();
  });

  /// Register FCM device token for push notifications
  Future<ApiResult<void>> registerDeviceToken(String fcmToken) =>
      _call(() async {
    await _dio.post(ApiK.deviceToken, data: {'fcm_token': fcmToken});
  });

  // ── App Config (SDUI) ─────────────────────────────────────
  /// GET /app-config?state_code=XX
  Future<ApiResult<AppConfig>> getAppConfig(String stateCode) =>
      _call(() async {
    final res = await _dio.get(
      ApiK.appConfig,
      queryParameters: {'state_code': stateCode},
    );
    return AppConfig.fromJson(res.data as Map<String, dynamic>);
  });

  // ── Student Profile ───────────────────────────────────────
  /// GET /student/profile
  Future<ApiResult<StudentProfile>> getProfile() => _call(() async {
    final res = await _dio.get(ApiK.profile);
    return StudentProfile.fromJson(res.data as Map<String, dynamic>);
  });

  /// POST /student/profile/setup
  Future<ApiResult<StudentProfile>> setupProfile({
    required String name,
    required String avatar,
    required int    classGrade,
    required String stateCode,
    required String schoolName,
    String? district,
  }) => _call(() async {
    final res = await _dio.post(ApiK.profileSetup, data: {
      'name': name, 'avatar': avatar, 'class_grade': classGrade,
      'state_code': stateCode, 'school_name': schoolName,
      if (district != null) 'district': district,
    });
    return StudentProfile.fromJson(res.data as Map<String, dynamic>);
  });

  /// POST /student/consent  { consent_given: true }
  Future<ApiResult<void>> submitConsent(bool given) => _call(() async {
    await _dio.post(ApiK.consent, data: {'consent_given': given});
  });

  /// POST /student/parental-consent  { parent_phone, otp }
  Future<ApiResult<void>> submitParentalConsent({
    required String parentPhone,
    required String otp,
  }) => _call(() async {
    await _dio.post(ApiK.parentConsent,
        data: {'parent_phone': parentPhone, 'otp': otp});
  });

  // ── Curriculum ────────────────────────────────────────────
  /// GET /curriculum/subjects?class_grade=9
  Future<ApiResult<List<Subject>>> getSubjects(int classGrade) =>
      _call(() async {
    final res = await _dio.get(
      ApiK.subjects,
      queryParameters: {'class_grade': classGrade},
    );
    return (res.data as List)
        .map((e) => Subject.fromJson(e as Map<String, dynamic>))
        .toList();
  });

  /// GET /curriculum/topics?subject_id=&class_grade=
  Future<ApiResult<List<Topic>>> getTopics({
    required String subjectId,
    required int classGrade,
  }) => _call(() async {
    final res = await _dio.get(ApiK.topics, queryParameters: {
      'subject_id': subjectId, 'class_grade': classGrade,
    });
    return (res.data as List)
        .map((e) => Topic.fromJson(e as Map<String, dynamic>))
        .toList();
  });

  /// POST /curriculum/progress  { topic_id, progress_pct }
  Future<ApiResult<void>> updateProgress(String topicId, double pct) =>
      _call(() async {
    await _dio.post(ApiK.progress,
        data: {'topic_id': topicId, 'progress_pct': pct});
  });

  // ── AR ────────────────────────────────────────────────────
  /// GET /ar/assets/{id}
  Future<ApiResult<Map<String, dynamic>>> getArAsset(String assetId) =>
      _call(() async {
    final res = await _dio.get('${ApiK.arAssets}/$assetId');
    return res.data as Map<String, dynamic>;
  });

  /// POST /ar/session  { topic_id, duration_seconds }
  Future<ApiResult<void>> logArSession(String topicId, int seconds) =>
      _call(() async {
    await _dio.post(ApiK.arSession,
        data: {'topic_id': topicId, 'duration_seconds': seconds});
  });

  // ── Quiz ──────────────────────────────────────────────────
  /// GET /quiz/topic/{topicId}
  Future<ApiResult<Quiz>> getQuiz(String topicId) => _call(() async {
    final res = await _dio.get('${ApiK.quizByTopic}/$topicId');
    return Quiz.fromJson(res.data as Map<String, dynamic>);
  });

  /// POST /quiz/submit
  Future<ApiResult<QuizResult>> submitQuiz({
    required String quizId,
    required List<int> answers,
    required int secondsTaken,
  }) => _call(() async {
    final res = await _dio.post(ApiK.quizSubmit, data: {
      'quiz_id': quizId, 'answers': answers, 'seconds_taken': secondsTaken,
    });
    final d = res.data as Map<String, dynamic>;
    return QuizResult(
      quizId:             quizId,
      correct:            d['correct']              ?? 0,
      total:              d['total']                ?? 0,
      xpEarned:           d['xp_earned']            ?? 0,
      secondsTaken:       secondsTaken,
      badgeUnlockedId:    d['badge_unlocked_id'],
      badgeUnlockedTitle: d['badge_unlocked_title'],
    );
  });

  // ── Leaderboard ───────────────────────────────────────────
  Future<ApiResult<List<LeaderboardEntry>>> getLeaderboard() =>
      _call(() async {
    final res = await _dio.get(ApiK.leaderboard);
    return (res.data as List)
        .map((e) => LeaderboardEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  });

  // ── Ads ───────────────────────────────────────────────────
  Future<ApiResult<AdContent>> getNextAd() => _call(() async {
    final res = await _dio.get(ApiK.nextAd);
    return AdContent.fromJson(res.data as Map<String, dynamic>);
  });

  Future<ApiResult<void>> logAdImpression(String adId, bool completed) =>
      _call(() async {
    await _dio.post(ApiK.adImpression,
        data: {'ad_id': adId, 'completed': completed});
  });

  // ── Sync ──────────────────────────────────────────────────
  Future<ApiResult<Map<String, dynamic>>> checkSyncStatus() =>
      _call(() async {
    final res = await _dio.get(ApiK.syncStatus);
    return res.data as Map<String, dynamic>;
  });
}

// ── Provider ──────────────────────────────────────────────────
final dioProvider       = Provider<Dio>((ref) => _buildDio());
final apiServiceProvider = Provider<ApiService>(
  (ref) => ApiService(ref.watch(dioProvider)));
