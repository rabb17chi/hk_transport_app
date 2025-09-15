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
  String get devLinksDialogTitle => '開發者連結';

  @override
  String get devLinksDialogContent => '前往 GitHub';

  @override
  String get back => '返回';

  @override
  String get github => 'GitHub';

  @override
  String get languageSectionTitle => 'Language';

  @override
  String get languageSystemDefault => 'System Default';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageChinese => 'Chinese';

  @override
  String get themeSectionTitle => 'Theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystemDefault => 'System Default';
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
