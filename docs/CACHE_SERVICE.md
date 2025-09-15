### KMB Cache Service — Technical Guide (EN) / 使用手冊（繁體中文）

---

## Overview / 簡介

- EN: `lib/scripts/kmb_cache_service.dart` provides an on-device cache for KMB routes, stops, and per-route stop lists. It uses SharedPreferences (key–value storage), not a database. Caching reduces network calls and improves performance while keeping data reasonably fresh via timestamps.
- 中文：`lib/scripts/kmb_cache_service.dart` 在裝置本地快取九巴的「路線」、 「車站」、以及「每條路線的站序」。採用 SharedPreferences（鍵值儲存），非資料庫。透過快取與時間戳記（TTL），減少網路請求並提升效能。

## Goals / 目標

- EN:
  - Reduce API latency and calls
  - Provide offline-read resilience (when previously cached)
  - Simple invalidation through timestamps
- 中文：
  - 降低 API 延遲與請求次數
  - 提供離線（已快取）瀏覽能力
  - 以時間戳記進行簡易失效與更新

## Data Model & Keys / 資料模型與鍵名

- EN: All values are stored as JSON strings plus integer timestamps.
- 中文：所有資料以 JSON 字串與整數時間戳記儲存。

- Routes / 路線

  - Key: `kmb_routes`
  - Timestamp: `kmb_routes_timestamp`
  - Type: `List<KMBRoute>` serialized to JSON

- Stops / 車站

  - Key: `kmb_stops`
  - Timestamp: `kmb_stops_timestamp`
  - Type: `List<KMBStop>` serialized to JSON

- Route Stops (per route/bound/serviceType) / 路線站序（依路線/方向/服務類型）
  - Data Key: `kmb_route_stops_{route}_{bound}_{serviceType}`
  - Timestamp Key: `kmb_route_stops_timestamp_{route}_{bound}_{serviceType}`
  - Type: `List<KMBRouteStop>` serialized to JSON

## Core API / 核心介面

- EN:
  - `getCachedRoutes() → Future<List<KMBRoute>?>`
  - `getCachedStops() → Future<List<KMBStop>?>`
  - `getCachedRouteStops(route, bound, serviceType) → Future<List<KMBRouteStop>?>`
  - `cacheRoutes(routes)`, `cacheStops(stops)`, `cacheRouteStops(...)`
  - `clearCache()` clears top-level routes/stops keys and their timestamps
- 中文：
  - `getCachedRoutes()` / `getCachedStops()` / `getCachedRouteStops(...)` 取得快取資料
  - `cacheRoutes(...)` / `cacheStops(...)` / `cacheRouteStops(...)` 寫入快取
  - `clearCache()` 清除「路線/車站」的主要快取鍵與時間戳記

Example / 範例：

```dart
final routes = await KMBCacheService.getCachedRoutes();
if (routes == null) {
  // fetch from API then cache
}
```

## TTL & Validation / 存活時間與驗證

- EN:
  - Cache duration: 7 days (milliseconds) in `_cacheDurationMs`
  - Validation via `_isCacheValid(timestamp)`
  - If invalid or missing, fetch from API and overwrite cache
- 中文：
  - 預設快取存活 7 天（`_cacheDurationMs`）
  - 以 `_isCacheValid(timestamp)` 驗證是否過期
  - 若資料不存在或過期，從 API 重新抓取並覆蓋快取

## Reset Behavior / 重設行為

- EN: The Menu “Reset App” removes `kmb_routes`, `kmb_stops`, their timestamps, and scans for all per-route-stop keys by prefix to remove them as well. It then optionally prefetches routes/stops.
- 中文：「重設應用」會刪除 `kmb_routes`、`kmb_stops` 及其時間戳記，並透過鍵名前綴掃描，移除所有「路線站序」相關鍵值。之後可選擇重新抓取路線與車站以預先填充快取。

## Why SharedPreferences? / 為何採用 SharedPreferences？

- EN:
  - Simple, dependency-light, great for small-to-medium JSON payloads
  - Good enough for read-mostly caches
- 中文：
  - 輕量、簡單、不需額外資料庫依賴
  - 適合讀多寫少的中小型 JSON 快取

## When to consider a local DB (sqflite/Hive) / 何時應轉為本地資料庫

- EN:
  - Large datasets or heavy querying (e.g., filtered/partial reads)
  - Need per-row TTL, indices, pagination, or predictable storage growth
- 中文：
  - 資料量大或需要複雜查詢（篩選／分頁／部分更新）
  - 需要更精細的 TTL、索引與成長控制

Suggested sqflite schema / 建議 sqflite 結構：

```
TABLE kmb_routes(route, bound, service_type, orig_tc, dest_tc, updated_at, PRIMARY KEY(route,bound,service_type))
TABLE kmb_stops(stop PRIMARY KEY, name_tc, lat, long, updated_at)
TABLE kmb_route_stops(route, bound, service_type, seq, stop, updated_at, PRIMARY KEY(route,bound,service_type,seq))
TABLE meta(key PRIMARY KEY, value)
```

## Privacy & Storage / 私隱與儲存

- EN:
  - Stores only public transit data (no personal data)
  - Lives in app sandbox storage and is cleared on uninstall or via reset
- 中文：
  - 僅儲存公共運輸資料（無個資）
  - 資料存於 App 沙盒，移除 App 或在「重設」後即清空

## Troubleshooting / 疑難排解

- EN:
  - Stale data: call reset, or reduce TTL and rebuild
  - Key bloat (many route-stops): use reset, or consider sqflite/Hive
  - Analyzer warnings: ensure JSON encode/decode types match models
- 中文：
  - 資料過舊：使用重設，或縮短 TTL 後重新建置
  - 鍵值過多（大量路線站序）：建議改用 sqflite/Hive
  - 程式碼警告：確保 JSON 型別與模型一致

## Related Files / 相關檔案

- `lib/scripts/kmb_cache_service.dart` — cache logic and keys
- `lib/scripts/kmb_api_service.dart` — API fetching that populates cache
- `lib/components/menu.dart` — includes manual refresh and full reset actions
