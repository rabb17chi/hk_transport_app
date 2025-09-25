import 'dart:convert';
import 'package:http/http.dart' as http;

/// CTB (Citybus) Route-Stops Service
///
/// Provides API to fetch the ordered list of stops for a given CTB route.
class CTBRouteStopsService {
  static const String baseUrl = 'https://rt.data.gov.hk/v2/transport/citybus';

  /// Fetch route stops for a specific CTB route and direction/bound.
  ///
  /// [route]: Route number, e.g. '1' or 'A11'
  /// [bound]: Direction code. Accepts 'I'/'inbound' or 'O'/'outbound'.
  ///
  /// Returns the ordered list of stops for the route.
  static Future<List<CTBRouteStop>> getRouteStops({
    required String route,
    required String bound,
  }) async {
    // NOTE: Endpoint shape may vary; will be confirmed and adjusted.
    // Common pattern for HK transport APIs: route-stop/{co}/{route}/{direction}
    final normalized = _normalizeBound(bound);
    final url = Uri.parse('$baseUrl/route-stop/ctb/$route/$normalized');

    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw Exception('CTB route-stops failed: ${response.statusCode}');
    }

    final body = json.decode(response.body) as Map<String, dynamic>;
    final List<dynamic> list = (body['data'] as List<dynamic>? ?? <dynamic>[]);

    return list
        .map((e) => CTBRouteStop.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static String _normalizeBound(String bound) {
    final b = bound.trim().toUpperCase();
    if (b == 'I' || b == 'INBOUND') return 'inbound';
    if (b == 'O' || b == 'OUTBOUND') return 'outbound';
    return b; // passthrough if already in expected shape
  }

  /// Fetch CTB stop information by stop id
  static Future<CTBStopInfo> getStopInfo(String stopId) async {
    final url = Uri.parse('$baseUrl/stop/$stopId');
    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw Exception('CTB stop info failed: ${response.statusCode}');
    }
    final body = json.decode(response.body) as Map<String, dynamic>;
    final data = body['data'] as Map<String, dynamic>? ?? <String, dynamic>{};
    return CTBStopInfo.fromJson(data);
  }
}

/// CTB Route Stop model
class CTBRouteStop {
  final String route;
  final String bound; // 'I'/'O' or 'inbound'/'outbound' depending on API
  final String stop; // stop id
  final int seq; // order in route

  // Optional stop names if the API includes them; may be empty otherwise
  final String stopNameEn;
  final String stopNameTc;
  final String stopNameSc;

  CTBRouteStop({
    required this.route,
    required this.bound,
    required this.stop,
    required this.seq,
    this.stopNameEn = '',
    this.stopNameTc = '',
    this.stopNameSc = '',
  });

  factory CTBRouteStop.fromJson(Map<String, dynamic> json) {
    return CTBRouteStop(
      route: json['route']?.toString() ?? '',
      bound: json['bound']?.toString() ?? json['dir']?.toString() ?? '',
      stop: json['stop']?.toString() ?? '',
      seq: int.tryParse(json['seq']?.toString() ?? '0') ?? 0,
      stopNameEn: json['stop_name_en']?.toString() ?? '',
      stopNameTc: json['stop_name_tc']?.toString() ?? '',
      stopNameSc: json['stop_name_sc']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'route': route,
      'bound': bound,
      'stop': stop,
      'seq': seq,
      'stop_name_en': stopNameEn,
      'stop_name_tc': stopNameTc,
      'stop_name_sc': stopNameSc,
    };
  }

  @override
  String toString() {
    return 'CTBRouteStop(route=$route, bound=$bound, seq=$seq, stop=$stop)';
  }
}

/// CTB Stop info model
class CTBStopInfo {
  final String stop;
  final String nameTc;
  final String nameEn;
  final String nameSc;

  CTBStopInfo({
    required this.stop,
    required this.nameTc,
    required this.nameEn,
    required this.nameSc,
  });

  factory CTBStopInfo.fromJson(Map<String, dynamic> json) {
    return CTBStopInfo(
      stop: json['stop']?.toString() ?? '',
      nameTc: json['name_tc']?.toString() ?? '',
      nameEn: json['name_en']?.toString() ?? '',
      nameSc: json['name_sc']?.toString() ?? '',
    );
  }
}
