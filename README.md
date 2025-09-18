# MD 由 AI-Gen，懶得自己寫咁 q 鬼多，不過後面會補充返個人感想。

# 香港交通應用程式 / Hong Kong Transport App

一個功能豐富的香港交通資訊應用程式，提供港鐵和九巴的即時資訊、路線查詢和書籤功能。

A comprehensive Hong Kong transport information app providing real-time MTR and KMB information, route queries, and bookmark functionality.

## 功能特色 / Features

### 🚇 港鐵服務 / MTR Services

- **即時時刻表** / Real-time Schedule: 查看港鐵各線路的列車到達時間
- **多線車站支援** / Multi-line Station Support: 同站多線可動態新增切換，標題依所選線路正確顯示方向與預設終點
- **自動更新** / Auto Refresh: 對話框 15s 倒數自動重取（可於「更多資料操作」切換）
- **路線選擇** / Route Selection: 支援所有港鐵線路（港島線、荃灣線、觀塘線等）
- **車站資訊** / Station Information: 詳細的車站資料和時刻表
- **多語言支援** / Multi-language Support: 中文繁體和英文介面

### 🚌 九巴服務 / KMB Services

- **路線查詢** / Route Search: 搜尋九巴路線和車站資訊
- **即時到站時間** / Real-time Arrival: 查看巴士預計到達時間
- **路線詳情** / Route Details: 完整的路線和車站列表
- **書籤功能** / Bookmark Feature: 收藏常用路線和車站

### 📱 用戶介面 / User Interface

- **現代化設計** / Modern Design: 簡潔美觀的 Material Design 3 介面
- **直觀導航** / Intuitive Navigation: 底部導航欄與模式切換（含輕觸覺回饋）
- **響應式佈局** / Responsive Layout: 適配不同螢幕尺寸
- **觸覺反饋** / Haptic Feedback: 提供觸覺回饋增強用戶體驗

### ⭐ 書籤系統 / Bookmark System

- **智能收藏** / Smart Bookmarks: 收藏常用的港鐵和九巴路線（MTR 長按站點加入/移除；KMB 書籤可點擊查看 ETA）
- **分類管理** / Categorized Management: 分別管理港鐵和九巴書籤
- **快速存取** / Quick Access: 一鍵存取收藏的路線和車站
- **同步儲存** / Sync Storage: 本地儲存，無需網路連線

### 🚀 啟動與體驗 / Startup & UX

- **平台記憶** / Platform Memory: 記住你上次使用的模式（MTR/KMB），下次開啟自動套用
- **重設功能** / Reset: 在「菜單」頁可一鍵重設（清除書籤、KMB 快取並重新抓取資料）
- **開發者連結** / Developer Link: 透過對話框打開 GitHub 專案頁（使用手機預設瀏覽器）

### 🌐 多語言 / Localization

- **內建語言包** / Bundled: 使用 Flutter gen-l10n 與 ARB 檔，支援英文與繁體中文（香港）
- **自動語言對應** / Auto Mapping: 偵測裝置語言，若為中文（中國/台灣/香港/澳門或繁體腳本）自動套用 zh_HK，否則英文
- **手動切換** / Manual Switch: 在「菜單」頁可切換 English / 繁體中文 / 跟隨系統

## 技術特色 / Technical Features

### 🏗️ 架構設計 / Architecture

- **Flutter 框架** / Flutter Framework: 跨平台移動應用開發
- **模組化設計** / Modular Design: 清晰的代碼結構和組件分離
- **狀態管理** / State Management: 高效的狀態管理和數據流
- **API 整合** / API Integration: 整合港鐵和九巴官方 API

### 🔧 核心功能 / Core Features

- **即時數據** / Real-time Data: 從官方 API 獲取最新交通資訊
- **離線快取** / Offline Cache: 智能快取機制減少網路請求
- **錯誤處理** / Error Handling: 完善的錯誤處理和用戶提示（僅保留錯誤 Snackbar，移除成功提示）
- **性能優化** / Performance Optimization: 流暢的用戶體驗

## 安裝與使用 / Installation & Usage

### 環境要求 / Requirements

- Flutter SDK 3.0+
- Dart 3.0+
- Android Studio / VS Code
- iOS Simulator / Android Emulator

### 安裝步驟 / Installation Steps

1. **克隆專案** / Clone the project

```bash
git clone https://github.com/your-username/hk_transport_app.git
cd hk_transport_app
```

2. **安裝依賴** / Install dependencies

```bash
flutter pub get
```

3. **運行應用** / Run the app

```bash
flutter run
```

### 使用指南 / User Guide

#### 導航操作 / Navigation

- **點擊底部按鈕** / Tap bottom buttons: 切換到對應頁面
- **長按中間按鈕** / Long press middle button: 切換港鐵/九巴模式
- **點擊中間按鈕** / Tap middle button: 查看當前模式的內容

#### 書籤管理 / Bookmark Management

- **添加書籤** / Add bookmark: 在路線詳情頁面點擊書籤圖標
- **查看書籤** / View bookmarks: 點擊底部「收藏」按鈕
- **刪除書籤** / Remove bookmark: 在書籤頁面點擊刪除按鈕

## 專案結構 / Project Structure

```
lib/
├── components/                    # UI 組件 / UI Components
│   ├── bookmarks/                # 書籤相關組件 / Bookmark Components
│   ├── kmb/                     # 九巴相關組件 / KMB Components
│   ├── mtr/                     # 港鐵相關組件 / MTR Components
│   ├── menu/                    # 設定與資料操作 / Settings & Data Ops
│   ├── ui/                      # 共用 UI（含 bottom_nav_bar / splash）
├── scripts/                     # 服務和工具 / Services & Utilities
│   ├── bookmarks/              # 書籤服務 / Bookmarks
│   ├── kmb/                    # 九巴服務 / KMB services
│   ├── mtr/                    # 港鐵服務 / MTR services（含 mtr_data）
│   ├── locale/                 # 語言設定持久化 / Locale persistence
│   ├── theme/                  # 主題 / Themes
│   └── utils/                  # 工具 / Utilities
## 技術備註 / Technical Notes

1. **MTR 線路顏色集中管理**：請使用 `MTRData.getLineColor(lineCode)`，不要在組件內重複定義色票。
2. **MTR 預設終點（方向）**：`mtr_data.dart` 內每條線使用 `upDefaultDest`、`downDefaultDest`（陣列）定義方向預設終點；`defaultDest` 統一為 `[]` 以支援特殊案例。
3. **時間差格式化**：服務層已移除格式化函式，請於 UI 使用本地化字串（`mtrMinutes`、`mtrHours`、`mtrHoursMinutes`）。
4. **多線站台對話框**：每個新增線路區塊會傳入自身 `lineCode`，標題「往 / To」與預設終點會依該線正確顯示。
5. **Snackbar 策略**：只保留錯誤提示，成功操作不再彈出。
├── l10n/                        # 語言檔 / Localization ARB
│   ├── app_en.arb
│   ├── app_zh.arb
│   └── app_zh_HK.arb
└── main.dart                    # 應用入口 / App Entry Point
```

## 開發團隊 / Development Team

- **開發者** / Developer: rabb17
- **版本** / Version: 幾時正式 1.0?
- **更新日期** / Last Updated: 有 commit = 有更新

## 授權條款 / License

本專案採用 MIT 授權條款。詳情請參閱 [LICENSE](LICENSE) 檔案。

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## 貢獻指南 / Contributing

歡迎提交 Issue 和 Pull Request 來改善這個專案。

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/your-username/hk_transport_app/issues).

## 聯絡資訊 / Contact

如有任何問題或建議，請透過以下方式聯絡：

For questions or suggestions, please contact:

- **GitHub** / GitHub: [@your-username](https://github.com/your-username)

---

**感謝使用香港交通應用程式！** / **Thank you for using Hong Kong Transport App!**
