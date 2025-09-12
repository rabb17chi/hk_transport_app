import 'dart:convert';
import 'package:http/http.dart' as http;

/// KMB API Service for Hong Kong Bus Data
///
/// This script handles all KMB (Kowloon Motor Bus) API interactions
/// including fetching routes, stops, and real-time ETA data.
class KMBApiService {
  static const String baseUrl = 'https://data.etabus.gov.hk/v1/transport/kmb';

  /// Fetch all available KMB bus routes
  static Future<List<KMBRoute>> getAllRoutes() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/route'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> routesData = data['data'] ?? [];

        return routesData.map((route) => KMBRoute.fromJson(route)).toList();
      } else {
        throw Exception('Failed to load routes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching routes: $e');
    }
  }

  /// Fetch all available KMB bus stops
  static Future<List<KMBStop>> getAllStops() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/stop'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> stopsData = data['data'] ?? [];

        return stopsData.map((stop) => KMBStop.fromJson(stop)).toList();
      } else {
        throw Exception('Failed to load stops: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching stops: $e');
    }
  }

  /// Fetch real-time ETA for a specific route and stop
  static Future<List<KMBETA>> getETA(
      String stopId, String route, String serviceType) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/eta/$stopId/$route/$serviceType'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> etaData = data['data'] ?? [];

        return etaData.map((eta) => KMBETA.fromJson(eta)).toList();
      } else {
        throw Exception('Failed to load ETA: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching ETA: $e');
    }
  }

  /// Search routes by route number
  static Future<List<KMBRoute>> searchRoutes(String query) async {
    final allRoutes = await getAllRoutes();
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

  /// Fetch route stops for a specific route and bound
  static Future<List<KMBRouteStop>> getRouteStops(
      String route, String bound) async {
    try {
      // Convert bound to API format (I -> inbound, O -> outbound)
      final boundParam = bound == 'I' ? 'inbound' : 'outbound';

      // Use the correct API endpoint format: route-stop/{route}/{bound}/{service_type}
      final response =
          await http.get(Uri.parse('$baseUrl/route-stop/$route/$boundParam/1'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> routeStopsData = data['data'] ?? [];

        // Get stop details for each route stop
        final List<KMBRouteStop> routeStops = [];
        for (final routeStopData in routeStopsData) {
          try {
            // Get stop details
            final stopResponse = await http
                .get(Uri.parse('$baseUrl/stop/${routeStopData['stop']}'));

            if (stopResponse.statusCode == 200) {
              final stopData = json.decode(stopResponse.body);
              final stopInfo = stopData['data'] ?? {};

              final routeStop = KMBRouteStop(
                route: routeStopData['route'] ?? '',
                bound: routeStopData['bound'] ?? '',
                stop: routeStopData['stop'] ?? '',
                seq: int.tryParse(routeStopData['seq']?.toString() ?? '0') ?? 0,
                stopNameEn: stopInfo['name_en'] ?? '',
                stopNameTc: stopInfo['name_tc'] ?? '',
                stopNameSc: stopInfo['name_sc'] ?? '',
              );

              routeStops.add(routeStop);
            }
          } catch (e) {
            // If stop details fail, still add the route stop with basic info
            final routeStop = KMBRouteStop(
              route: routeStopData['route'] ?? '',
              bound: routeStopData['bound'] ?? '',
              stop: routeStopData['stop'] ?? '',
              seq: int.tryParse(routeStopData['seq']?.toString() ?? '0') ?? 0,
              stopNameEn: 'Stop ${routeStopData['stop']}',
              stopNameTc: '站點 ${routeStopData['stop']}',
              stopNameSc: '站点 ${routeStopData['stop']}',
            );

            routeStops.add(routeStop);
          }
        }

        // Sort by sequence number
        routeStops.sort((a, b) => a.seq.compareTo(b.seq));

        return routeStops;
      } else {
        throw Exception('Failed to load route stops: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching route stops: $e');
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
  final String serviceType;
  final String seq;
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
      serviceType: json['service_type'] ?? '',
      seq: json['seq'] ?? '',
      destEn: json['dest_en'] ?? '',
      destTc: json['dest_tc'] ?? '',
      destSc: json['dest_sc'] ?? '',
      etaSeq: json['eta_seq'] ?? 0,
      eta: json['eta'] ?? '',
      rmkEn: json['rmk_en'] ?? '',
      rmkTc: json['rmk_tc'] ?? '',
      rmkSc: json['rmk_sc'] ?? '',
      dataTimestamp: json['data_timestamp'] ?? '',
    );
  }

  /// Calculate minutes until arrival
  int get minutesUntilArrival {
    try {
      final etaTime = DateTime.parse(eta);
      final now = DateTime.now();
      final difference = etaTime.difference(now);
      return difference.inMinutes;
    } catch (e) {
      return -1; // Error parsing time
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
      seq: json['seq'] ?? 0,
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
