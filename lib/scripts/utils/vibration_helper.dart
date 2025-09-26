/// 振動功能助手
///
/// 提供統一的振動功能，支持三個等級的振動強度
/// 減少代碼重複並提供一致的用戶體驗

import 'package:vibration/vibration.dart';
import 'settings_service.dart';

/// 振動等級枚舉
enum VibrationLevel {
  light, // 輕微振動 - 30ms
  medium, // 中等振動 - 50ms
  strong, // 強烈振動 - 80ms
}

class VibrationHelper {
  /// 振動時長映射
  static final Map<VibrationLevel, int> _vibrationDurations = {
    VibrationLevel.light: 30,
    VibrationLevel.medium: 50,
    VibrationLevel.strong: 80,
  };

  /// 觸發振動
  ///
  /// [level] 振動等級，默認為中等
  /// [customDuration] 自定義振動時長（毫秒），如果提供則忽略 level
  static Future<void> vibrate({
    VibrationLevel level = VibrationLevel.medium,
    int? customDuration,
  }) async {
    try {
      // Respect user setting
      if (!SettingsService.vibrationEnabledNotifier.value) {
        return;
      }
      // 檢查設備是否支持振動
      if (await Vibration.hasVibrator() == true) {
        // 使用自定義時長或根據等級獲取時長
        final duration = customDuration ?? _vibrationDurations[level]!;

        // 觸發振動
        await Vibration.vibrate(duration: duration);

        // 調試輸出
        print('振動觸發: ${level.name} (${duration}ms)');
      } else {
        print('設備不支持振動功能');
      }
    } catch (e) {
      print('振動功能錯誤: $e');
    }
  }

  /// 輕微振動 (30ms)
  /// 適用於：線路展開/收縮、輕微操作
  static Future<void> lightVibrate() async {
    await vibrate(level: VibrationLevel.light);
  }

  /// 中等振動 (50ms)
  /// 適用於：按鈕點擊、車站選擇、一般操作
  static Future<void> mediumVibrate() async {
    await vibrate(level: VibrationLevel.medium);
  }

  /// 強烈振動 (80ms)
  /// 適用於：重要操作、錯誤提示、確認操作
  static Future<void> strongVibrate() async {
    await vibrate(level: VibrationLevel.strong);
  }

  /// 自定義振動
  ///
  /// [duration] 振動時長（毫秒）
  static Future<void> customVibrate(int duration) async {
    await vibrate(customDuration: duration);
  }

  /// 檢查設備是否支持振動
  static Future<bool> hasVibrator() async {
    try {
      final result = await Vibration.hasVibrator();
      return result == true;
    } catch (e) {
      print('檢查振動功能錯誤: $e');
      return false;
    }
  }
}
