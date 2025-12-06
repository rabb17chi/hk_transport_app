/// Notification Service
///
/// Handles notification permissions and displays notifications for ETA tracking
/// 處理通知權限並顯示 ETA 追蹤通知

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'eta_tracking_channel';
  static const String _channelName = 'ETA Tracking';
  static const String _channelDescription =
      'Notifications for bus/train arrival times';

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    _channelId,
    _channelName,
    description: _channelDescription,
    importance: Importance.low, // Low importance for persistent notifications
    playSound: false,
    enableVibration: false,
  );

  bool _isInitialized = false;

  /// Initialize notification service
  /// 初始化通知服務
  Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      // Initialize Android settings
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      
      // Initialize iOS settings
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: false,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      final initialized = await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      if (initialized == false) {
        if (kDebugMode) {
          print('NotificationService: Failed to initialize');
        }
        return false;
      }

      // Create notification channel for Android
      await _notifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(_channel);

      _isInitialized = true;
      if (kDebugMode) {
        print('NotificationService: Initialized successfully');
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('NotificationService: Error initializing: $e');
      }
      return false;
    }
  }

  /// Request notification permission
  /// 請求通知權限
  Future<bool> requestPermission() async {
    try {
      if (Platform.isIOS) {
        // For iOS, use flutter_local_notifications permission request
        final iosImplementation = _notifications
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>();
        if (iosImplementation != null) {
          final result = await iosImplementation.requestPermissions(
            alert: true,
            badge: true,
            sound: false,
          );
          if (kDebugMode) {
            print('NotificationService: iOS permission result: $result');
          }
          return result ?? false;
        }
        return false;
      } else if (Platform.isAndroid) {
        // For Android 13+, request notification permission
        if (await Permission.notification.isDenied) {
          final status = await Permission.notification.request();
          return status.isGranted;
        }
        return await Permission.notification.isGranted;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('NotificationService: Error requesting permission: $e');
      }
      return false;
    }
  }

  /// Check if notification permission is granted
  /// 檢查通知權限是否已授予
  Future<bool> hasPermission() async {
    try {
      if (Platform.isIOS) {
        // For iOS, try checking via permission_handler first
        try {
          final status = await Permission.notification.status;
          if (status.isGranted) return true;
          if (status.isDenied) return false;
          // If status is undetermined, we need to request it
          return false;
        } catch (_) {
          // Fallback: assume not granted if we can't check
          return false;
        }
      } else if (Platform.isAndroid) {
        // For Android, use permission_handler
        final status = await Permission.notification.status;
        return status.isGranted;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('NotificationService: Error checking permission: $e');
      }
      return false;
    }
  }

  /// Show persistent notification with ETA information
  /// 顯示包含 ETA 資訊的持續通知
  Future<void> showETANotification({
    required String title,
    required String body,
    int notificationId = 1,
  }) async {
    if (!_isInitialized) {
      final initialized = await initialize();
      if (!initialized) return;
    }

    final hasPerm = await hasPermission();
    if (!hasPerm) {
      if (kDebugMode) {
        print('NotificationService: No permission to show notification');
      }
      return;
    }

    try {
      const androidDetails = AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.low,
        priority: Priority.low,
        ongoing: true, // Persistent notification
        autoCancel: false,
        showWhen: false,
        playSound: false,
        enableVibration: false,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: false,
        presentBadge: false,
        presentSound: false,
      );

      const details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.show(
        notificationId,
        title,
        body,
        details,
      );

      if (kDebugMode) {
        print('NotificationService: Notification shown: $title - $body');
      }
    } catch (e) {
      if (kDebugMode) {
        print('NotificationService: Error showing notification: $e');
      }
    }
  }

  /// Update existing notification
  /// 更新現有通知
  Future<void> updateETANotification({
    required String title,
    required String body,
    int notificationId = 1,
  }) async {
    await showETANotification(
      title: title,
      body: body,
      notificationId: notificationId,
    );
  }

  /// Cancel notification
  /// 取消通知
  Future<void> cancelNotification({int notificationId = 1}) async {
    try {
      await _notifications.cancel(notificationId);
      if (kDebugMode) {
        print('NotificationService: Notification cancelled');
      }
    } catch (e) {
      if (kDebugMode) {
        print('NotificationService: Error cancelling notification: $e');
      }
    }
  }

  /// Cancel all notifications
  /// 取消所有通知
  Future<void> cancelAllNotifications() async {
    try {
      await _notifications.cancelAll();
      if (kDebugMode) {
        print('NotificationService: All notifications cancelled');
      }
    } catch (e) {
      if (kDebugMode) {
        print('NotificationService: Error cancelling all notifications: $e');
      }
    }
  }

  /// Handle notification tap
  /// 處理通知點擊
  void _onNotificationTapped(NotificationResponse response) {
    if (kDebugMode) {
      print('NotificationService: Notification tapped: ${response.id}');
    }
    // You can navigate to a specific screen here if needed
    // 如果需要，可以在這裡導航到特定畫面
  }
}

