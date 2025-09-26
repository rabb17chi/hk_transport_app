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
    Locale('zh'),
    Locale('zh', 'HK')
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
  /// **'System Default'**
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
  /// **'System Default'**
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

  /// No description provided for @menuWidgetTitle.
  ///
  /// In en, this message translates to:
  /// **'Desktop Widgets'**
  String get menuWidgetTitle;

  /// No description provided for @widgetUpdateKMB.
  ///
  /// In en, this message translates to:
  /// **'Update KMB Widget'**
  String get widgetUpdateKMB;

  /// No description provided for @widgetUpdateKMBSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update widget with favorite KMB route'**
  String get widgetUpdateKMBSubtitle;

  /// No description provided for @widgetUpdateMTR.
  ///
  /// In en, this message translates to:
  /// **'Update MTR Widget'**
  String get widgetUpdateMTR;

  /// No description provided for @widgetUpdateMTRSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update widget with MTR station info'**
  String get widgetUpdateMTRSubtitle;

  /// No description provided for @widgetUpdateNow.
  ///
  /// In en, this message translates to:
  /// **'Update Now'**
  String get widgetUpdateNow;

  /// No description provided for @widgetUpdated.
  ///
  /// In en, this message translates to:
  /// **'Widget updated successfully'**
  String get widgetUpdated;

  /// No description provided for @widgetClear.
  ///
  /// In en, this message translates to:
  /// **'Clear Widget'**
  String get widgetClear;

  /// No description provided for @widgetClearSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Remove all widget data'**
  String get widgetClearSubtitle;

  /// No description provided for @widgetClearNow.
  ///
  /// In en, this message translates to:
  /// **'Clear Now'**
  String get widgetClearNow;

  /// No description provided for @widgetCleared.
  ///
  /// In en, this message translates to:
  /// **'Widget cleared successfully'**
  String get widgetCleared;

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

  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh': {
  switch (locale.countryCode) {
    case 'HK': return AppLocalizationsZhHk();
   }
  break;
   }
  }

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
