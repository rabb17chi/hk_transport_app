# MTR Schedule Service API 文檔

## 概述

`MTRScheduleService` 是一個專門處理港鐵實時列車時刻表的服務類，提供 API 調用、時間計算和數據處理功能。

## 主要功能

### 1. API 調用

- 調用 MTR 官方 API 獲取實時列車時刻表
- 支持所有港鐵線路和車站
- 自動處理 API 錯誤和異常

### 2. 時間計算

- 基於 GMT+8 時區計算時間差
- 自動處理跨日情況
- 提供多種時間格式顯示

### 3. 數據處理

- 解析 API 響應數據
- 提取上行/下行方向列車信息
- 計算列車到達時間差

## API 響應數據結構

### 基本結構

```json
{
  "curr_time": "2024-01-01 12:00:00",
  "data": {
    "TWL-CEN": {
      "UP": {
        "seq1": {
          "dest": "Tsuen Wan",
          "time": "12:05"
        },
        "seq2": {
          "dest": "Tsuen Wan",
          "time": "12:10"
        }
      },
      "DOWN": {
        "seq1": {
          "dest": "Central",
          "time": "12:03"
        }
      }
    }
  }
}
```

### 字段說明

- `curr_time`: 當前時間（GMT+8）
- `data`: 包含所有線路和車站的時刻表數據
- `lineCode-stationId`: 線路代碼和車站 ID 的組合鍵
- `UP`: 上行方向列車
- `DOWN`: 下行方向列車
- `seq1`, `seq2`, `seq3`, `seq4`: 列車序列號（通常 4 個，部分路線可能更多）
- `dest`: 列車終點站
- `time`: 列車到達時間

## 使用方法

### 1. 基本 API 調用

```dart
import 'mtr_schedule_service.dart';

// 獲取荃灣線中環站的時刻表
final response = await MTRScheduleService.getSchedule(
  lineCode: 'TWL',
  stationId: 'CEN',
);

if (response != null) {
  print('當前時間: ${response.currTime}');
  print('線路: ${response.lineCode}');
  print('車站: ${response.stationId}');
}
```

### 2. 獲取列車信息

```dart
// 獲取上行方向列車
final upTrains = response.getUpTrains();
for (final train in upTrains) {
  print('終點站: ${train.dest}');
  print('到達時間: ${train.time}');
  print('時間差: ${train.formattedTimeDifference}');
}

// 獲取下行方向列車
final downTrains = response.getDownTrains();
for (final train in downTrains) {
  print('終點站: ${train.dest}');
  print('到達時間: ${train.time}');
  print('時間差: ${train.formattedTimeDifference}');
}
```

### 3. 時間計算功能

```dart
// 計算時間差
final timeDiff = MTRScheduleService.calculateTimeDifference('12:30');
print('時間差: $timeDiff 分鐘');

// 格式化時間差顯示
final formatted = MTRScheduleService.formatTimeDifference(75);
print('格式化時間差: $formatted'); // 輸出: 1小時15分鐘

// 獲取當前GMT+8時間
final currentTime = MTRScheduleService.getCurrentGMT8Time();
print('當前時間: $currentTime');

// 格式化當前時間顯示
final formattedTime = MTRScheduleService.formatCurrentTime();
print('格式化當前時間: $formattedTime'); // 輸出: 12:30
```

### 4. 列車狀態檢查

```dart
for (final train in upTrains) {
  if (train.isArrivingSoon) {
    print('${train.dest} 即將到達！');
  } else if (train.isExpired) {
    print('${train.dest} 已過期');
  } else {
    print('${train.dest} ${train.formattedTimeDifference}後到達');
  }
}
```

## 錯誤處理

### API 調用失敗

```dart
final response = await MTRScheduleService.getSchedule(
  lineCode: 'TWL',
  stationId: 'CEN',
);

if (response == null) {
  print('API調用失敗，請檢查網絡連接或稍後重試');
}
```

### 時間計算錯誤

```dart
final timeDiff = MTRScheduleService.calculateTimeDifference('invalid_time');
if (timeDiff == -1) {
  print('時間格式錯誤');
}
```

## 注意事項

1. **時區處理**: 所有時間計算都基於 GMT+8 時區
2. **跨日處理**: 自動處理跨日的時間計算
3. **API 限制**: 請注意 API 調用頻率限制
4. **錯誤處理**: 建議在生產環境中添加適當的錯誤處理和重試機制
5. **數據驗證**: 建議在使用數據前進行驗證

## 示例：完整的時刻表顯示

```dart
Future<void> displaySchedule(String lineCode, String stationId) async {
  final response = await MTRScheduleService.getSchedule(
    lineCode: lineCode,
    stationId: stationId,
  );

  if (response == null) {
    print('無法獲取時刻表');
    return;
  }

  print('=== ${response.lineCode} ${response.stationId} 時刻表 ===');
  print('當前時間: ${response.currTime}');
  print('查詢時間: ${MTRScheduleService.formatCurrentTime()}');
  print('');

  // 上行方向
  print('上行方向 (UP):');
  final upTrains = response.getUpTrains();
  for (final train in upTrains) {
    if (!train.isExpired) {
      print('  ${train.dest} - ${train.time} (${train.formattedTimeDifference})');
    }
  }

  print('');

  // 下行方向
  print('下行方向 (DOWN):');
  final downTrains = response.getDownTrains();
  for (final train in downTrains) {
    if (!train.isExpired) {
      print('  ${train.dest} - ${train.time} (${train.formattedTimeDifference})');
    }
  }
}
```

## 更新日誌

- **v1.0.0**: 初始版本，支持基本 API 調用和時間計算
- 支持所有港鐵線路和車站
- 基於 GMT+8 時區的時間計算
- 自動處理跨日情況
- 提供多種時間格式顯示
