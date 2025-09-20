import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  // Storage keys for SharedPreferences
  // SharedPreferences 的儲存鍵值
  static const String _mtrReverseKey = 'mtr_reverse_stations_v1';
  static const String _mtrAutoRefreshKey = 'mtr_auto_refresh_v1';
  static const String _showSpecialRoutesKey = 'showSpecialRoutes';
  static const String _kmbLastUpdateKey = 'kmb_last_update_time';

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
}
