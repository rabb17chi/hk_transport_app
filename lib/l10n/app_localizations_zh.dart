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
  String get menuUpdateKMB => '手動更新九巴資料';

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
  String get menuDataOpsTitle => 'Data Operations';

  @override
  String get dataOpsSpecialToggle => 'Show special KMB routes';

  @override
  String get dataOpsRefreshKMB => 'Refresh KMB Data';

  @override
  String get dataOpsRefreshNow => 'Refresh Now';

  @override
  String get menuTutorial => 'App Tutorial';

  @override
  String get dataOpsMtrReverse => '反轉港鐵站序';

  @override
  String get navBookmarks => '收藏';

  @override
  String get navSettings => '設定';

  @override
  String get tabBus => '巴士';

  @override
  String get tabMTR => '港鐵';

  @override
  String get kmbEmptyTitle => '暫未有收藏的路線';

  @override
  String get kmbEmptyInstructionPrefix => '在巴士路線頁面';

  @override
  String get kmbEmptyInstructionAction => '長按站名';

  @override
  String get kmbEmptyInstructionSuffix => '以加入收藏';

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
  String get mtrEmptySubtitle => '長按港鐵車站可加入收藏';

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
}

/// The translations for Chinese, as used in Hong Kong (`zh_HK`).
class AppLocalizationsZhHk extends AppLocalizationsZh {
  AppLocalizationsZhHk(): super('zh_HK');

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
  String get menuUpdateKMB => '手動更新九巴資料';

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
  String get dataOpsSpecialToggle => '顯示特別班次';

  @override
  String get dataOpsRefreshKMB => '手動更新九巴資料';

  @override
  String get dataOpsRefreshNow => '立即更新';

  @override
  String get menuTutorial => 'APP使用教程';

  @override
  String get dataOpsMtrReverse => '反轉港鐵站序';

  @override
  String get navBookmarks => '收藏';

  @override
  String get navSettings => '設定';

  @override
  String get tabBus => '巴士';

  @override
  String get tabMTR => '港鐵';

  @override
  String get kmbEmptyTitle => '暫未有收藏的路線';

  @override
  String get kmbEmptyInstructionPrefix => '在巴士路線頁面';

  @override
  String get kmbEmptyInstructionAction => '長按站名';

  @override
  String get kmbEmptyInstructionSuffix => '以加入收藏';

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
  String get mtrEmptySubtitle => '長按港鐵車站可加入收藏';

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
}
