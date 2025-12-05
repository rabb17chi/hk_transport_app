// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '香港交通應用';

  @override
  String get menuTitle => '菜單';

  @override
  String get menuTheme => '主題';

  @override
  String get menuThemeSubtitle => '亮/暗（即將推出）';

  @override
  String get menuStyle => '風格';

  @override
  String get menuStyleSubtitle => '字體、顏色、大小（即將推出）';

  @override
  String get menuUpdateKMB => '手動更新巴士資料';

  @override
  String get menuRefresh => '刷新';

  @override
  String get menuReset => '重設應用（清除資料與偏好）';

  @override
  String get menuTerms => '服務條款';

  @override
  String get menuTermsSubtitle => '查看條款與私隱（即將推出）';

  @override
  String get menuDevLinks => '開發者連結';

  @override
  String get menuDevLinksSubtitle => 'GitHub 專案頁';

  @override
  String get menuDataOpsTitle => '更多資料操作';

  @override
  String get dataOpsSpecialToggle => '（九巴）顯示特別班次';

  @override
  String get dataOpsDisplayBusFullName => '顯示巴士完整名稱（站碼）';

  @override
  String get dataOpsRefreshKMB => '手動更新巴士資料';

  @override
  String get dataOpsRefreshNow => '立即更新';

  @override
  String dataOpsLastUpdate(Object time) {
    return '最後更新：$time';
  }

  @override
  String get dataOpsNeverUpdated => '從未更新';

  @override
  String get menuTutorial => 'APP使用教程';

  @override
  String get dataOpsMtrReverse => '反轉港鐵站序';

  @override
  String get dataOpsMtrAutoRefresh => '自動更新港鐵班次時間';

  @override
  String get dataOpsOpenAppAnimation => '開屏動畫';

  @override
  String get navBookmarks => '收藏';

  @override
  String get navSettings => '設定';

  @override
  String get tabBus => '巴士';

  @override
  String get tabMTR => '港鐵';

  @override
  String get emptyTitle => '暫未有收藏的路線';

  @override
  String get emptyInstructionAction => '長按站名';

  @override
  String get emptyInstructionSuffix => '以加入收藏';

  @override
  String get toWord => '往';

  @override
  String get etaEmpty => '暫無到站時間';

  @override
  String get close => '關閉';

  @override
  String get errorLoadBookmarks => '載入書籤時發生錯誤';

  @override
  String get etaLoadFailed => '載入 ETA 失敗';

  @override
  String get mtrEmptyTitle => '沒有港鐵書籤';

  @override
  String get mtrEmptySubtitle => '港鐵車站可加入收藏';

  @override
  String get longPress => '長按';

  @override
  String get mtrNoTrainInfo => '暫無列車信息';

  @override
  String get mtrOtherLines => '其他線路';

  @override
  String get mtrUpdateFailed => '無法更新時刻表，請稍後重試';

  @override
  String get mtrUpdateError => '更新失敗';

  @override
  String get mtrRefreshing => '刷新';

  @override
  String get mtrUpDirection => '上行方向';

  @override
  String get mtrDownDirection => '下行方向';

  @override
  String get mtrUpdating => '正在更新時刻表...';

  @override
  String get mtrClose => '關閉';

  @override
  String get mtrRefresh => '刷新';

  @override
  String get mtrUnknownLine => '未知線路';

  @override
  String get mtrTimeError => '時間錯誤';

  @override
  String get mtrArrivingSoon => '即將到達';

  @override
  String get mtrMinutes => '分鐘';

  @override
  String get mtrHours => '小時';

  @override
  String mtrHoursMinutes(Object hours, Object minutes) {
    return '$hours小時$minutes分鐘';
  }

  @override
  String get timetableUnavailable => '無法獲取時刻表，請稍後重試';

  @override
  String get removeBookmarkSuccess => '已移除書籤';

  @override
  String get removeBookmarkError => '移除書籤時發生錯誤';

  @override
  String get etaSeqPrefix => '第 ';

  @override
  String get etaSeqSuffix => ' 班';

  @override
  String get devLinksDialogTitle => '開發者連結';

  @override
  String get devLinksDialogContent => '前往 GitHub';

  @override
  String get back => '返回';

  @override
  String get github => 'GitHub';

  @override
  String get languageSectionTitle => '語言';

  @override
  String get languageSystemDefault => '系統預設';

  @override
  String get languageEnglish => '英文';

  @override
  String get languageChinese => '中文';

  @override
  String get themeSectionTitle => '主題';

  @override
  String get themeLight => '亮色';

  @override
  String get themeDark => '暗色';

  @override
  String get themeSystemDefault => '跟隨系統';

  @override
  String get appUseGuide => 'App使用指南';

  @override
  String get appUseGuideSubtitle => '查看應用程式使用說明';

  @override
  String get imageLoading => '圖片載入中...';

  @override
  String get kmbSearchHint => '請輸入路線號碼';

  @override
  String get kmbNoMatchTitle => '沒有相應路線';

  @override
  String get kmbNoMatchSubtitle => '請重新檢查路線號碼';

  @override
  String get kmbEmptyTitle => '請輸入路線號碼';

  @override
  String get kmbEmptySubtitle => '例如: 1A';

  @override
  String get introWelcomeTitle => '歡迎使用應用程式';

  @override
  String get introUseIt => '您可以使用它來查詢';

  @override
  String get introHKTransportsETA => '香港交通的到站時間';

  @override
  String get introETAFull => '（預計到達時間）';

  @override
  String get introIfChangeMode => '如果您要切換模式...';

  @override
  String get holdToChange => '長按以切換';

  @override
  String get busLabel => '巴士';

  @override
  String get mtrLabel => '港鐵';

  @override
  String get introSetupPref => '讓我們設定偏好設定！';

  @override
  String introModeSet(Object mode) {
    return '模式設定：$mode';
  }

  @override
  String get firstTimeSettingsStored => '設定將會被儲存。';

  @override
  String get firstTimeTitleWelcome => '應用程式介紹';

  @override
  String get firstTimeTitleSetup => '設定';

  @override
  String get firstTimeTitleTips => '提示';

  @override
  String get firstTimeTitleReady => '準備就緒';

  @override
  String get firstTimeFinalAdjustSettings => '您可以在菜單中調整設定';

  @override
  String get firstTimeFinalThanks => '感謝使用本應用程式！';

  @override
  String get dataOpsVibrationToggle => '震動';

  @override
  String get dataOpsSubtitleToggle => '顯示巴士站副標題';

  @override
  String get dataOpsApiReviewToggle => 'API 審查';

  @override
  String get apiErrorFailedToLoadRoutes => '載入路線失敗';

  @override
  String get apiErrorFailedToLoadStops => '載入車站失敗';

  @override
  String get apiErrorFailedToLoadRouteStops => '載入路線車站失敗';

  @override
  String get apiErrorFailedToLoadETA => '載入到站時間失敗';

  @override
  String get apiErrorFetchingRoutes => '獲取路線時發生錯誤';

  @override
  String get apiErrorFetchingStops => '獲取車站時發生錯誤';

  @override
  String get apiErrorFetchingRouteStops => '獲取路線車站時發生錯誤';

  @override
  String get apiErrorFetchingETA => '獲取到站時間時發生錯誤';

  @override
  String get apiErrorUnknownStop => '未知車站';

  @override
  String get apiErrorNoData => '沒有資料';

  @override
  String get apiErrorArrivingNow => '即將到達';

  @override
  String get apiErrorExpired => '已過期';

  @override
  String get apiErrorMinutes => '分鐘';

  @override
  String get apiErrorBusMayHaveLeft => '巴士可能已離開';

  @override
  String get etaTitle => '到達時間';

  @override
  String get routeTitleTo => '往';

  @override
  String get routeTitleSpecial => '特別班次';

  @override
  String get appInfoSectionTitle => '應用程式資訊';

  @override
  String get appInfoVersion => '版本';

  @override
  String get appInfoBuildNumber => '建置編號';

  @override
  String get appInfoPackageName => '套件名稱';

  @override
  String get appInfoDescription => '描述';

  @override
  String get appInfoDescriptionText => '香港交通應用 - 查詢巴士及港鐵到站時間';

  @override
  String get appInfoCopied => '已複製';

  @override
  String get resetAppTitle => '重設應用';

  @override
  String get resetButton => '重設';

  @override
  String get resetAppDialogTitle => '重設應用';

  @override
  String get resetAppDialogContent => '這將清除快取、書籤和偏好設定。';

  @override
  String get cancel => '取消';

  @override
  String get editItems => '編輯項目';
}
