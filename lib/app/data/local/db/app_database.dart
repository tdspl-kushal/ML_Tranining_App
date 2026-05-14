import 'package:hive_flutter/hive_flutter.dart';

class AppDatabase {
  static const String _leaderboardBox = 'leaderboard_cache';
  static const String _cacheTimestampBox = 'cache_timestamps';
  static const Duration cacheTtl = Duration(minutes: 5);

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_leaderboardBox);
    await Hive.openBox(_cacheTimestampBox);
  }

  static Box get leaderboardBox => Hive.box(_leaderboardBox);
  static Box get cacheTimestampBox => Hive.box(_cacheTimestampBox);

  static bool isCacheFresh(String key) {
    final timestamp = cacheTimestampBox.get(key);
    if (timestamp == null) return false;
    final cachedAt = DateTime.parse(timestamp);
    return DateTime.now().difference(cachedAt) < cacheTtl;
  }

  static void setCacheTimestamp(String key) {
    cacheTimestampBox.put(key, DateTime.now().toIso8601String());
  }

  static Future<void> clearAll() async {
    await leaderboardBox.clear();
    await cacheTimestampBox.clear();
  }
}
