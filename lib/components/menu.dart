import 'package:flutter/material.dart';
import 'package:hk_transport_app/l10n/app_localizations.dart';
import '../scripts/kmb/kmb_cache_service.dart';
import '../../scripts/kmb/kmb_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'menu/data_operations_section.dart';
import 'settings/reset_app_tile.dart';
import 'package:url_launcher/url_launcher.dart';
import '../scripts/locale/locale_service.dart';
import '../scripts/theme/theme_service.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  // ignore: unused_field
  bool _isRefreshing = false;
  bool _langExpanded = false;
  bool _themeExpanded = false;
  Key _langKey = UniqueKey();
  Key _themeKey = UniqueKey();
  bool _showSpecialRoutes = false; // Toggle for special KMB routes (2/5)

  // Index-based expansion system
  int? _selectedIndex;

  // Menu item indices
  static const int _dataOperationsIndex = 0;
  static const int _themeIndex = 1;
  static const int _styleIndex = 2;
  static const int _termsIndex = 3;
  static const int _devLinksIndex = 4;
  static const int _languageIndex = 5;
  static const int _resetIndex = 6;

  @override
  void initState() {
    super.initState();
    _loadShowSpecialPref();
  }

  Future<void> _refreshCache() async {
    setState(() {
      _isRefreshing = true;
    });
    await KMBCacheService.clearCache();
    // Immediately fetch fresh data to warm cache and make data available now
    try {
      await KMBApiService.getAllRoutes();
      await KMBApiService.getAllStops();
    } catch (_) {}
    setState(() {
      _isRefreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          _buildDataOperationsSection(),
          const Divider(),
          _buildThemeSection(),
          const Divider(),
          _buildStyleTile(),
          const Divider(),
          _buildTermsTile(),
          const Divider(),
          _buildDevLinksTile(),
          const Divider(),
          _buildLanguageSection(),
          const Divider(),
          _buildResetTile(),
        ],
      ),
    );
  }

  Future<void> _setShowSpecialRoutes(bool value) async {
    await setShowSpecialRoutes(context, value);
  }

  void _onItemTap(int index) {
    setState(() {
      if (_selectedIndex == index) {
        // If clicking the same item, close it
        _selectedIndex = null;
        _langExpanded = false;
        _themeExpanded = false;
      } else {
        // Open the selected item and close all others
        _selectedIndex = index;
        // Reset all expansion states first
        _langExpanded = false;
        _themeExpanded = false;
        // Then set the correct expansion state
        if (index == _languageIndex) {
          _langExpanded = true;
        } else if (index == _themeIndex) {
          _themeExpanded = true;
        }
      }
    });
  }

  Widget _buildDataOperationsSection() {
    return GestureDetector(
      onTap: () => _onItemTap(_dataOperationsIndex),
      child: DataOperationsSection(
        showSpecialRoutes: _showSpecialRoutes,
        onToggleSpecialRoutes: (v) async {
          setState(() {
            _showSpecialRoutes = v;
          });
          await _setShowSpecialRoutes(v);
        },
        onRefreshKMB: _refreshCache,
      ),
    );
  }

  Widget _buildStyleTile() {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.menuStyle),
      subtitle: Text(AppLocalizations.of(context)!.menuStyleSubtitle),
      leading: const Icon(Icons.format_paint),
      onTap: () => _onItemTap(_styleIndex),
    );
  }

  Widget _buildTermsTile() {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.menuTerms),
      subtitle: Text(AppLocalizations.of(context)!.menuTermsSubtitle),
      leading: const Icon(Icons.description),
      onTap: () => _onItemTap(_termsIndex),
    );
  }

  Widget _buildDevLinksTile() {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.menuDevLinks),
      // subtitle: Text(AppLocalizations.of(context)!.menuDevLinksSubtitle),
      leading: const Icon(Icons.code),
      onTap: () {
        _onItemTap(_devLinksIndex);
        _routeToGithub();
      },
    );
  }

  Widget _buildResetTile() {
    return GestureDetector(
      onTap: () => _onItemTap(_resetIndex),
      child: const ResetAppTile(),
    );
  }

  // Reset behavior moved to ResetAppTile
  Future<void> _routeToGithub() async {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.devLinksDialogTitle),
        content: Text(AppLocalizations.of(context)!.devLinksDialogContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(AppLocalizations.of(context)!.back),
          ),
          TextButton(
            onPressed: () async {
              final uri =
                  Uri.parse('https://github.com/rabb17chi/hk_transport_app');
              await launchUrl(uri, mode: LaunchMode.externalApplication);
              if (mounted) Navigator.of(ctx).pop();
            },
            child: Text(AppLocalizations.of(context)!.github),
          ),
        ],
      ),
    );
  }

  Future<void> _loadShowSpecialPref() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final value = prefs.getBool('showSpecialRoutes') ?? false;
      if (mounted) {
        setState(() {
          _showSpecialRoutes = value;
        });
      }
    } catch (_) {}
  }

  Widget _buildLanguageSection() {
    final loc = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () => _onItemTap(_languageIndex),
      child: ExpansionTile(
        key: _langKey,
        leading: const Icon(Icons.language),
        title: Text(loc.languageSectionTitle),
        trailing: const SizedBox.shrink(),
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: Colors.transparent, width: 0),
          borderRadius: BorderRadius.all(Radius.circular(0)),
        ),
        collapsedShape: const RoundedRectangleBorder(
          side: BorderSide(color: Colors.transparent, width: 0),
          borderRadius: BorderRadius.all(Radius.circular(0)),
        ),
        initiallyExpanded: _langExpanded,
        onExpansionChanged: null, // Use centralized _onItemTap logic
        tilePadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 4,
        ),
        childrenPadding:
            const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
        children: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () async {
                    await LocaleService.setLocale(const Locale('en'));
                  },
                  child: const Text('English'),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () async {
                    await LocaleService.setLocale(const Locale('zh', 'HK'));
                  },
                  child: const Text('繁體中文'),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () async {
                    await LocaleService.setLocale(null);
                  },
                  child: Text(loc.languageSystemDefault),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildThemeSection() {
    final loc = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () => _onItemTap(_themeIndex),
      child: ExpansionTile(
        key: _themeKey,
        leading: const Icon(Icons.color_lens),
        title: Text(loc.themeSectionTitle),
        trailing: const SizedBox.shrink(),
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: Colors.transparent, width: 0),
          borderRadius: BorderRadius.all(Radius.circular(0)),
        ),
        collapsedShape: const RoundedRectangleBorder(
          side: BorderSide(color: Colors.transparent, width: 0),
          borderRadius: BorderRadius.all(Radius.circular(0)),
        ),
        initiallyExpanded: _themeExpanded,
        onExpansionChanged: null, // Use centralized _onItemTap logic
        tilePadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 4,
        ),
        childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
        children: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () async {
                    await ThemeService.setTheme(ThemeMode.light);
                  },
                  child: Text(loc.themeLight),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () async {
                    await ThemeService.setTheme(ThemeMode.dark);
                  },
                  child: Text(loc.themeDark),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () async {
                    await ThemeService.setTheme(ThemeMode.system);
                  },
                  child: Text(loc.themeSystemDefault),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
