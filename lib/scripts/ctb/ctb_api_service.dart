import 'dart:convert';
import 'package:http/http.dart' as http;
import 'ctb_cache_service.dart';

/// CTB (Citybus) API Service
class CTBApiService {
  static const String baseUrl = 'https://rt.data.gov.hk/v2/transport/citybus';

  /// Fetch all CTB routes (company: ctb)
  static Future<List<CTBRoute>> getAllRoutes() async {
    try {
      // Use cache first
      final cached = await CTBCacheService.getCachedRoutes();
      if (cached != null) {
        print('[CTB] Using cached routes: ${cached.length}');
        return cached;
      }

      final url = '$baseUrl/route/ctb';
      print('[CTB] Fetching routes: $url');
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception('[CTB] Failed: ${response.statusCode}');
      }

      final body = json.decode(response.body) as Map<String, dynamic>;
      final List<dynamic> list =
          (body['data'] as List<dynamic>? ?? <dynamic>[]);
      final routes = list
          .map((e) => CTBRoute.fromJson(e as Map<String, dynamic>))
          .toList();

      await CTBCacheService.cacheRoutes(routes);
      print('[CTB] Routes cached: ${routes.length}');
      return routes;
    } catch (e) {
      print('[CTB] Error getAllRoutes: $e');
      rethrow;
    }
  }
}

/// CTB Route model (fields based on Citybus route endpoint)
class CTBRoute {
  final String co; // company, expected 'CTB'
  final String route;
  final String origEn;
  final String origTc;
  final String origSc;
  final String destEn;
  final String destTc;
  final String destSc;

  CTBRoute({
    required this.co,
    required this.route,
    required this.origEn,
    required this.origTc,
    required this.origSc,
    required this.destEn,
    required this.destTc,
    required this.destSc,
  });

  factory CTBRoute.fromJson(Map<String, dynamic> json) {
    return CTBRoute(
      co: json['co']?.toString() ?? '',
      route: json['route']?.toString() ?? '',
      origEn: json['orig_en']?.toString() ?? '',
      origTc: json['orig_tc']?.toString() ?? '',
      origSc: json['orig_sc']?.toString() ?? '',
      destEn: json['dest_en']?.toString() ?? '',
      destTc: json['dest_tc']?.toString() ?? '',
      destSc: json['dest_sc']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'co': co,
      'route': route,
      'orig_en': origEn,
      'orig_tc': origTc,
      'orig_sc': origSc,
      'dest_en': destEn,
      'dest_tc': destTc,
      'dest_sc': destSc,
    };
  }

  @override
  String toString() => 'CTB $route: $origEn → $destEn';
}
