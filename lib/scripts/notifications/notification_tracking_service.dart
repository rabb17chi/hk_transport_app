/// Notification Tracking Service
///
/// Manages background tracking of ETA for bookmarked routes
/// 管理書籤路線的 ETA 背景追蹤

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'notification_service.dart';
import 'notification_preferences_service.dart';
import '../kmb/kmb_api_service.dart';
import '../ctb/ctb_route_stops_service.dart' show CTBRouteStopsService, CTBETA;
import '../mtr/mtr_schedule_service.dart';

class NotificationTrackingService {
  static final NotificationTrackingService _instance =
      NotificationTrackingService._internal();
  factory NotificationTrackingService() => _instance;
  NotificationTrackingService._internal();

  Timer? _updateTimer;
  bool _isTracking = false;
  final NotificationService _notificationService = NotificationService();

  /// Start tracking ETAs and updating notifications
  /// 開始追蹤 ETA 並更新通知
  Future<void> startTracking() async {
    if (_isTracking) {
      if (kDebugMode) {
        print('NotificationTrackingService: Already tracking');
      }
      return;
    }

    // Check permission first
    final hasPermission = await _notificationService.hasPermission();
    if (!hasPermission) {
      if (kDebugMode) {
        print('NotificationTrackingService: No notification permission');
      }
      return;
    }

    _isTracking = true;

    // Initial update
    await _updateNotifications();

    // Update every 30 seconds (better than every second for battery)
    // 每 30 秒更新一次（比每秒更新更省電）
    _updateTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _updateNotifications(),
    );

    if (kDebugMode) {
      print('NotificationTrackingService: Started tracking');
    }
  }

  /// Stop tracking ETAs
  /// 停止追蹤 ETA
  void stopTracking() {
    _isTracking = false;
    _updateTimer?.cancel();
    _updateTimer = null;
    _notificationService.cancelAllNotifications();
    if (kDebugMode) {
      print('NotificationTrackingService: Stopped tracking');
    }
  }

  /// Check if currently tracking
  /// 檢查是否正在追蹤
  bool get isTracking => _isTracking;

  /// Update notifications with current ETA data
  /// 使用當前 ETA 資料更新通知
  Future<void> _updateNotifications() async {
    if (!_isTracking) return;

    try {
      final trackedBookmarks = await NotificationPreferencesService
          .getTrackedBookmarks();
      final trackedMTRBookmarks = await NotificationPreferencesService
          .getTrackedMTRBookmarks();

      if (trackedBookmarks.isEmpty && trackedMTRBookmarks.isEmpty) {
        // No bookmarks to track, cancel notification
        await _notificationService.cancelNotification();
        return;
      }

      final List<String> etaLines = [];

      // Process bus bookmarks
      for (final bookmark in trackedBookmarks) {
        try {
          final isCTB = bookmark.operator.toUpperCase() == 'CTB';
          List<dynamic> etaData;

          if (isCTB) {
            final eta = await CTBRouteStopsService.getETA(
              stopId: bookmark.stopId,
              route: bookmark.route,
            );
            final filtered = eta
                .where((e) =>
                    e.dir.toUpperCase() == bookmark.bound.toUpperCase())
                .toList()
              ..sort((a, b) => a.etaSeq.compareTo(b.etaSeq));
            etaData = filtered;
          } else {
            etaData = await KMBApiService.getETA(
              bookmark.stopId,
              bookmark.route,
              bookmark.serviceType,
            );
          }

          if (etaData.isNotEmpty) {
            final firstETA = etaData.first;
            String etaText;
            String stopName;

            if (isCTB) {
              final ctbEta = firstETA as CTBETA;
              etaText = ctbEta.arrivalTimeStringZh;
              stopName = bookmark.stopNameTc.isNotEmpty
                  ? bookmark.stopNameTc
                  : bookmark.stopId;
            } else {
              final kmbEta = firstETA as KMBETA;
              etaText = kmbEta.getArrivalTimeString(null);
              stopName = bookmark.stopNameTc.isNotEmpty
                  ? bookmark.stopNameTc
                  : bookmark.stopId;
            }

            etaLines.add(
                '${bookmark.route} → $stopName: $etaText');
          }
        } catch (e) {
          if (kDebugMode) {
            print(
                'NotificationTrackingService: Error fetching ETA for ${bookmark.route}: $e');
          }
        }
      }

      // Process MTR bookmarks
      for (final bookmark in trackedMTRBookmarks) {
        try {
          final schedule = await MTRScheduleService.getSchedule(
            lineCode: bookmark.lineCode,
            stationId: bookmark.stationId,
          );

          if (schedule != null) {
            final trains = schedule.getUpTrains();
            if (trains.isNotEmpty) {
              final firstTrain = trains.first;
              final timeDiff = firstTrain.timeDifference ?? -1;
              String etaText;
              if (timeDiff > 0) {
                etaText = '$timeDiff 分鐘';
              } else if (timeDiff == 0) {
                etaText = '即將到達';
              } else {
                etaText = '已過期';
              }

              final stationName = bookmark.stationNameTc.isNotEmpty
                  ? bookmark.stationNameTc
                  : bookmark.stationId;

              etaLines.add('MTR $stationName: $etaText');
            }
          }
        } catch (e) {
          if (kDebugMode) {
            print(
                'NotificationTrackingService: Error fetching MTR schedule for ${bookmark.stationId}: $e');
          }
        }
      }

      if (etaLines.isEmpty) {
        await _notificationService.cancelNotification();
        return;
      }

      // Update notification
      final title = '🚌 到站時間 / Arrival Times';
      final body = etaLines.join('\n');

      await _notificationService.updateETANotification(
        title: title,
        body: body,
      );
    } catch (e) {
      if (kDebugMode) {
        print('NotificationTrackingService: Error updating notifications: $e');
      }
    }
  }

  /// Manually trigger an update
  /// 手動觸發更新
  Future<void> updateNow() async {
    await _updateNotifications();
  }
}

