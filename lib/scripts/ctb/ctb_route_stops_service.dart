import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// CTB (Citybus) Route-Stops Service
///
/// Provides API to fetch the ordered list of stops for a given CTB route.
class CTBRouteStopsService {
  static const String baseUrl = 'https://rt.data.gov.hk/v2/transport/citybus';
  static const String _stopInfoPrefsKey = 'ctb_stop_info_v1';
  static Map<String, CTBStopInfo> _memoryStopCache = {};

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

  /// Load stop info from persistent cache if available
  static Future<CTBStopInfo?> getStopInfoFromCache(String stopId) async {
    // memory first
    final mem = _memoryStopCache[stopId];
    if (mem != null) return mem;

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_stopInfoPrefsKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      final Map<String, dynamic> map = json.decode(raw) as Map<String, dynamic>;
      final data = map[stopId];
      if (data is Map<String, dynamic>) {
        final info = CTBStopInfo.fromJson(data);
        _memoryStopCache[stopId] = info;
        return info;
      }
    } catch (_) {}
    return null;
  }

  /// Get stop info using cache; fetch and persist if missing
  static Future<CTBStopInfo> getStopInfoCached(String stopId) async {
    final cached = await getStopInfoFromCache(stopId);
    if (cached != null) return cached;
    final fetched = await getStopInfo(stopId);
    await cacheStopInfos([fetched]);
    return fetched;
  }

  /// Persist multiple stop infos
  static Future<void> cacheStopInfos(List<CTBStopInfo> infos) async {
    if (infos.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> map = {};
    final raw = prefs.getString(_stopInfoPrefsKey);
    if (raw != null && raw.isNotEmpty) {
      try {
        map = json.decode(raw) as Map<String, dynamic>;
      } catch (_) {}
    }
    for (final info in infos) {
      _memoryStopCache[info.stop] = info;
      map[info.stop] = info.toJson();
    }
    await prefs.setString(_stopInfoPrefsKey, json.encode(map));
  }

  /// Ensure a list of stopIds are cached (fetch only missing).
  static Future<void> ensureStopsCached(List<String> stopIds) async {
    if (stopIds.isEmpty) return;
    final missing = <String>[];
    for (final id in stopIds) {
      final mem = _memoryStopCache[id];
      if (mem != null) continue;
      final cached = await getStopInfoFromCache(id);
      if (cached == null) missing.add(id);
    }
    if (missing.isEmpty) return;
    // Fetch in parallel with modest concurrency
    final futures = missing.map((id) => getStopInfo(id));
    final results = await Future.wait(futures);
    await cacheStopInfos(results);
  }

  /// Fetch ETA for a specific stop and route (Citybus)
  static Future<List<CTBETA>> getETA({
    required String stopId,
    required String route,
  }) async {
    final url = Uri.parse('$baseUrl/eta/ctb/$stopId/$route');
    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw Exception('CTB ETA failed: ${response.statusCode}');
    }
    final body = json.decode(response.body) as Map<String, dynamic>;
    final List<dynamic> list = (body['data'] as List<dynamic>? ?? <dynamic>[]);
    return list.map((e) => CTBETA.fromJson(e as Map<String, dynamic>)).toList();
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

  Map<String, dynamic> toJson() => {
        'stop': stop,
        'name_tc': nameTc,
        'name_en': nameEn,
        'name_sc': nameSc,
      };
}

/// CTB ETA model with minutes calculation
class CTBETA {
  final String co;
  final String route;
  final String dir; // 'I' or 'O'
  final int seq;
  final String stop;
  final String destTc;
  final String destEn;
  final String eta; // ISO string with +08:00
  final int etaSeq;
  final String dataTimestamp;

  CTBETA({
    required this.co,
    required this.route,
    required this.dir,
    required this.seq,
    required this.stop,
    required this.destTc,
    required this.destEn,
    required this.eta,
    required this.etaSeq,
    required this.dataTimestamp,
  });

  factory CTBETA.fromJson(Map<String, dynamic> json) {
    return CTBETA(
      co: json['co']?.toString() ?? 'CTB',
      route: json['route']?.toString() ?? '',
      dir: json['dir']?.toString() ?? '',
      seq: int.tryParse(json['seq']?.toString() ?? '0') ?? 0,
      stop: json['stop']?.toString() ?? '',
      destTc: json['dest_tc']?.toString() ?? '',
      destEn: json['dest_en']?.toString() ?? '',
      eta: json['eta']?.toString() ?? '',
      etaSeq: int.tryParse(json['eta_seq']?.toString() ?? '0') ?? 0,
      dataTimestamp: json['data_timestamp']?.toString() ?? '',
    );
  }

  int get minutesUntilArrival {
    try {
      if (eta.trim().isEmpty) return -1;
      final etaTime = DateTime.parse(eta);
      final now = DateTime.now();
      final diff = etaTime.toUtc().difference(now.toUtc());
      return diff.inMinutes;
    } catch (_) {
      return -1;
    }
  }

  String get arrivalTimeStringZh {
    if (eta.trim().isEmpty) return '沒有資料';
    final m = minutesUntilArrival;
    if (m > 0) return '$m 分鐘';
    if (m == 0) return '即將到達';
    return '已過期';
  }

  String get arrivalTimeStringEn {
    if (eta.trim().isEmpty) return 'No Data';
    final m = minutesUntilArrival;
    if (m > 0) return '$m min';
    if (m == 0) return 'Arriving now';
    return 'Expired';
  }
}
