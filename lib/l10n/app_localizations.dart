import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'HK Transport App'**
  String get appTitle;

  /// No description provided for @menuTitle.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menuTitle;

  /// No description provided for @menuTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get menuTheme;

  /// No description provided for @menuThemeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Light / Dark (coming soon)'**
  String get menuThemeSubtitle;

  /// No description provided for @menuStyle.
  ///
  /// In en, this message translates to:
  /// **'Style'**
  String get menuStyle;

  /// No description provided for @menuStyleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Fonts, colors, sizes (coming soon)'**
  String get menuStyleSubtitle;

  /// No description provided for @menuUpdateKMB.
  ///
  /// In en, this message translates to:
  /// **'Update KMB Data Manually'**
  String get menuUpdateKMB;

  /// No description provided for @menuRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get menuRefresh;

  /// No description provided for @menuReset.
  ///
  /// In en, this message translates to:
  /// **'Reset App (clear data & preferences)'**
  String get menuReset;

  /// No description provided for @menuTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get menuTerms;

  /// No description provided for @menuTermsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View terms and privacy policy (coming soon)'**
  String get menuTermsSubtitle;

  /// No description provided for @menuDevLinks.
  ///
  /// In en, this message translates to:
  /// **'Project\'s GitHub Repo'**
  String get menuDevLinks;

  /// No description provided for @menuDevLinksSubtitle.
  ///
  /// In en, this message translates to:
  /// **'GitHub Project Page'**
  String get menuDevLinksSubtitle;

  /// No description provided for @menuDataOpsTitle.
  ///
  /// In en, this message translates to:
  /// **'Data Operations'**
  String get menuDataOpsTitle;

  /// No description provided for @dataOpsSpecialToggle.
  ///
  /// In en, this message translates to:
  /// **'Show special KMB routes'**
  String get dataOpsSpecialToggle;

  /// No description provided for @dataOpsDisplayBusFullName.
  ///
  /// In en, this message translates to:
  /// **'Display Bus Full Name (stop codes)'**
  String get dataOpsDisplayBusFullName;

  /// No description provided for @dataOpsRefreshKMB.
  ///
  /// In en, this message translates to:
  /// **'Refresh KMB Data'**
  String get dataOpsRefreshKMB;

  /// No description provided for @dataOpsRefreshNow.
  ///
  /// In en, this message translates to:
  /// **'Refresh Now'**
  String get dataOpsRefreshNow;

  /// No description provided for @dataOpsLastUpdate.
  ///
  /// In en, this message translates to:
  /// **'Last updated: {time}'**
  String dataOpsLastUpdate(Object time);

  /// No description provided for @dataOpsNeverUpdated.
  ///
  /// In en, this message translates to:
  /// **'Never updated'**
  String get dataOpsNeverUpdated;

  /// No description provided for @menuTutorial.
  ///
  /// In en, this message translates to:
  /// **'App Tutorial'**
  String get menuTutorial;

  /// No description provided for @dataOpsMtrReverse.
  ///
  /// In en, this message translates to:
  /// **'Reverse MTR stations order'**
  String get dataOpsMtrReverse;

  /// No description provided for @dataOpsMtrAutoRefresh.
  ///
  /// In en, this message translates to:
  /// **'Auto Refresh Trains Data'**
  String get dataOpsMtrAutoRefresh;

  /// No description provided for @dataOpsOpenAppAnimation.
  ///
  /// In en, this message translates to:
  /// **'Open-App Animation'**
  String get dataOpsOpenAppAnimation;

  /// No description provided for @navBookmarks.
  ///
  /// In en, this message translates to:
  /// **'Bookmark'**
  String get navBookmarks;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Setting'**
  String get navSettings;

  /// No description provided for @tabBus.
  ///
  /// In en, this message translates to:
  /// **'Bus'**
  String get tabBus;

  /// No description provided for @tabMTR.
  ///
  /// In en, this message translates to:
  /// **'MTR'**
  String get tabMTR;

  /// No description provided for @emptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No bookmarked routes yet'**
  String get emptyTitle;

  /// No description provided for @emptyInstructionAction.
  ///
  /// In en, this message translates to:
  /// **'Long press the stopname'**
  String get emptyInstructionAction;

  /// No description provided for @emptyInstructionSuffix.
  ///
  /// In en, this message translates to:
  /// **'to add to bookmarks'**
  String get emptyInstructionSuffix;

  /// No description provided for @toWord.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get toWord;

  /// No description provided for @etaEmpty.
  ///
  /// In en, this message translates to:
  /// **'No ETA available'**
  String get etaEmpty;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @errorLoadBookmarks.
  ///
  /// In en, this message translates to:
  /// **'Error loading bookmarks'**
  String get errorLoadBookmarks;

  /// No description provided for @etaLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load ETA'**
  String get etaLoadFailed;

  /// No description provided for @mtrEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No MTR bookmarks'**
  String get mtrEmptyTitle;

  /// No description provided for @mtrEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'a MTR station to add'**
  String get mtrEmptySubtitle;

  /// No description provided for @longPress.
  ///
  /// In en, this message translates to:
  /// **'Long Press'**
  String get longPress;

  /// No description provided for @mtrNoTrainInfo.
  ///
  /// In en, this message translates to:
  /// **'No train information'**
  String get mtrNoTrainInfo;

  /// No description provided for @mtrOtherLines.
  ///
  /// In en, this message translates to:
  /// **'Other lines'**
  String get mtrOtherLines;

  /// No description provided for @mtrUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to update timetable, please try again later'**
  String get mtrUpdateFailed;

  /// No description provided for @mtrUpdateError.
  ///
  /// In en, this message translates to:
  /// **'Update failed'**
  String get mtrUpdateError;

  /// No description provided for @mtrRefreshing.
  ///
  /// In en, this message translates to:
  /// **'Refreshing'**
  String get mtrRefreshing;

  /// No description provided for @mtrUpDirection.
  ///
  /// In en, this message translates to:
  /// **'Up direction'**
  String get mtrUpDirection;

  /// No description provided for @mtrDownDirection.
  ///
  /// In en, this message translates to:
  /// **'Down direction'**
  String get mtrDownDirection;

  /// No description provided for @mtrUpdating.
  ///
  /// In en, this message translates to:
  /// **'Updating timetable...'**
  String get mtrUpdating;

  /// No description provided for @mtrClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get mtrClose;

  /// No description provided for @mtrRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get mtrRefresh;

  /// No description provided for @mtrUnknownLine.
  ///
  /// In en, this message translates to:
  /// **'Unknown line'**
  String get mtrUnknownLine;

  /// No description provided for @mtrTimeError.
  ///
  /// In en, this message translates to:
  /// **'Time error'**
  String get mtrTimeError;

  /// No description provided for @mtrArrivingSoon.
  ///
  /// In en, this message translates to:
  /// **'Arriving soon'**
  String get mtrArrivingSoon;

  /// No description provided for @mtrMinutes.
  ///
  /// In en, this message translates to:
  /// **'mins'**
  String get mtrMinutes;

  /// No description provided for @mtrHours.
  ///
  /// In en, this message translates to:
  /// **'hrs'**
  String get mtrHours;

  /// No description provided for @mtrHoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'hrs {minutes} mins'**
  String mtrHoursMinutes(Object hours, Object minutes);

  /// No description provided for @timetableUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unable to fetch timetable, please try again later'**
  String get timetableUnavailable;

  /// No description provided for @removeBookmarkSuccess.
  ///
  /// In en, this message translates to:
  /// **'Bookmark removed'**
  String get removeBookmarkSuccess;

  /// No description provided for @removeBookmarkError.
  ///
  /// In en, this message translates to:
  /// **'Error removing bookmark'**
  String get removeBookmarkError;

  /// No description provided for @etaSeqPrefix.
  ///
  /// In en, this message translates to:
  /// **'Trip '**
  String get etaSeqPrefix;

  /// No description provided for @etaSeqSuffix.
  ///
  /// In en, this message translates to:
  /// **''**
  String get etaSeqSuffix;

  /// No description provided for @devLinksDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Project\'s GitHub Link'**
  String get devLinksDialogTitle;

  /// No description provided for @devLinksDialogContent.
  ///
  /// In en, this message translates to:
  /// **'Route to GitHub. Star it if you like it!'**
  String get devLinksDialogContent;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @github.
  ///
  /// In en, this message translates to:
  /// **'GitHub'**
  String get github;

  /// No description provided for @languageSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSectionTitle;

  /// No description provided for @languageSystemDefault.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get languageSystemDefault;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageChinese.
  ///
  /// In en, this message translates to:
  /// **'Chinese'**
  String get languageChinese;

  /// No description provided for @themeSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeSectionTitle;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeSystemDefault.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystemDefault;

  /// No description provided for @appUseGuide.
  ///
  /// In en, this message translates to:
  /// **'App Usage Guide'**
  String get appUseGuide;

  /// No description provided for @appUseGuideSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View app usage instructions'**
  String get appUseGuideSubtitle;

  /// No description provided for @imageLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading image...'**
  String get imageLoading;

  /// No description provided for @kmbSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Enter route number'**
  String get kmbSearchHint;

  /// No description provided for @kmbNoMatchTitle.
  ///
  /// In en, this message translates to:
  /// **'No matching routes'**
  String get kmbNoMatchTitle;

  /// No description provided for @kmbNoMatchSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please check the route number'**
  String get kmbNoMatchSubtitle;

  /// No description provided for @kmbEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Please input route number'**
  String get kmbEmptyTitle;

  /// No description provided for @kmbEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'e.g. 1A'**
  String get kmbEmptySubtitle;

  /// No description provided for @introWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to App'**
  String get introWelcomeTitle;

  /// No description provided for @introUseIt.
  ///
  /// In en, this message translates to:
  /// **'You can use it to check'**
  String get introUseIt;

  /// No description provided for @introHKTransportsETA.
  ///
  /// In en, this message translates to:
  /// **'HK transports\' ETA'**
  String get introHKTransportsETA;

  /// No description provided for @introETAFull.
  ///
  /// In en, this message translates to:
  /// **'(Estimated Time of Arrival)'**
  String get introETAFull;

  /// No description provided for @introIfChangeMode.
  ///
  /// In en, this message translates to:
  /// **'If you change mode...'**
  String get introIfChangeMode;

  /// No description provided for @holdToChange.
  ///
  /// In en, this message translates to:
  /// **'Hold to change'**
  String get holdToChange;

  /// No description provided for @busLabel.
  ///
  /// In en, this message translates to:
  /// **'Bus'**
  String get busLabel;

  /// No description provided for @mtrLabel.
  ///
  /// In en, this message translates to:
  /// **'MTR'**
  String get mtrLabel;

  /// No description provided for @introSetupPref.
  ///
  /// In en, this message translates to:
  /// **'Let\'s set up the preference!'**
  String get introSetupPref;

  /// No description provided for @introModeSet.
  ///
  /// In en, this message translates to:
  /// **'Mode Set: {mode}'**
  String introModeSet(Object mode);

  /// No description provided for @firstTimeSettingsStored.
  ///
  /// In en, this message translates to:
  /// **'Settings will be stored.'**
  String get firstTimeSettingsStored;

  /// No description provided for @firstTimeTitleWelcome.
  ///
  /// In en, this message translates to:
  /// **'App Introduction'**
  String get firstTimeTitleWelcome;

  /// No description provided for @firstTimeTitleSetup.
  ///
  /// In en, this message translates to:
  /// **'Setup'**
  String get firstTimeTitleSetup;

  /// No description provided for @firstTimeTitleTips.
  ///
  /// In en, this message translates to:
  /// **'Tips'**
  String get firstTimeTitleTips;

  /// No description provided for @firstTimeTitleReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get firstTimeTitleReady;

  /// No description provided for @firstTimeFinalAdjustSettings.
  ///
  /// In en, this message translates to:
  /// **'You can adjust your settings in Menu'**
  String get firstTimeFinalAdjustSettings;

  /// No description provided for @firstTimeFinalThanks.
  ///
  /// In en, this message translates to:
  /// **'Thanks for using the app!'**
  String get firstTimeFinalThanks;

  /// No description provided for @dataOpsVibrationToggle.
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get dataOpsVibrationToggle;

  /// No description provided for @dataOpsSubtitleToggle.
  ///
  /// In en, this message translates to:
  /// **'Show Bus Station Subtitle'**
  String get dataOpsSubtitleToggle;

  /// No description provided for @dataOpsApiReviewToggle.
  ///
  /// In en, this message translates to:
  /// **'API Review'**
  String get dataOpsApiReviewToggle;

  /// No description provided for @apiErrorFailedToLoadRoutes.
  ///
  /// In en, this message translates to:
  /// **'Failed to load routes'**
  String get apiErrorFailedToLoadRoutes;

  /// No description provided for @apiErrorFailedToLoadStops.
  ///
  /// In en, this message translates to:
  /// **'Failed to load stops'**
  String get apiErrorFailedToLoadStops;

  /// No description provided for @apiErrorFailedToLoadRouteStops.
  ///
  /// In en, this message translates to:
  /// **'Failed to load route stops'**
  String get apiErrorFailedToLoadRouteStops;

  /// No description provided for @apiErrorFailedToLoadETA.
  ///
  /// In en, this message translates to:
  /// **'Failed to load ETA'**
  String get apiErrorFailedToLoadETA;

  /// No description provided for @apiErrorFetchingRoutes.
  ///
  /// In en, this message translates to:
  /// **'Error fetching routes'**
  String get apiErrorFetchingRoutes;

  /// No description provided for @apiErrorFetchingStops.
  ///
  /// In en, this message translates to:
  /// **'Error fetching stops'**
  String get apiErrorFetchingStops;

  /// No description provided for @apiErrorFetchingRouteStops.
  ///
  /// In en, this message translates to:
  /// **'Error fetching route stops'**
  String get apiErrorFetchingRouteStops;

  /// No description provided for @apiErrorFetchingETA.
  ///
  /// In en, this message translates to:
  /// **'Error fetching ETA'**
  String get apiErrorFetchingETA;

  /// No description provided for @apiErrorUnknownStop.
  ///
  /// In en, this message translates to:
  /// **'Unknown Stop'**
  String get apiErrorUnknownStop;

  /// No description provided for @apiErrorNoData.
  ///
  /// In en, this message translates to:
  /// **'No Data'**
  String get apiErrorNoData;

  /// No description provided for @apiErrorArrivingNow.
  ///
  /// In en, this message translates to:
  /// **'Arriving now'**
  String get apiErrorArrivingNow;

  /// No description provided for @apiErrorExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get apiErrorExpired;

  /// No description provided for @apiErrorMinutes.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get apiErrorMinutes;

  /// No description provided for @apiErrorBusMayHaveLeft.
  ///
  /// In en, this message translates to:
  /// **'Bus may have left'**
  String get apiErrorBusMayHaveLeft;

  /// No description provided for @etaTitle.
  ///
  /// In en, this message translates to:
  /// **'Arrival Time'**
  String get etaTitle;

  /// No description provided for @routeTitleTo.
  ///
  /// In en, this message translates to:
  /// **'to'**
  String get routeTitleTo;

  /// No description provided for @routeTitleSpecial.
  ///
  /// In en, this message translates to:
  /// **'Special'**
  String get routeTitleSpecial;

  /// No description provided for @appInfoSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'App Information'**
  String get appInfoSectionTitle;

  /// No description provided for @appInfoVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get appInfoVersion;

  /// No description provided for @appInfoBuildNumber.
  ///
  /// In en, this message translates to:
  /// **'Build Number'**
  String get appInfoBuildNumber;

  /// No description provided for @appInfoPackageName.
  ///
  /// In en, this message translates to:
  /// **'Package Name'**
  String get appInfoPackageName;

  /// No description provided for @appInfoDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get appInfoDescription;

  /// No description provided for @appInfoDescriptionText.
  ///
  /// In en, this message translates to:
  /// **'HK Transport App - Check bus and MTR ETA'**
  String get appInfoDescriptionText;

  /// No description provided for @appInfoCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get appInfoCopied;

  /// No description provided for @resetAppTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset App'**
  String get resetAppTitle;

  /// No description provided for @resetButton.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get resetButton;

  /// No description provided for @resetAppDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset App'**
  String get resetAppDialogTitle;

  /// No description provided for @resetAppDialogContent.
  ///
  /// In en, this message translates to:
  /// **'This will clear caches, bookmarks and preferences.'**
  String get resetAppDialogContent;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @editItems.
  ///
  /// In en, this message translates to:
  /// **'Edit Items'**
  String get editItems;

  /// No description provided for @dataOpsNotificationPermission.
  ///
  /// In en, this message translates to:
  /// **'Notification Permission'**
  String get dataOpsNotificationPermission;

  /// No description provided for @dataOpsNotificationPermissionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Allow app to send notifications'**
  String get dataOpsNotificationPermissionSubtitle;

  /// No description provided for @notificationPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Notification permission is required'**
  String get notificationPermissionRequired;

  /// No description provided for @notificationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Notification permission is required to enable this feature'**
  String get notificationPermissionDenied;

  /// No description provided for @dataOpsResetCTB.
  ///
  /// In en, this message translates to:
  /// **'Reset CTB Data'**
  String get dataOpsResetCTB;

  /// No description provided for @dataOpsResetCTBSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Clear all CTB stop information cache'**
  String get dataOpsResetCTBSubtitle;

  /// No description provided for @resetCTBDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset CTB Data'**
  String get resetCTBDialogTitle;

  /// No description provided for @resetCTBDialogContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear all CTB stop information cache? This action cannot be undone.'**
  String get resetCTBDialogContent;

  /// No description provided for @resetCTBSuccess.
  ///
  /// In en, this message translates to:
  /// **'CTB data cleared successfully'**
  String get resetCTBSuccess;

  /// No description provided for @resetCTBFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to clear: {error}'**
  String resetCTBFailed(Object error);

  /// No description provided for @resetCTBFailedPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Failed to clear'**
  String get resetCTBFailedPlaceholder;

  /// No description provided for @networkConnected.
  ///
  /// In en, this message translates to:
  /// **'Network Connected'**
  String get networkConnected;

  /// No description provided for @noNetworkConnection.
  ///
  /// In en, this message translates to:
  /// **'No Network Connection'**
  String get noNetworkConnection;

  /// No description provided for @noNetworkMessage.
  ///
  /// In en, this message translates to:
  /// **'Please check your network connection settings. The app requires an internet connection to fetch real-time transport information.'**
  String get noNetworkMessage;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @editItemsDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Items ({type})'**
  String editItemsDialogTitle(Object type);

  /// No description provided for @editItemsDialogContent.
  ///
  /// In en, this message translates to:
  /// **'Edit mode coming soon. {count} items.'**
  String editItemsDialogContent(Object count);

  /// No description provided for @editItemsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Edit Items'**
  String get editItemsPlaceholder;

  /// No description provided for @longPressToBookmark.
  ///
  /// In en, this message translates to:
  /// **'You can long press bus stations to add to bookmarks'**
  String get longPressToBookmark;

  /// No description provided for @appInfoCopiedMessage.
  ///
  /// In en, this message translates to:
  /// **'Copied: {value}'**
  String appInfoCopiedMessage(Object value);

  /// No description provided for @languageEnglishLabel.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglishLabel;

  /// No description provided for @languageChineseLabel.
  ///
  /// In en, this message translates to:
  /// **'繁體中文'**
  String get languageChineseLabel;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @apiReview.
  ///
  /// In en, this message translates to:
  /// **'API-Review'**
  String get apiReview;

  /// No description provided for @mtrTimetableUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unable to fetch timetable, please try again later'**
  String get mtrTimetableUnavailable;

  /// No description provided for @mtrStationNotFound.
  ///
  /// In en, this message translates to:
  /// **'Station data not found'**
  String get mtrStationNotFound;

  /// No description provided for @systemMonitorTitle.
  ///
  /// In en, this message translates to:
  /// **'System Monitor'**
  String get systemMonitorTitle;

  /// No description provided for @systemMonitorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Device scaling and screen information'**
  String get systemMonitorSubtitle;

  /// No description provided for @systemMonitorLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading system information...'**
  String get systemMonitorLoading;

  /// No description provided for @systemMonitorScreenScaling.
  ///
  /// In en, this message translates to:
  /// **'Screen Scaling'**
  String get systemMonitorScreenScaling;

  /// No description provided for @systemMonitorScreenSize.
  ///
  /// In en, this message translates to:
  /// **'Screen Size'**
  String get systemMonitorScreenSize;

  /// No description provided for @systemMonitorSystemInfo.
  ///
  /// In en, this message translates to:
  /// **'System Information'**
  String get systemMonitorSystemInfo;

  /// No description provided for @systemMonitorScalingStatus.
  ///
  /// In en, this message translates to:
  /// **'Scaling Status'**
  String get systemMonitorScalingStatus;

  /// No description provided for @systemMonitorTextScaling.
  ///
  /// In en, this message translates to:
  /// **'Text Scaling'**
  String get systemMonitorTextScaling;

  /// No description provided for @systemMonitorPixelDensity.
  ///
  /// In en, this message translates to:
  /// **'Pixel Density'**
  String get systemMonitorPixelDensity;

  /// No description provided for @systemMonitorWidth.
  ///
  /// In en, this message translates to:
  /// **'Width'**
  String get systemMonitorWidth;

  /// No description provided for @systemMonitorHeight.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get systemMonitorHeight;

  /// No description provided for @systemMonitorAvailableHeight.
  ///
  /// In en, this message translates to:
  /// **'Available Height'**
  String get systemMonitorAvailableHeight;

  /// No description provided for @systemMonitorThemeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get systemMonitorThemeMode;

  /// No description provided for @systemMonitorStatusBar.
  ///
  /// In en, this message translates to:
  /// **'Status Bar'**
  String get systemMonitorStatusBar;

  /// No description provided for @systemMonitorBottomSafeArea.
  ///
  /// In en, this message translates to:
  /// **'Bottom Safe Area'**
  String get systemMonitorBottomSafeArea;

  /// No description provided for @systemMonitorTextScaleStatus.
  ///
  /// In en, this message translates to:
  /// **'Text Scale Status'**
  String get systemMonitorTextScaleStatus;

  /// No description provided for @systemMonitorRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Recommendation'**
  String get systemMonitorRecommendation;

  /// No description provided for @systemMonitorLightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get systemMonitorLightMode;

  /// No description provided for @systemMonitorDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get systemMonitorDarkMode;

  /// No description provided for @systemMonitorUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get systemMonitorUnknown;

  /// No description provided for @systemMonitorNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal ({scale}x)'**
  String systemMonitorNormal(Object scale);

  /// No description provided for @systemMonitorSlightZoom.
  ///
  /// In en, this message translates to:
  /// **'Slight Zoom ({scale}x)'**
  String systemMonitorSlightZoom(Object scale);

  /// No description provided for @systemMonitorMediumZoom.
  ///
  /// In en, this message translates to:
  /// **'Medium Zoom ({scale}x)'**
  String systemMonitorMediumZoom(Object scale);

  /// No description provided for @systemMonitorHighZoom.
  ///
  /// In en, this message translates to:
  /// **'High Zoom ({scale}x)'**
  String systemMonitorHighZoom(Object scale);

  /// No description provided for @systemMonitorUINormal.
  ///
  /// In en, this message translates to:
  /// **'UI display normal'**
  String get systemMonitorUINormal;

  /// No description provided for @systemMonitorUISlightImpact.
  ///
  /// In en, this message translates to:
  /// **'UI may have slight impact'**
  String get systemMonitorUISlightImpact;

  /// No description provided for @systemMonitorUICheckLayout.
  ///
  /// In en, this message translates to:
  /// **'Recommend checking UI layout'**
  String get systemMonitorUICheckLayout;

  /// No description provided for @systemMonitorUIOptimize.
  ///
  /// In en, this message translates to:
  /// **'Need to optimize UI responsive design'**
  String get systemMonitorUIOptimize;

  /// No description provided for @noNetworkReturnMessage.
  ///
  /// In en, this message translates to:
  /// **'Please check your device network status(mobile-data/wifi is on)'**
  String get noNetworkReturnMessage;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
