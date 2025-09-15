import 'package:flutter/material.dart';
import 'components/kmb/kmb_screen_refactored.dart';
import 'components/menu.dart';
import 'components/bottom_nav_bar.dart';
import 'components/mtr/mtr_list_screen.dart';
import 'components/bookmarks/bookmark_page.dart';
import 'components/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hk_transport_app/l10n/app_localizations.dart';
import 'scripts/locale_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale?>(
      valueListenable: LocaleService.localeNotifier,
      builder: (context, appLocale, _) {
        return MaterialApp(
          onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          ),
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
          home: const SplashScreen(),
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
