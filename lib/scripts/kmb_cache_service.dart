import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'kmb_api_service.dart';

/// KMB Cache Service
///
/// Handles local caching of KMB routes and stops data
/// to reduce API calls and improve app performance
class KMBCacheService {
  static const String _routesKey = 'kmb_routes';
  static const String _stopsKey = 'kmb_stops';
  static const String _routesTimestampKey = 'kmb_routes_timestamp';
  static const String _stopsTimestampKey = 'kmb_stops_timestamp';

  // Cache duration: 1 week in milliseconds
  static const int _cacheDurationMs = 7 * 24 * 60 * 60 * 1000;

  /// Build a unique cache key for route-stop list
  static String _routeStopsKey(
          String route, String bound, String serviceType) =>
      'kmb_route_stops_${route}_${bound}_${serviceType}';

  static String _routeStopsTimestampKey(
          String route, String bound, String serviceType) =>
      'kmb_route_stops_timestamp_${route}_${bound}_${serviceType}';

  /// Get cached routes data
  static Future<List<KMBRoute>?> getCachedRoutes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final routesJson = prefs.getString(_routesKey);
      final timestamp = prefs.getInt(_routesTimestampKey) ?? 0;

      // Check if cache is still valid
      if (routesJson != null && _isCacheValid(timestamp)) {
        final List<dynamic> routesList = json.decode(routesJson);
        return routesList.map((json) => KMBRoute.fromJson(json)).toList();
      }

      return null;
    } catch (e) {
      print('Error getting cached routes: $e');
      return null;
    }
  }

  /// Get cached stops data
  static Future<List<KMBStop>?> getCachedStops() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stopsJson = prefs.getString(_stopsKey);
      final timestamp = prefs.getInt(_stopsTimestampKey) ?? 0;

      // Check if cache is still valid
      if (stopsJson != null && _isCacheValid(timestamp)) {
        final List<dynamic> stopsList = json.decode(stopsJson);
        return stopsList.map((json) => KMBStop.fromJson(json)).toList();
      }

      return null;
    } catch (e) {
      print('Error getting cached stops: $e');
      return null;
    }
  }

  /// Get cached route stops for a specific route/bound/serviceType
  static Future<List<KMBRouteStop>?> getCachedRouteStops(
      String route, String bound, String serviceType) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _routeStopsKey(route, bound, serviceType);
      final tsKey = _routeStopsTimestampKey(route, bound, serviceType);
      final jsonStr = prefs.getString(key);
      final timestamp = prefs.getInt(tsKey) ?? 0;

      if (jsonStr != null && _isCacheValid(timestamp)) {
        final List<dynamic> list = json.decode(jsonStr);
        return list.map((j) => KMBRouteStop.fromJson(j)).toList();
      }
      return null;
    } catch (e) {
      print('Error getting cached route-stops: $e');
      return null;
    }
  }

  /// Cache route stops for a specific route/bound/serviceType
  static Future<void> cacheRouteStops(String route, String bound,
      String serviceType, List<KMBRouteStop> stops) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _routeStopsKey(route, bound, serviceType);
      final tsKey = _routeStopsTimestampKey(route, bound, serviceType);
      final jsonStr = json.encode(stops
          .map((s) => {
                'route': s.route,
                'bound': s.bound,
                'stop': s.stop,
                'seq': s.seq,
                'stop_name_en': s.stopNameEn,
                'stop_name_tc': s.stopNameTc,
                'stop_name_sc': s.stopNameSc,
              })
          .toList());
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      await prefs.setString(key, jsonStr);
      await prefs.setInt(tsKey, timestamp);

      print(
          'Route-stops cached: $route $bound/$serviceType count=${stops.length}');
    } catch (e) {
      print('Error caching route-stops: $e');
    }
  }

  /// Cache routes data
  static Future<void> cacheRoutes(List<KMBRoute> routes) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final routesJson = json.encode(routes
          .map((r) => {
                'route': r.route,
                'bound': r.bound,
                'service_type': r.serviceType,
                'orig_en': r.origEn,
                'orig_tc': r.origTc,
                'orig_sc': r.origSc,
                'dest_en': r.destEn,
                'dest_tc': r.destTc,
                'dest_sc': r.destSc,
              })
          .toList());
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      await prefs.setString(_routesKey, routesJson);
      await prefs.setInt(_routesTimestampKey, timestamp);

      print('Routes cached successfully: ${routes.length} routes');
    } catch (e) {
      print('Error caching routes: $e');
    }
  }

  /// Cache stops data
  static Future<void> cacheStops(List<KMBStop> stops) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stopsJson = json.encode(stops
          .map((s) => {
                'stop': s.stop,
                'name_en': s.nameEn,
                'name_tc': s.nameTc,
                'name_sc': s.nameSc,
                'lat': s.lat,
                'long': s.long,
              })
          .toList());
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      await prefs.setString(_stopsKey, stopsJson);
      await prefs.setInt(_stopsTimestampKey, timestamp);

      print('Stops cached successfully: ${stops.length} stops');
    } catch (e) {
      print('Error caching stops: $e');
    }
  }

  /// Check if cache is still valid
  static bool _isCacheValid(int timestamp) {
    final now = DateTime.now().millisecondsSinceEpoch;
    return (now - timestamp) < _cacheDurationMs;
  }

  /// Clear all cached data
  static Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_routesKey);
      await prefs.remove(_stopsKey);
      await prefs.remove(_routesTimestampKey);
      await prefs.remove(_stopsTimestampKey);

      // Note: route-stops entries are many keys; clear by prefix is not supported in SharedPreferences.
      // Caller may choose to rebuild app data to overwrite entries.
      print('Cache cleared successfully');
    } catch (e) {
      print('Error clearing cache: $e');
    }
  }

  /// Get cache info
  static Future<Map<String, dynamic>> getCacheInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final routesTimestamp = prefs.getInt(_routesTimestampKey) ?? 0;
      final stopsTimestamp = prefs.getInt(_stopsTimestampKey) ?? 0;

      return {
        'routesCached': routesTimestamp > 0,
        'stopsCached': stopsTimestamp > 0,
        'routesAge': routesTimestamp > 0
            ? DateTime.now().millisecondsSinceEpoch - routesTimestamp
            : 0,
        'stopsAge': stopsTimestamp > 0
            ? DateTime.now().millisecondsSinceEpoch - stopsTimestamp
            : 0,
        'routesValid': _isCacheValid(routesTimestamp),
        'stopsValid': _isCacheValid(stopsTimestamp),
      };
    } catch (e) {
      print('Error getting cache info: $e');
      return {};
    }
  }
}
