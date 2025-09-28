# 響應式縮放指南 (Responsive Scaling Guide)

## 問題：應該選擇哪種縮放策略？

### 方法 1：以大螢幕為基準，小螢幕縮小

```dart
// 設定大螢幕的字體大小
final baseFontSize = 16.0; // 大螢幕基準
final responsiveFontSize = baseFontSize * (devicePixelRatio < 1.5 ? 0.8 : 1.0);
```

**優點：**

- 大螢幕設備有最佳的可讀性
- 適合高密度顯示屏

**缺點：**

- 小螢幕設備可能文字過小
- 在小螢幕上可能影響可讀性

### 方法 2：以正常螢幕為基準，大螢幕放大 ⭐ **推薦**

```dart
// 設定正常螢幕的字體大小
final baseFontSize = 12.0; // 正常螢幕基準
final responsiveFontSize = baseFontSize * (devicePixelRatio / referenceScale);
```

**優點：**

- 更好的可讀性平衡
- 小螢幕保持適當大小，避免擠壓
- 更符合設計原則
- 更好的空間利用

**缺點：**

- 大螢幕設備可能文字相對較大

## 建議：使用方法 2（以正常螢幕為基準）

### 原因分析：

1. **更好的可讀性**：小螢幕保持較小字體，避免文字過大擠壓界面
2. **更符合設計原則**：正常螢幕是大多數用戶的標準體驗
3. **更好的空間利用**：小螢幕設備通常屏幕空間有限，需要更緊湊的布局
4. **更直觀的設計**：設計師通常以標準螢幕為基準進行設計

## 實際使用示例

### 基本用法（推薦）

```dart
Text(
  'Hello World',
  style: TextStyle(
    fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16.0),
    // 使用預設策略：normalScreenBased
  ),
)
```

### 自定義策略

```dart
// 以大螢幕為基準
Text(
  'Large Screen Based',
  style: TextStyle(
    fontSize: ResponsiveUtils.getResponsiveFontSize(
      context,
      16.0,
      strategy: ScalingStrategy.largeScreenBased,
    ),
  ),
)

// 以小螢幕為基準
Text(
  'Small Screen Based',
  style: TextStyle(
    fontSize: ResponsiveUtils.getResponsiveFontSize(
      context,
      16.0,
      strategy: ScalingStrategy.smallScreenBased,
    ),
  ),
)
```

### 自動推薦策略

```dart
final recommendedStrategy = ResponsiveUtils.getRecommendedStrategy(context);

Text(
  'Auto Recommended',
  style: TextStyle(
    fontSize: ResponsiveUtils.getResponsiveFontSize(
      context,
      16.0,
      strategy: recommendedStrategy,
    ),
  ),
)
```

## 縮放策略比較

| 策略                | 基準螢幕 | 小螢幕效果 | 大螢幕效果 | 適用場景             |
| ------------------- | -------- | ---------- | ---------- | -------------------- |
| `normalScreenBased` | 1.45x    | 縮小       | 放大       | **推薦**：大多數應用 |
| `largeScreenBased`  | 2.0x     | 大幅縮小   | 保持原大小 | 高密度顯示屏優先     |
| `smallScreenBased`  | 1.0x     | 保持原大小 | 大幅放大   | 小螢幕設備優先       |

## 實際縮放效果示例

假設基準字體大小為 12px：

### normalScreenBased（推薦）

- 1.0x 設備：`12 * (1.0 / 1.45) = 8.28px`
- 1.45x 設備：`12 * (1.45 / 1.45) = 12px`（基準）
- 2.0x 設備：`12 * (2.0 / 1.45) = 16.55px`

### largeScreenBased

- 1.0x 設備：`12 * (1.0 / 2.0) = 6px`
- 1.45x 設備：`12 * (1.45 / 2.0) = 8.7px`
- 2.0x 設備：`12 * 1.0 = 12px`（基準）

### smallScreenBased

- 1.0x 設備：`12 * 1.0 = 12px`（基準）
- 1.45x 設備：`12 * (1.45 / 1.0) = 17.4px`
- 2.0x 設備：`12 * (2.0 / 1.0) = 24px`

## 結論

**建議使用 `normalScreenBased` 策略**，因為它：

- 提供最佳的整體用戶體驗
- 在各種設備上都有良好的可讀性
- 符合大多數應用的設計需求
- 是 ResponsiveUtils 的預設策略

如果您的應用有特殊需求（如主要面向高密度顯示屏），可以考慮使用其他策略。
