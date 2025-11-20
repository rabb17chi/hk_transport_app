import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  // Storage keys for SharedPreferences
  // SharedPreferences 的儲存鍵值
  static const String _mtrReverseKey = 'mtr_reverse_stations_v1';
  static const String _mtrAutoRefreshKey = 'mtr_auto_refresh_v1';
  static const String _showSpecialRoutesKey = 'showSpecialRoutes';
  static const String _kmbLastUpdateKey = 'kmb_last_update_time';
  static const String _displayBusFullNameKey = 'display_bus_full_name_v1';
  static const String _vibrationEnabledKey = 'vibration_enabled_v1';
  static const String _showSubtitleKey = 'show_subtitle_v1';
  static const String _openAppAnimationEnabledKey =
      'open_app_animation_enabled_v1';

  // MTR station order: true = reverse order, false = normal order
  // MTR 車站順序：true = 反向順序，false = 正常順序
  // Default: reverse order enabled / 預設：啟用反向順序
  static final ValueNotifier<bool> mtrReverseStationsNotifier =
      ValueNotifier<bool>(true);

  // MTR auto-refresh: true = enabled, false = disabled
  // MTR 自動刷新：true = 啟用，false = 停用
  // Default: auto-refresh disabled / 預設：停用自動刷新
  static final ValueNotifier<bool> mtrAutoRefreshNotifier =
      ValueNotifier<bool>(false);

  // KMB special routes visibility: true = show special routes (service types 2,5), false = hide
  // KMB 特別班次可見性：true = 顯示特別班次（服務類型 2,5），false = 隱藏
  // Default: special routes hidden / 預設：隱藏特別班次
  static final ValueNotifier<bool> showSpecialRoutesNotifier =
      ValueNotifier<bool>(false);

  // KMB data last update timestamp: null = never updated, DateTime = last update time
  // KMB 資料最後更新時間戳：null = 從未更新，DateTime = 最後更新時間
  // Default: never updated / 預設：從未更新
  static final ValueNotifier<DateTime?> kmbLastUpdateNotifier =
      ValueNotifier<DateTime?>(null);

  // Display bus full names (with stop id/code): true = show full, false = shorten
  // 顯示完整巴士站名（包含代碼）：true = 顯示完整，false = 簡化
  static final ValueNotifier<bool> displayBusFullNameNotifier =
      ValueNotifier<bool>(false);

  // Vibration enabled: true = vibrate on interactions, false = no vibration
  // 震動開關：true = 啟用震動，false = 關閉震動
  // Default: enabled
  static final ValueNotifier<bool> vibrationEnabledNotifier =
      ValueNotifier<bool>(true);

  // Show subtitle: true = show station subtitle, false = hide subtitle
  // 顯示副標題：true = 顯示車站副標題，false = 隱藏副標題
  // Default: disabled
  static final ValueNotifier<bool> showSubtitleNotifier =
      ValueNotifier<bool>(false);

  // Open-app animation: true = fade animation when entering app, false = jump directly
  // 開啟動畫：true = 進入應用時顯示淡入動畫，false = 直接進入
  static final ValueNotifier<bool> openAppAnimationEnabledNotifier =
      ValueNotifier<bool>(true);

  // Load all settings from SharedPreferences on app startup
  // 在應用程式啟動時從 SharedPreferences 載入所有設定
  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    // Load MTR reverse stations setting
    // 載入 MTR 反向車站設定
    final value =
        prefs.getBool(_mtrReverseKey) ?? true; // Default to true / 預設為 true
    mtrReverseStationsNotifier.value = value;

    // Load MTR auto-refresh setting
    // 載入 MTR 自動刷新設定
    final autoRefresh = prefs.getBool(_mtrAutoRefreshKey) ??
        false; // Default to false / 預設為 false
    mtrAutoRefreshNotifier.value = autoRefresh;

    // Load KMB special routes visibility setting
    // 載入 KMB 特別班次可見性設定
    final showSpecialRoutes = prefs.getBool(_showSpecialRoutesKey) ?? false;
    showSpecialRoutesNotifier.value = showSpecialRoutes;

    // Load KMB last update time
    // 載入 KMB 最後更新時間
    final lastUpdateMillis = prefs.getInt(_kmbLastUpdateKey);
    if (lastUpdateMillis != null) {
      kmbLastUpdateNotifier.value =
          DateTime.fromMillisecondsSinceEpoch(lastUpdateMillis);
    }

    // Load Display Bus Full Name setting
    final showFull = prefs.getBool(_displayBusFullNameKey) ?? false;
    displayBusFullNameNotifier.value = showFull;

    // Load vibration enabled
    final vibrationEnabled = prefs.getBool(_vibrationEnabledKey) ?? true;
    vibrationEnabledNotifier.value = vibrationEnabled;

    // Load show subtitle setting
    final showSubtitle = prefs.getBool(_showSubtitleKey) ?? false;
    showSubtitleNotifier.value = showSubtitle;

    // Load open-app animation setting
    final allowAnimation =
        prefs.getBool(_openAppAnimationEnabledKey) ?? true;
    openAppAnimationEnabledNotifier.value = allowAnimation;
  }

  // Set MTR station order preference
  // 設定 MTR 車站順序偏好
  // [value] true = reverse order, false = normal order
  // [value] true = 反向順序，false = 正常順序
  static Future<void> setMtrReverseStations(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_mtrReverseKey, value);
    mtrReverseStationsNotifier.value = value;
  }

  // Set MTR auto-refresh preference
  // 設定 MTR 自動刷新偏好
  // [value] true = enable auto-refresh, false = disable
  // [value] true = 啟用自動刷新，false = 停用
  static Future<void> setMtrAutoRefresh(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_mtrAutoRefreshKey, value);
    mtrAutoRefreshNotifier.value = value;
  }

  // Set KMB special routes visibility preference
  // 設定 KMB 特別班次可見性偏好
  // [value] true = show special routes (service types 2,5), false = hide
  // [value] true = 顯示特別班次（服務類型 2,5），false = 隱藏
  static Future<void> setShowSpecialRoutes(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_showSpecialRoutesKey, value);
    showSpecialRoutesNotifier.value = value;
  }

  // Update KMB data last update timestamp to current time
  // 將 KMB 資料最後更新時間戳更新為當前時間
  // Called when KMB data is successfully refreshed
  // 在 KMB 資料成功刷新時調用
  static Future<void> updateKMBLastUpdateTime() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    await prefs.setInt(_kmbLastUpdateKey, now.millisecondsSinceEpoch);
    kmbLastUpdateNotifier.value = now;
  }

  // Set display bus full name preference
  // 設定是否顯示完整巴士站名
  static Future<void> setDisplayBusFullName(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_displayBusFullNameKey, value);
    displayBusFullNameNotifier.value = value;
  }

  // Set vibration enabled preference
  static Future<void> setVibrationEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_vibrationEnabledKey, value);
    vibrationEnabledNotifier.value = value;
  }

  // Set show subtitle preference
  // 設定是否顯示副標題
  static Future<void> setShowSubtitle(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_showSubtitleKey, value);
    showSubtitleNotifier.value = value;
  }

  // Set open-app animation preference
  // 設定是否顯示開啟動畫
  static Future<void> setOpenAppAnimationEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_openAppAnimationEnabledKey, value);
    openAppAnimationEnabledNotifier.value = value;
  }
}
