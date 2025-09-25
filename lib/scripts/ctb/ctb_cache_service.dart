import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'ctb_api_service.dart';

/// CTB Cache Service
class CTBCacheService {
  static const String _routesKey = 'ctb_routes';
  static const String _routesTimestampKey = 'ctb_routes_timestamp';
  static const int _cacheDurationMs = 7 * 24 * 60 * 60 * 1000; // 1 week

  static bool _isCacheValid(int ts) {
    final now = DateTime.now().millisecondsSinceEpoch;
    return (now - ts) < _cacheDurationMs;
  }

  static Future<List<CTBRoute>?> getCachedRoutes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_routesKey);
      final ts = prefs.getInt(_routesTimestampKey) ?? 0;
      if (jsonStr != null && _isCacheValid(ts)) {
        final list = json.decode(jsonStr) as List<dynamic>;
        return list
            .map((e) => CTBRoute.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return null;
    } catch (e) {
      print('[CTB] getCachedRoutes error: $e');
      return null;
    }
  }

  static Future<void> cacheRoutes(List<CTBRoute> routes) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = json.encode(routes.map((r) => r.toJson()).toList());
      final ts = DateTime.now().millisecondsSinceEpoch;
      await prefs.setString(_routesKey, jsonStr);
      await prefs.setInt(_routesTimestampKey, ts);
      print('[CTB] Cached routes: ${routes.length}');
    } catch (e) {
      print('[CTB] cacheRoutes error: $e');
    }
  }
}
