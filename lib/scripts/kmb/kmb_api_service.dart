import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'kmb_cache_service.dart';

/// KMB API Service for Hong Kong Bus Data
///
/// This script handles all KMB (Kowloon Motor Bus) API interactions
/// including fetching routes, stops, and real-time ETA data.
class KMBApiService {
  static const String baseUrl = 'https://data.etabus.gov.hk/v1/transport/kmb';

  /// Fetch all available KMB bus routes
  static Future<List<KMBRoute>> getAllRoutes([BuildContext? context]) async {
    try {
      // Try to get cached data first
      final cachedRoutes = await KMBCacheService.getCachedRoutes();
      if (cachedRoutes != null) {
        print('Using cached routes: ${cachedRoutes.length} routes');
        return cachedRoutes;
      }

      // If no cache, fetch from API
      print('Fetching routes from API...');
      final url = '$baseUrl/route';
      print('API URL: $url');

      final response = await http.get(Uri.parse(url));
      print('Response status: ${response.statusCode}');
      print('Response body length: ${response.body.length}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> routesData = data['data'] ?? [];
        print('Parsed routes count: ${routesData.length}');

        final routes =
            routesData.map((route) => KMBRoute.fromJson(route)).toList();

        // Cache the data for future use
        await KMBCacheService.cacheRoutes(routes);
        print('Routes cached successfully: ${routes.length} routes');

        return routes;
      } else {
        print('API Error: ${response.statusCode} - ${response.body}');
        final errorMessage = context != null
            ? AppLocalizations.of(context)?.apiErrorFailedToLoadRoutes ??
                'Failed to load routes'
            : 'Failed to load routes';
        throw Exception(
            '$errorMessage: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error in getAllRoutes: $e');
      final errorMessage = context != null
          ? AppLocalizations.of(context)?.apiErrorFetchingRoutes ??
              'Error fetching routes'
          : 'Error fetching routes';
      throw Exception('$errorMessage: $e');
    }
  }

  /// Fetch all available KMB bus stops
  static Future<List<KMBStop>> getAllStops([BuildContext? context]) async {
    try {
      // Try to get cached data first
      final cachedStops = await KMBCacheService.getCachedStops();
      if (cachedStops != null) {
        print('Using cached stops: ${cachedStops.length} stops');
        return cachedStops;
      }

      // If no cache, fetch from API
      print('Fetching stops from API...');
      final url = '$baseUrl/stop';
      print('API URL: $url');

      final response = await http.get(Uri.parse(url));
      print('Response status: ${response.statusCode}');
      print('Response body length: ${response.body.length}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> stopsData = data['data'] ?? [];
        print('Parsed stops count: ${stopsData.length}');

        final stops = stopsData.map((stop) => KMBStop.fromJson(stop)).toList();

        // Cache the data for future use
        await KMBCacheService.cacheStops(stops);
        print('Stops cached successfully: ${stops.length} stops');

        return stops;
      } else {
        print('API Error: ${response.statusCode} - ${response.body}');
        final errorMessage = context != null
            ? AppLocalizations.of(context)?.apiErrorFailedToLoadStops ??
                'Failed to load stops'
            : 'Failed to load stops';
        throw Exception(
            '$errorMessage: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error in getAllStops: $e');
      final errorMessage = context != null
          ? AppLocalizations.of(context)?.apiErrorFetchingStops ??
              'Error fetching stops'
          : 'Error fetching stops';
      throw Exception('$errorMessage: $e');
    }
  }

  /// Search routes by route number
  static Future<List<KMBRoute>> searchRoutes(String query,
      [BuildContext? context]) async {
    final allRoutes = await getAllRoutes(context);
    return allRoutes
        .where((route) =>
            route.route.toLowerCase().contains(query.toLowerCase()) ||
            route.destEn.toLowerCase().contains(query.toLowerCase()) ||
            route.destTc.contains(query) ||
            route.destSc.contains(query))
        .toList();
  }

  /// Search stops by name
  static Future<List<KMBStop>> searchStops(String query) async {
    final allStops = await getAllStops();
    return allStops
        .where((stop) =>
            stop.nameEn.toLowerCase().contains(query.toLowerCase()) ||
            stop.nameTc.contains(query) ||
            stop.nameSc.contains(query))
        .toList();
  }

  /// Fetch route stops for a specific route, bound and serviceType
  static Future<List<KMBRouteStop>> getRouteStops(
      String route, String bound, String serviceType,
      [BuildContext? context]) async {
    try {
      // Convert bound to API format (I -> inbound, O -> outbound)
      final boundParam = bound == 'I' ? 'inbound' : 'outbound';

      // Try cached route-stops first for the specific serviceType
      // Use the original bound parameter for cache consistency
      final cached =
          await KMBCacheService.getCachedRouteStops(route, bound, serviceType);
      if (cached != null && cached.isNotEmpty) {
        print(
            'Using cached route-stops: $route $bound/$serviceType count=${cached.length}');
        // Debug: Print first few cached stops
        for (int i = 0; i < cached.length && i < 3; i++) {
          final stop = cached[i];
          print(
              'Cached Stop $i: ${stop.stopNameTc} (${stop.stopNameEn}) - Seq: ${stop.seq}');
        }
        return cached;
      } else {
        print('No valid cached data found, fetching from API...');
      }

      // Use the correct API endpoint format: route-stop/{route}/{bound}/{service_type}
      final apiUrl = '$baseUrl/route-stop/$route/$boundParam/$serviceType';
      print('API URL: $apiUrl');
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> stopsData = data['data'] ?? [];
        print('API Response - Number of stops: ${stopsData.length}');

        // Get all stops to look up names
        final allStops = await getAllStops();
        final stopMap = {for (var stop in allStops) stop.stop: stop};

        // Create route stops with names from the stops data
        final stops = <KMBRouteStop>[];
        for (final stopData in stopsData) {
          final stopId = stopData['stop'] as String;
          final stopInfo = stopMap[stopId];

          if (stopInfo != null) {
            stops.add(KMBRouteStop(
              route: stopData['route']?.toString() ?? '',
              bound: stopData['bound']?.toString() ?? '',
              stop: stopId,
              seq: int.tryParse(stopData['seq']?.toString() ?? '0') ?? 0,
              stopNameEn: stopInfo.nameEn,
              stopNameTc: stopInfo.nameTc,
              stopNameSc: stopInfo.nameSc,
            ));
          } else {
            // Fallback if stop not found
            stops.add(KMBRouteStop(
              route: stopData['route']?.toString() ?? '',
              bound: stopData['bound']?.toString() ?? '',
              stop: stopId,
              seq: int.tryParse(stopData['seq']?.toString() ?? '0') ?? 0,
              stopNameEn: context != null
                  ? AppLocalizations.of(context)?.apiErrorUnknownStop ??
                      'Unknown Stop'
                  : 'Unknown Stop',
              stopNameTc: context != null
                  ? AppLocalizations.of(context)?.apiErrorUnknownStop ?? '未知車站'
                  : '未知車站',
              stopNameSc: context != null
                  ? AppLocalizations.of(context)?.apiErrorUnknownStop ?? '未知车站'
                  : '未知车站',
            ));
          }
        }

        // Debug: Print first few stops with names
        for (int i = 0; i < stops.length && i < 3; i++) {
          final stop = stops[i];
          print(
              'Stop $i: ${stop.stopNameTc} (${stop.stopNameEn}) - Seq: ${stop.seq}');
        }

        // Cache for future use using the original bound parameter and serviceType
        await KMBCacheService.cacheRouteStops(route, bound, serviceType, stops);

        return stops;
      } else {
        print('API Error: ${response.statusCode} - ${response.body}');
        final errorMessage = context != null
            ? AppLocalizations.of(context)?.apiErrorFailedToLoadRouteStops ??
                'Failed to load route stops'
            : 'Failed to load route stops';
        throw Exception('$errorMessage: ${response.statusCode}');
      }
    } catch (e) {
      final errorMessage = context != null
          ? AppLocalizations.of(context)?.apiErrorFetchingRouteStops ??
              'Error fetching route stops'
          : 'Error fetching route stops';
      throw Exception('$errorMessage: $e');
    }
  }

  /// Get ETA data for a specific stop, route, and service type
  static Future<List<KMBETA>> getETA(
      String stopId, String route, String serviceType,
      [BuildContext? context]) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/eta/$stopId/$route/$serviceType'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> etaData = data['data'] ?? [];

        return etaData.map((eta) => KMBETA.fromJson(eta)).toList();
      } else {
        final errorMessage = context != null
            ? AppLocalizations.of(context)?.apiErrorFailedToLoadETA ??
                'Failed to load ETA'
            : 'Failed to load ETA';
        throw Exception('$errorMessage: ${response.statusCode}');
      }
    } catch (e) {
      final errorMessage = context != null
          ? AppLocalizations.of(context)?.apiErrorFetchingETA ??
              'Error fetching ETA'
          : 'Error fetching ETA';
      throw Exception('$errorMessage: $e');
    }
  }
}

/// KMB Route Data Model
class KMBRoute {
  final String route;
  final String bound;
  final String serviceType;
  final String origEn;
  final String origTc;
  final String origSc;
  final String destEn;
  final String destTc;
  final String destSc;

  KMBRoute({
    required this.route,
    required this.bound,
    required this.serviceType,
    required this.origEn,
    required this.origTc,
    required this.origSc,
    required this.destEn,
    required this.destTc,
    required this.destSc,
  });

  factory KMBRoute.fromJson(Map<String, dynamic> json) {
    return KMBRoute(
      route: json['route'] ?? '',
      bound: json['bound'] ?? '',
      serviceType: json['service_type'] ?? '',
      origEn: json['orig_en'] ?? '',
      origTc: json['orig_tc'] ?? '',
      origSc: json['orig_sc'] ?? '',
      destEn: json['dest_en'] ?? '',
      destTc: json['dest_tc'] ?? '',
      destSc: json['dest_sc'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'route': route,
      'bound': bound,
      'service_type': serviceType,
      'orig_en': origEn,
      'orig_tc': origTc,
      'orig_sc': origSc,
      'dest_en': destEn,
      'dest_tc': destTc,
      'dest_sc': destSc,
    };
  }

  @override
  String toString() {
    return 'Route $route: $origEn → $destEn';
  }
}

/// KMB Stop Data Model
class KMBStop {
  final String stop;
  final String nameEn;
  final String nameTc;
  final String nameSc;
  final String lat;
  final String long;

  KMBStop({
    required this.stop,
    required this.nameEn,
    required this.nameTc,
    required this.nameSc,
    required this.lat,
    required this.long,
  });

  factory KMBStop.fromJson(Map<String, dynamic> json) {
    return KMBStop(
      stop: json['stop'] ?? '',
      nameEn: json['name_en'] ?? '',
      nameTc: json['name_tc'] ?? '',
      nameSc: json['name_sc'] ?? '',
      lat: json['lat'] ?? '',
      long: json['long'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stop': stop,
      'name_en': nameEn,
      'name_tc': nameTc,
      'name_sc': nameSc,
      'lat': lat,
      'long': long,
    };
  }

  @override
  String toString() {
    return '$nameEn ($nameTc)';
  }
}

/// KMB ETA Data Model
class KMBETA {
  final String co;
  final String route;
  final String dir;
  final int serviceType;
  final int seq;
  final String destEn;
  final String destTc;
  final String destSc;
  final int etaSeq;
  final String eta;
  final String rmkEn;
  final String rmkTc;
  final String rmkSc;
  final String dataTimestamp;

  KMBETA({
    required this.co,
    required this.route,
    required this.dir,
    required this.serviceType,
    required this.seq,
    required this.destEn,
    required this.destTc,
    required this.destSc,
    required this.etaSeq,
    required this.eta,
    required this.rmkEn,
    required this.rmkTc,
    required this.rmkSc,
    required this.dataTimestamp,
  });

  factory KMBETA.fromJson(Map<String, dynamic> json) {
    return KMBETA(
      co: json['co'] ?? '',
      route: json['route'] ?? '',
      dir: json['dir'] ?? '',
      serviceType: int.tryParse(json['service_type']?.toString() ?? '1') ?? 1,
      seq: int.tryParse(json['seq']?.toString() ?? '0') ?? 0,
      destEn: json['dest_en'] ?? '',
      destTc: json['dest_tc'] ?? '',
      destSc: json['dest_sc'] ?? '',
      etaSeq: int.tryParse(json['eta_seq']?.toString() ?? '0') ?? 0,
      eta: json['eta'] ?? '',
      rmkEn: json['rmk_en'] ?? '',
      rmkTc: json['rmk_tc'] ?? '',
      rmkSc: json['rmk_sc'] ?? '',
      dataTimestamp: json['data_timestamp'] ?? '',
    );
  }

  /// Calculate minutes until arrival from current time (GMT+8)
  int get minutesUntilArrival {
    try {
      // print('=== Time Calculation Debug ===');
      print('ETA String: $eta');

      // Parse ETA time (already in GMT+8 format with +08:00)
      final etaDateTime = DateTime.parse(eta);
      // print('Parsed ETA DateTime: $etaDateTime');
      // print('ETA DateTime UTC: ${etaDateTime.toUtc()}');

      // Get current time
      final now = DateTime.now();
      // print('Current DateTime: $now');
      // print('Current DateTime UTC: ${now.toUtc()}');

      // Compare both times in UTC
      // ETA is already converted to UTC by DateTime.parse()
      // Current time is already in UTC
      final difference = etaDateTime.toUtc().difference(now.toUtc());
      // print('Time Difference (UTC): $difference');
      print('Minutes Difference: ${difference.inMinutes}');
      print('==============================');

      return difference.inMinutes;
    } catch (e) {
      print('=== Time Calculation Error ===');
      print('Error parsing ETA: $e');
      print('ETA String: $eta');
      print('==============================');
      return -1; // Error parsing time
    }
  }

  /// Get formatted arrival time string
  String getArrivalTimeString([BuildContext? context]) {
    if (eta.trim().isEmpty) {
      return context != null
          ? AppLocalizations.of(context)?.apiErrorNoData ?? '沒有資料'
          : '沒有資料';
    }
    final minutes = minutesUntilArrival;
    if (minutes > 0) {
      final minutesText = context != null
          ? AppLocalizations.of(context)?.apiErrorMinutes ?? '分鐘'
          : '分鐘';
      return '$minutes $minutesText';
    } else if (minutes == 0) {
      return context != null
          ? AppLocalizations.of(context)?.apiErrorArrivingNow ?? '即將到達'
          : '即將到達';
    } else {
      return context != null
          ? AppLocalizations.of(context)?.apiErrorBusMayHaveLeft ?? '巴士可能已離站'
          : '巴士可能已離站';
    }
  }

  /// Get formatted arrival time string in English
  String getArrivalTimeStringEn([BuildContext? context]) {
    if (eta.trim().isEmpty) {
      return context != null
          ? AppLocalizations.of(context)?.apiErrorNoData ?? 'No Data'
          : 'No Data';
    }
    final minutes = minutesUntilArrival;
    if (minutes > 0) {
      final minutesText = context != null
          ? AppLocalizations.of(context)?.apiErrorMinutes ?? 'min'
          : 'min';
      return '$minutes $minutesText';
    } else if (minutes == 0) {
      return context != null
          ? AppLocalizations.of(context)?.apiErrorArrivingNow ?? 'Arriving now'
          : 'Arriving now';
    } else {
      return context != null
          ? AppLocalizations.of(context)?.apiErrorExpired ?? 'Expired'
          : 'Expired';
    }
  }

  @override
  String toString() {
    final minutes = minutesUntilArrival;
    if (minutes > 0) {
      return 'Route $route: $minutes min';
    } else if (minutes == 0) {
      return 'Route $route: Arriving now';
    } else {
      return 'Route $route: $eta';
    }
  }
}

/// KMB Route Stop Data Model
class KMBRouteStop {
  final String route;
  final String bound;
  final String stop;
  final int seq;
  final String stopNameEn;
  final String stopNameTc;
  final String stopNameSc;

  KMBRouteStop({
    required this.route,
    required this.bound,
    required this.stop,
    required this.seq,
    required this.stopNameEn,
    required this.stopNameTc,
    required this.stopNameSc,
  });

  factory KMBRouteStop.fromJson(Map<String, dynamic> json) {
    return KMBRouteStop(
      route: json['route'] ?? '',
      bound: json['bound'] ?? '',
      stop: json['stop'] ?? '',
      seq: int.tryParse(json['seq']?.toString() ?? '0') ?? 0,
      stopNameEn: json['stop_name_en'] ?? '',
      stopNameTc: json['stop_name_tc'] ?? '',
      stopNameSc: json['stop_name_sc'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Route Stop: $route-$bound, Stop: $stopNameTc ($stopNameEn), Seq: $seq';
  }
}
