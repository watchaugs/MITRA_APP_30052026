// lib/services/background_sync.dart
// ════════════════════════════════════════════════════════════
// Background Sync Service using WorkManager
//
// Runs silently while the app is minimised / charging:
//  • Checks for new AppConfig from Dashboard
//  • Downloads new AR asset bundles to device cache
//  • Syncs offline progress to server when connectivity returns
// ════════════════════════════════════════════════════════════

import 'package:workmanager/workmanager.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'local_database.dart';

// ── Task IDs ──────────────────────────────────────────────────
abstract final class SyncTasks {
  static const configSync   = 'mitra.config_sync';
  static const assetCache   = 'mitra.asset_cache';
  static const progressSync = 'mitra.progress_sync';
}

// ── Custom Cache Manager for AR Assets ───────────────────────
class ArAssetCacheManager extends CacheManager {
  static const key = 'mitra_ar_assets';

  static final ArAssetCacheManager _inst = ArAssetCacheManager._();
  factory ArAssetCacheManager() => _inst;

  ArAssetCacheManager._() : super(Config(
    key,
    stalePeriod: const Duration(days: 30),
    maxNrOfCacheObjects: 100,
    repo: JsonCacheInfoRepository(databaseName: key),
    fileService: HttpFileService(),
  ));
}

// ── Background task dispatcher ────────────────────────────────
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    switch (taskName) {
      case SyncTasks.configSync:
        return _syncConfig(inputData);
      case SyncTasks.assetCache:
        return _cacheAssets(inputData);
      case SyncTasks.progressSync:
        return _syncProgress(inputData);
    }
    return Future.value(true);
  });
}

// ── Config sync ───────────────────────────────────────────────
Future<bool> _syncConfig(Map<String, dynamic>? input) async {
  try {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) return true;

    final wifiOnly = LocalDatabase.wifiOnlySync;
    final isWifi   = connectivity == ConnectivityResult.wifi;
    if (wifiOnly && !isWifi) return true;

    // TODO: call ApiService().getAppConfig(stateCode) and save to Hive
    return true;
  } catch (_) {
    return false;
  }
}

// ── AR Asset Caching ──────────────────────────────────────────
Future<bool> _cacheAssets(Map<String, dynamic>? input) async {
  try {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) return true;

    final wifiOnly = LocalDatabase.wifiOnlySync;
    final isWifi   = connectivity == ConnectivityResult.wifi;
    if (wifiOnly && !isWifi) return true;

    final urls = List<String>.from(input?['asset_urls'] ?? []);
    for (final url in urls) {
      await ArAssetCacheManager().downloadFile(url);
    }
    return true;
  } catch (_) {
    return false;
  }
}

// ── Progress Sync ─────────────────────────────────────────────
Future<bool> _syncProgress(Map<String, dynamic>? input) async {
  try {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) return true;
    // TODO: read pending progress from Hive and POST to /curriculum/progress
    return true;
  } catch (_) {
    return false;
  }
}

// ── Registration Helper ───────────────────────────────────────
class BackgroundSync {
  static Future<void> init() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );
  }

  /// Register periodic config sync (every 6 hours)
  static Future<void> registerConfigSync() async {
    await Workmanager().registerPeriodicTask(
      SyncTasks.configSync,
      SyncTasks.configSync,
      frequency: const Duration(hours: 6),
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: false,
        requiresCharging: false,
      ),
      existingWorkPolicy: ExistingWorkPolicy.keep,
    );
  }

  /// One-time asset pre-cache task
  static Future<void> scheduleAssetCache(List<String> urls) async {
    await Workmanager().registerOneOffTask(
      '${SyncTasks.assetCache}_${DateTime.now().millisecondsSinceEpoch}',
      SyncTasks.assetCache,
      inputData: {'asset_urls': urls},
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: true,
      ),
    );
  }

  /// Register progress sync to fire when connected
  static Future<void> registerProgressSync() async {
    await Workmanager().registerOneOffTask(
      SyncTasks.progressSync,
      SyncTasks.progressSync,
      constraints: Constraints(networkType: NetworkType.connected),
      existingWorkPolicy: ExistingWorkPolicy.keep,
    );
  }

  /// Pre-download AR asset for a topic
  static Future<void> preloadArAsset(String url) async {
    try {
      final conn = await Connectivity().checkConnectivity();
      if (conn == ConnectivityResult.none) return;
      if (LocalDatabase.wifiOnlySync &&
          !conn == ConnectivityResult.wifi) return;
      await ArAssetCacheManager().downloadFile(url);
    } catch (_) {}
  }

  /// Check if an AR asset is already cached
  static Future<bool> isAssetCached(String url) async {
    final info = await ArAssetCacheManager().getFileFromCache(url);
    return info != null;
  }

  /// Get local file path for a cached asset
  static Future<String?> getCachedPath(String url) async {
    final info = await ArAssetCacheManager().getFileFromCache(url);
    return info?.file.path;
  }
}
