import 'dart:async';
import 'package:flutter/material.dart';
import 'components/kmb/kmb_screen_refactored.dart';
import 'components/menu.dart';
import 'components/ui/bottom_nav_bar.dart';
import 'components/mtr/mtr_list_screen.dart';
import 'components/bookmarks/bookmark_page.dart';
import 'components/ui/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hk_transport_app/l10n/app_localizations.dart';
import 'scripts/locale/locale_service.dart';
import 'scripts/theme/theme_service.dart';
import 'scripts/utils/settings_service.dart';
import 'services/widget_service.dart';
import 'scripts/ctb/ctb_api_service.dart';

// Global system info storage
class SystemInfo {
  static double? textScaleFactor;
  static double? devicePixelRatio;
  static Size? screenSize;
  static Brightness? platformBrightness;
  static EdgeInsets? viewInsets;
  static EdgeInsets? padding;
  static bool hasLogged = false;

  static void logSystemInfo(BuildContext context) {
    if (hasLogged) return;

    final mediaQuery = MediaQuery.of(context);
    textScaleFactor = mediaQuery.textScaleFactor;
    devicePixelRatio = mediaQuery.devicePixelRatio;
    screenSize = mediaQuery.size;
    platformBrightness = mediaQuery.platformBrightness;
    viewInsets = mediaQuery.viewInsets;
    padding = mediaQuery.padding;
    hasLogged = true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeService.initialize();
  await SettingsService.load();
  await WidgetService.initialize();
  unawaited(
    CTBApiService.getAllRoutes().then((_) {}, onError: (_) {}),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale?>(
      valueListenable: LocaleService.localeNotifier,
      builder: (context, appLocale, _) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: ThemeService.themeNotifier,
          builder: (context, themeMode, _) {
            return MaterialApp(
              onGenerateTitle: (context) =>
                  AppLocalizations.of(context)!.appTitle,
              debugShowCheckedModeBanner: false,
              builder: (context, child) {
                // Log system info once when app starts
                SystemInfo.logSystemInfo(context);
                return child!;
              },
              theme: ThemeService.getLightTheme(),
              darkTheme: ThemeService.getDarkTheme(),
              themeMode: themeMode,
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                AppLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en'),
                Locale('zh', 'HK'),
              ],
              localeResolutionCallback: (deviceLocale, supportedLocales) {
                final l = deviceLocale;
                if (l == null) return const Locale('en');
                final isChinese = l.languageCode == 'zh';
                final isChineseRegion = const {'CN', 'TW', 'HK', 'MO'}
                    .contains(l.countryCode?.toUpperCase());
                final isHantScript = (l.scriptCode?.toLowerCase() == 'hant');
                if (isChinese && (isChineseRegion || isHantScript)) {
                  return const Locale('zh', 'HK');
                }
                return const Locale('en');
              },
              locale: appLocale,
              home: ValueListenableBuilder<bool>(
                valueListenable:
                    SettingsService.openAppAnimationEnabledNotifier,
                builder: (_, allowAnimation, __) {
                  return SplashScreen(allowAnimation: allowAnimation);
                },
              ),
            );
          },
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  final bool initialIsMTR;
  const MyHomePage({super.key, this.initialIsMTR = true});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  bool _isMTRMode = true;

  @override
  void initState() {
    super.initState();
    _isMTRMode = widget.initialIsMTR;
  }

  Future<void> _persistPlatform(bool isMTR) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_platform', isMTR ? 'MTR' : 'KMB');
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = <Widget>[
      const BookmarkPage(),
      _isMTRMode ? const MTRListScreen() : const KMBTestScreenRefactored(),
      const MenuScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        isMTRMode: _isMTRMode,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        onModeToggle: () async {
          final newValue = !_isMTRMode;
          setState(() {
            _isMTRMode = newValue;
          });
          await _persistPlatform(newValue);
        },
      ),
    );
  }
}
