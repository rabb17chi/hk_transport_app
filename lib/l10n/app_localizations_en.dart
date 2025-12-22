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
  String get menuDevLinks => 'Project\'s GitHub Repo';

  @override
  String get menuDevLinksSubtitle => 'GitHub Project Page';

  @override
  String get menuDataOpsTitle => 'Data Operations';

  @override
  String get dataOpsSpecialToggle => 'Show special KMB routes';

  @override
  String get dataOpsDisplayBusFullName => 'Display Bus Full Name (stop codes)';

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
  String get dataOpsOpenAppAnimation => 'Open-App Animation';

  @override
  String get navBookmarks => 'Bookmark';

  @override
  String get navSettings => 'Setting';

  @override
  String get tabBus => 'Bus';

  @override
  String get tabMTR => 'MTR';

  @override
  String get emptyTitle => 'No bookmarked routes yet';

  @override
  String get emptyInstructionAction => 'Long press the stopname';

  @override
  String get emptyInstructionSuffix => 'to add to bookmarks';

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
  String deleteBookmarkConfirm(String bookmark) {
    return 'Are you sure you want to delete: $bookmark?';
  }

  @override
  String get deleteBookmarkConfirmPlaceholder => 'Are you sure you want to delete this bookmark?';

  @override
  String get etaSeqPrefix => 'Trip ';

  @override
  String get etaSeqSuffix => '';

  @override
  String get devLinksDialogTitle => 'Project\'s GitHub Link';

  @override
  String get devLinksDialogContent => 'Route to GitHub. Star it if you like it!';

  @override
  String get back => 'Back';

  @override
  String get github => 'GitHub';

  @override
  String get languageSectionTitle => 'Language';

  @override
  String get languageSystemDefault => 'System';

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
  String get themeSystemDefault => 'System';

  @override
  String get appUseGuide => 'App Usage Guide';

  @override
  String get appUseGuideSubtitle => 'View app usage instructions';

  @override
  String get imageLoading => 'Loading image...';

  @override
  String get kmbSearchHint => 'Enter route number';

  @override
  String get kmbNoMatchTitle => 'No matching routes';

  @override
  String get kmbNoMatchSubtitle => 'Please check the route number';

  @override
  String get kmbEmptyTitle => 'Please input route number';

  @override
  String get kmbEmptySubtitle => 'e.g. 1A';

  @override
  String get introWelcomeTitle => 'Welcome to App';

  @override
  String get introUseIt => 'You can use it to check';

  @override
  String get introHKTransportsETA => 'HK transports\' ETA';

  @override
  String get introETAFull => '(Estimated Time of Arrival)';

  @override
  String get introIfChangeMode => 'If you change mode...';

  @override
  String get holdToChange => 'Hold to change';

  @override
  String get busLabel => 'Bus';

  @override
  String get mtrLabel => 'MTR';

  @override
  String get introSetupPref => 'Let\'s set up the preference!';

  @override
  String introModeSet(Object mode) {
    return 'Mode Set: $mode';
  }

  @override
  String get firstTimeSettingsStored => 'Settings will be stored.';

  @override
  String get firstTimeTitleWelcome => 'App Introduction';

  @override
  String get firstTimeTitleSetup => 'Setup';

  @override
  String get firstTimeTitleTips => 'Tips';

  @override
  String get firstTimeTitleReady => 'Ready';

  @override
  String get firstTimeFinalAdjustSettings => 'You can adjust your settings in Menu';

  @override
  String get firstTimeFinalThanks => 'Thanks for using the app!';

  @override
  String get dataOpsVibrationToggle => 'Vibration';

  @override
  String get dataOpsSubtitleToggle => 'Show Bus Station Subtitle';

  @override
  String get dataOpsApiReviewToggle => 'API Review';

  @override
  String get apiErrorFailedToLoadRoutes => 'Failed to load routes';

  @override
  String get apiErrorFailedToLoadStops => 'Failed to load stops';

  @override
  String get apiErrorFailedToLoadRouteStops => 'Failed to load route stops';

  @override
  String get apiErrorFailedToLoadETA => 'Failed to load ETA';

  @override
  String get apiErrorFetchingRoutes => 'Error fetching routes';

  @override
  String get apiErrorFetchingStops => 'Error fetching stops';

  @override
  String get apiErrorFetchingRouteStops => 'Error fetching route stops';

  @override
  String get apiErrorFetchingETA => 'Error fetching ETA';

  @override
  String get apiErrorUnknownStop => 'Unknown Stop';

  @override
  String get apiErrorNoData => 'No Data';

  @override
  String get apiErrorArrivingNow => 'Arriving now';

  @override
  String get apiErrorExpired => 'Expired';

  @override
  String get apiErrorMinutes => 'min';

  @override
  String get apiErrorBusMayHaveLeft => 'Bus may have left';

  @override
  String get etaTitle => 'Arrival Time';

  @override
  String get routeTitleTo => 'to';

  @override
  String get routeTitleSpecial => 'Special';

  @override
  String get appInfoSectionTitle => 'App Information';

  @override
  String get appInfoVersion => 'Version';

  @override
  String get appInfoBuildNumber => 'Build Number';

  @override
  String get appInfoPackageName => 'Package Name';

  @override
  String get appInfoDescription => 'Description';

  @override
  String get appInfoDescriptionText => 'HK Transport App - Check bus and MTR ETA';

  @override
  String get appInfoCopied => 'Copied';

  @override
  String get resetAppTitle => 'Reset App';

  @override
  String get resetButton => 'Reset';

  @override
  String get resetAppDialogTitle => 'Reset App';

  @override
  String get resetAppDialogContent => 'This will clear caches, bookmarks and preferences.';

  @override
  String get cancel => 'Cancel';

  @override
  String get editItems => 'Edit Items';

  @override
  String get dataOpsNotificationPermission => 'Notification Permission';

  @override
  String get dataOpsNotificationPermissionSubtitle => 'Allow app to send notifications';

  @override
  String get notificationPermissionRequired => 'Notification permission is required';

  @override
  String get notificationPermissionDenied => 'Notification permission is required to enable this feature';

  @override
  String get dataOpsResetCTB => 'Reset CTB Data';

  @override
  String get dataOpsResetCTBSubtitle => 'Clear all CTB stop information cache';

  @override
  String get resetCTBDialogTitle => 'Reset CTB Data';

  @override
  String get resetCTBDialogContent => 'Are you sure you want to clear all CTB stop information cache? This action cannot be undone.';

  @override
  String get resetCTBSuccess => 'CTB data cleared successfully';

  @override
  String resetCTBFailed(Object error) {
    return 'Failed to clear: $error';
  }

  @override
  String get resetCTBFailedPlaceholder => 'Failed to clear';

  @override
  String get networkConnected => 'Network Connected';

  @override
  String get noNetworkConnection => 'No Network Connection';

  @override
  String get noNetworkMessage => 'Please check your network connection settings. The app requires an internet connection to fetch real-time transport information.';

  @override
  String get confirm => 'Confirm';

  @override
  String editItemsDialogTitle(Object type) {
    return 'Edit Items ($type)';
  }

  @override
  String editItemsDialogContent(Object count) {
    return 'Edit mode coming soon. $count items.';
  }

  @override
  String get editItemsPlaceholder => 'Edit Items';

  @override
  String get longPressToBookmark => 'You can long press bus stations to add to bookmarks';

  @override
  String appInfoCopiedMessage(Object value) {
    return 'Copied: $value';
  }

  @override
  String get languageEnglishLabel => 'English';

  @override
  String get languageChineseLabel => '繁體中文';

  @override
  String get retry => 'Retry';

  @override
  String get apiReview => 'API-Review';

  @override
  String get mtrTimetableUnavailable => 'Unable to fetch timetable, please try again later';

  @override
  String get mtrStationNotFound => 'Station data not found';

  @override
  String get systemMonitorTitle => 'System Monitor';

  @override
  String get systemMonitorSubtitle => 'Device scaling and screen information';

  @override
  String get systemMonitorLoading => 'Loading system information...';

  @override
  String get systemMonitorScreenScaling => 'Screen Scaling';

  @override
  String get systemMonitorScreenSize => 'Screen Size';

  @override
  String get systemMonitorSystemInfo => 'System Information';

  @override
  String get systemMonitorScalingStatus => 'Scaling Status';

  @override
  String get systemMonitorTextScaling => 'Text Scaling';

  @override
  String get systemMonitorPixelDensity => 'Pixel Density';

  @override
  String get systemMonitorWidth => 'Width';

  @override
  String get systemMonitorHeight => 'Height';

  @override
  String get systemMonitorAvailableHeight => 'Available Height';

  @override
  String get systemMonitorThemeMode => 'Theme Mode';

  @override
  String get systemMonitorStatusBar => 'Status Bar';

  @override
  String get systemMonitorBottomSafeArea => 'Bottom Safe Area';

  @override
  String get systemMonitorTextScaleStatus => 'Text Scale Status';

  @override
  String get systemMonitorRecommendation => 'Recommendation';

  @override
  String get systemMonitorLightMode => 'Light Mode';

  @override
  String get systemMonitorDarkMode => 'Dark Mode';

  @override
  String get systemMonitorUnknown => 'Unknown';

  @override
  String systemMonitorNormal(Object scale) {
    return 'Normal (${scale}x)';
  }

  @override
  String systemMonitorSlightZoom(Object scale) {
    return 'Slight Zoom (${scale}x)';
  }

  @override
  String systemMonitorMediumZoom(Object scale) {
    return 'Medium Zoom (${scale}x)';
  }

  @override
  String systemMonitorHighZoom(Object scale) {
    return 'High Zoom (${scale}x)';
  }

  @override
  String get systemMonitorUINormal => 'UI display normal';

  @override
  String get systemMonitorUISlightImpact => 'UI may have slight impact';

  @override
  String get systemMonitorUICheckLayout => 'Recommend checking UI layout';

  @override
  String get systemMonitorUIOptimize => 'Need to optimize UI responsive design';

  @override
  String get noNetworkReturnMessage => 'Please check your device network status(mobile-data/wifi is on)';
}
