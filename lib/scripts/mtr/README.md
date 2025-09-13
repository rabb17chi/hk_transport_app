# MTR API 服務實現

## 概述

這個實現提供了完整的港鐵(MTR) API 服務，用於獲取實時列車時刻表信息。雖然目前 API 端點被禁用，但代碼已經準備好在 API 恢復時使用。

## 文件結構

```
lib/scripts/mtr/
├── mtr_api_service.dart      # 主要API服務
├── mtr_data.dart            # 車站和線路數據
├── mtr_api_example.dart     # 使用示例
└── README.md               # 本文檔

lib/components/mtr/
├── mtr_schedule_widget.dart # 時刻表顯示組件
└── mtr_screen.dart         # 更新的MTR主界面

lib/data/mtr/
└── line_summary.dart       # 線路摘要數據
```

## 主要功能

### 1. API 服務 (`mtr_api_service.dart`)

- **MTRApiService**: 主要 API 服務類

  - `getSchedule(lineCode, stationId)`: 獲取指定線路和車站的時刻表
  - `getMultipleSchedules()`: 批量獲取多個車站時刻表
  - `isValidLineCode()`: 驗證線路代碼
  - `isValidStationCode()`: 驗證車站代碼

- **MTRScheduleResponse**: API 響應模型

  - 包含完整的 API 響應數據
  - 錯誤處理和狀態檢查
  - 列車信息列表

- **MTRTrain**: 列車信息模型

  - 列車詳細信息
  - 到達時間計算
  - 多語言支持

- **MTRStationScheduleManager**: 緩存管理器
  - 本地緩存功能
  - 緩存過期處理
  - 緩存狀態管理

### 2. 數據模型 (`mtr_data.dart`)

- **MTRData**: 靜態數據存儲
  - 線路信息 (中英文名稱、顏色、代碼)
  - 車站信息 (中英文名稱、代碼、所屬線路)
  - 搜索和查詢功能

### 3. UI 組件 (`mtr_schedule_widget.dart`)

- **MTRScheduleWidget**: 時刻表顯示組件
  - 實時列車信息顯示
  - 錯誤處理和重試功能
  - 線路顏色指示器
  - 響應式設計

## 使用方法

### 基本使用

```dart
// 獲取金鐘站港島線時刻表
final schedule = await MTRApiService.getSchedule('ISL', 'ADM');

if (schedule.isSuccess) {
  for (final train in schedule.trains!) {
    print('列車: ${train.destinationTc} - ${train.arrivalTimeString}');
  }
} else {
  print('錯誤: ${schedule.errorMessage}');
}
```

### 使用緩存

```dart
// 使用緩存獲取時刻表
final schedule = await MTRStationScheduleManager.getCachedSchedule('ISL', 'ADM');
```

### 在 UI 中使用

```dart
MTRScheduleWidget(
  lineCode: 'ISL',
  stationId: 'ADM',
  stationNameTc: '金鐘',
  stationNameEn: 'Admiralty',
)
```

## API 端點

**當前狀態**: API 端點被禁用

- URL: `https://rt.data.gov.hk/v1/transport/mtr/getSchedule.php`
- 參數: `line=${lineCode}&sta=${stationId}`
- 錯誤: `NT-205: ITEM line is disabled in CMS`

## 線路代碼

| 代碼 | 中文名稱 | 英文名稱           | 顏色    |
| ---- | -------- | ------------------ | ------- |
| ISL  | 港島線   | Island Line        | #0066CC |
| TWL  | 荃灣線   | Tsuen Wan Line     | #E2231A |
| KTL  | 觀塘線   | Kwun Tong Line     | #00B04F |
| TKL  | 將軍澳線 | Tseung Kwan O Line | #8B4513 |
| EAL  | 東鐵線   | East Rail Line     | #53B7E8 |
| TML  | 屯馬線   | Tuen Ma Line       | #9A3B26 |
| SIL  | 南港島線 | South Island Line  | #B5BD00 |
| AEL  | 機場快線 | Airport Express    | #1C7670 |

## 車站代碼示例

| 代碼 | 中文名稱 | 英文名稱      | 線路 |
| ---- | -------- | ------------- | ---- |
| ADM  | 金鐘     | Admiralty     | ISL  |
| CEN  | 中環     | Central       | ISL  |
| TST  | 尖沙咀   | Tsim Sha Tsui | TWL  |
| MOK  | 旺角     | Mong Kok      | TWL  |

## 錯誤處理

API 服務包含完整的錯誤處理機制：

1. **網絡錯誤**: HTTP 請求失敗
2. **API 錯誤**: 服務器返回錯誤狀態
3. **數據錯誤**: JSON 解析失敗
4. **驗證錯誤**: 無效的線路或車站代碼

## 緩存機制

- **緩存時間**: 1 分鐘
- **緩存鍵**: `${lineCode}_${stationId}`
- **自動過期**: 超過緩存時間自動重新獲取
- **手動清除**: 支持手動清除緩存

## 未來改進

1. **更多功能**: 添加路線規劃、換乘信息等
2. **推送通知**: 列車延誤通知
3. **多語言**: 完整的多語言支持
