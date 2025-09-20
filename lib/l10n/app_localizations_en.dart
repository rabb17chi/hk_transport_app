// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'HK Transport App';

  @override
  String get menuTitle => 'Menu';

  @override
  String get menuTheme => 'Theme';

  @override
  String get menuThemeSubtitle => 'Light / Dark (coming soon)';

  @override
  String get menuStyle => 'Style';

  @override
  String get menuStyleSubtitle => 'Fonts, colors, sizes (coming soon)';

  @override
  String get menuUpdateKMB => 'Update KMB Data Manually';

  @override
  String get menuRefresh => 'Refresh';

  @override
  String get menuReset => 'Reset App (clear data & preferences)';

  @override
  String get menuTerms => 'Terms of Service';

  @override
  String get menuTermsSubtitle => 'View terms and privacy policy (coming soon)';

  @override
  String get menuDevLinks => 'Developer Links';

  @override
  String get menuDevLinksSubtitle => 'GitHub Project Page';

  @override
  String get menuDataOpsTitle => 'Data Operations';

  @override
  String get dataOpsSpecialToggle => 'Show special KMB routes';

  @override
  String get dataOpsRefreshKMB => 'Refresh KMB Data';

  @override
  String get dataOpsRefreshNow => 'Refresh Now';

  @override
  String dataOpsLastUpdate(Object time) {
    return 'Last updated: $time';
  }

  @override
  String get dataOpsNeverUpdated => 'Never updated';

  @override
  String get menuTutorial => 'App Tutorial';

  @override
  String get dataOpsMtrReverse => 'Reverse MTR stations order';

  @override
  String get dataOpsMtrAutoRefresh => 'Auto Refresh Trains Data';

  @override
  String get navBookmarks => 'Bookmarks';

  @override
  String get navSettings => 'Settings';

  @override
  String get tabBus => 'Bus';

  @override
  String get tabMTR => 'MTR';

  @override
  String get kmbEmptyTitle => 'No bookmarked routes yet';

  @override
  String get kmbEmptyInstructionPrefix => 'In the bus route page';

  @override
  String get kmbEmptyInstructionAction => 'Long press the stopname';

  @override
  String get kmbEmptyInstructionSuffix => 'to add to bookmarks';

  @override
  String get toWord => 'To';

  @override
  String get etaEmpty => 'No ETA available';

  @override
  String get close => 'Close';

  @override
  String get errorLoadBookmarks => 'Error loading bookmarks';

  @override
  String get etaLoadFailed => 'Failed to load ETA';

  @override
  String get mtrEmptyTitle => 'No MTR bookmarks';

  @override
  String get mtrEmptySubtitle => 'a MTR station to add';

  @override
  String get longPress => 'Long Press';

  @override
  String get mtrNoTrainInfo => 'No train information';

  @override
  String get mtrOtherLines => 'Other lines';

  @override
  String get mtrUpdateFailed => 'Unable to update timetable, please try again later';

  @override
  String get mtrUpdateError => 'Update failed';

  @override
  String get mtrRefreshing => 'Refreshing';

  @override
  String get mtrUpDirection => 'Up direction';

  @override
  String get mtrDownDirection => 'Down direction';

  @override
  String get mtrUpdating => 'Updating timetable...';

  @override
  String get mtrClose => 'Close';

  @override
  String get mtrRefresh => 'Refresh';

  @override
  String get mtrUnknownLine => 'Unknown line';

  @override
  String get mtrTimeError => 'Time error';

  @override
  String get mtrArrivingSoon => 'Arriving soon';

  @override
  String get mtrMinutes => 'mins';

  @override
  String get mtrHours => 'hrs';

  @override
  String mtrHoursMinutes(Object hours, Object minutes) {
    return 'hrs $minutes mins';
  }

  @override
  String get timetableUnavailable => 'Unable to fetch timetable, please try again later';

  @override
  String get removeBookmarkSuccess => 'Bookmark removed';

  @override
  String get removeBookmarkError => 'Error removing bookmark';

  @override
  String get etaSeqPrefix => 'Trip ';

  @override
  String get etaSeqSuffix => '';

  @override
  String get devLinksDialogTitle => 'Developer Links';

  @override
  String get devLinksDialogContent => 'Routing to GitHub';

  @override
  String get back => 'Back';

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

  @override
  String get appUseGuide => 'App Usage Guide';

  @override
  String get appUseGuideSubtitle => 'View app usage instructions';

  @override
  String get imageLoading => 'Loading image...';

  @override
  String get menuWidgetTitle => 'Desktop Widgets';

  @override
  String get widgetUpdateKMB => 'Update KMB Widget';

  @override
  String get widgetUpdateKMBSubtitle => 'Update widget with favorite KMB route';

  @override
  String get widgetUpdateMTR => 'Update MTR Widget';

  @override
  String get widgetUpdateMTRSubtitle => 'Update widget with MTR station info';

  @override
  String get widgetUpdateNow => 'Update Now';

  @override
  String get widgetUpdated => 'Widget updated successfully';

  @override
  String get widgetClear => 'Clear Widget';

  @override
  String get widgetClearSubtitle => 'Remove all widget data';

  @override
  String get widgetClearNow => 'Clear Now';

  @override
  String get widgetCleared => 'Widget cleared successfully';
}
