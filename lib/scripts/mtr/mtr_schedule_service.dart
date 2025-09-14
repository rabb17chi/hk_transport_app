/// MTR Schedule Service
///
/// 處理MTR實時列車時刻表API調用和時間計算
/// 支持GMT+8時區時間計算

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'mtr_data.dart';

class MTRScheduleService {
  static const String _baseUrl =
      'https://rt.data.gov.hk/v1/transport/mtr/getSchedule.php';

  /// 調用MTR API獲取列車時刻表
  static Future<MTRScheduleResponse?> getSchedule({
    required String lineCode,
    required String stationId,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl?line=$lineCode&sta=$stationId');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return MTRScheduleResponse.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  /// 計算時間差（分鐘）
  static int calculateTimeDifference(String arrivalTime) {
    try {
      // 解析API返回的完整日期時間格式 (YYYY-MM-DD HH:MM:SS)
      // API返回的時間已經是GMT+8時區，直接解析即可
      final arrivalDateTime = DateTime.parse(arrivalTime);

      // 獲取當前GMT+8時間（本地時間）
      final now = DateTime.now();

      // 計算時間差（分鐘）
      final difference = arrivalDateTime.difference(now).inMinutes;

      return difference;
    } catch (e) {
      return -1;
    }
  }

  /// 格式化時間差顯示
  static String formatTimeDifference(int minutes) {
    if (minutes < 0) return '時間錯誤';
    if (minutes == 0) return '即將到達';
    if (minutes < 60) return '${minutes}分鐘';

    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    if (remainingMinutes == 0) {
      return '${hours}小時';
    } else {
      return '${hours}小時${remainingMinutes}分鐘';
    }
  }

  /// 獲取當前GMT+8時間
  static DateTime getCurrentGMT8Time() {
    return DateTime.now();
  }

  /// 格式化當前時間顯示
  static String formatCurrentTime() {
    final now = getCurrentGMT8Time();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }
}

/// MTR API響應數據模型
class MTRScheduleResponse {
  final String? currTime;
  final Map<String, dynamic>? data;
  final String? lineCode;
  final String? stationId;

  MTRScheduleResponse({
    this.currTime,
    this.data,
    this.lineCode,
    this.stationId,
  });

  factory MTRScheduleResponse.fromJson(Map<String, dynamic> json) {
    // 從data中提取lineCode和stationId
    String? extractedLineCode;
    String? extractedStationId;

    if (json['data'] is Map<String, dynamic>) {
      final data = json['data'] as Map<String, dynamic>;
      if (data.isNotEmpty) {
        final key = data.keys.first; // 例如 "SIL-LET"
        final parts = key.split('-');
        if (parts.length >= 2) {
          extractedLineCode = parts[0];
          extractedStationId = parts[1];
        }
      }
    }

    return MTRScheduleResponse(
      currTime: json['curr_time']?.toString(),
      data: json['data'] as Map<String, dynamic>?,
      lineCode: extractedLineCode,
      stationId: extractedStationId,
    );
  }

  /// 獲取指定方向的列車信息
  List<TrainInfo> getTrainsForDirection(String direction) {
    if (data == null) return [];

    final key = '${lineCode}-${stationId}';
    final stationData = data![key];

    if (stationData == null || stationData[direction] == null) return [];

    final directionData = stationData[direction];
    final trains = <TrainInfo>[];

    // 處理數組格式的數據
    if (directionData is List) {
      for (final trainData in directionData) {
        if (trainData is Map<String, dynamic>) {
          trains.add(TrainInfo.fromJson(trainData));
        }
      }
    }

    return trains;
  }

  /// 獲取上行方向列車
  List<TrainInfo> getUpTrains() {
    return getTrainsForDirection('UP');
  }

  /// 獲取下行方向列車
  List<TrainInfo> getDownTrains() {
    return getTrainsForDirection('DOWN');
  }
}

/// 列車信息數據模型
class TrainInfo {
  final String? dest;
  final String? time;
  final int? timeDifference; // 計算出的時間差（分鐘）
  final String? formattedTimeDifference; // 格式化的時間差顯示
  final String? destNameTc; // 終點站中文名稱
  final String? destNameEn; // 終點站英文名稱

  TrainInfo({
    this.dest,
    this.time,
    this.timeDifference,
    this.formattedTimeDifference,
    this.destNameTc,
    this.destNameEn,
  });

  factory TrainInfo.fromJson(Map<String, dynamic> json) {
    final time = json['time']?.toString();
    final timeDifference =
        time != null ? MTRScheduleService.calculateTimeDifference(time) : -1;

    // 獲取車站名稱
    final destId = json['dest']?.toString();
    String? destNameTc;
    String? destNameEn;

    if (destId != null) {
      final stationData = MTRData.getStationData(destId);
      if (stationData != null) {
        destNameTc = stationData['nameTc']?.toString();
        destNameEn = stationData['fullName']?.toString();
      }
    }

    return TrainInfo(
      dest: destId,
      time: time,
      timeDifference: timeDifference,
      formattedTimeDifference: timeDifference >= 0
          ? MTRScheduleService.formatTimeDifference(timeDifference)
          : '時間錯誤',
      destNameTc: destNameTc,
      destNameEn: destNameEn,
    );
  }

  /// 檢查列車是否即將到達（5分鐘內）
  bool get isArrivingSoon =>
      timeDifference != null && timeDifference! >= 0 && timeDifference! <= 5;

  /// 檢查列車是否已過期
  bool get isExpired => timeDifference != null && timeDifference! < 0;
}
