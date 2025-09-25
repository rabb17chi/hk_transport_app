import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:hk_transport_app/l10n/app_localizations.dart';
import '../scripts/kmb/kmb_cache_service.dart';
import '../../scripts/kmb/kmb_api_service.dart';
import 'menu/data_operations_section.dart';
import 'menu/app_use_guide_dialog.dart';
import 'menu/language_section.dart';
import 'menu/theme_section.dart';
import 'menu/developer_links_dialog.dart';
import 'menu/system_monitor_section.dart';
import 'menu/widget_settings_section.dart';
import 'settings/reset_app_tile.dart';

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

  // Index-based expansion system
  int? _selectedIndex;

  // Menu item indices
  static const int _dataOperationsIndex = 0;
  static const int _systemMonitorIndex = 1;
  static const int _widgetIndex = 2;
  static const int _themeIndex = 3;
  static const int _styleIndex = 4;
  static const int _termsIndex = 5;
  static const int _devLinksIndex = 6;
  static const int _languageIndex = 7;
  static const int _resetIndex = 8;

  bool get _isDev => !kReleaseMode;

  @override
  void initState() {
    super.initState();
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
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          children: [
            Container(child: _buildThemeSection()),
            const Divider(),
            Container(child: _buildLanguageSection()),
            const Divider(),
            Container(child: _buildDataOperationsSection()),
            // const Divider(),
            // Container(color: Colors.grey[300], child: _buildWidgetSection()),
            const Divider(),
            Container(
              child: _buildAppUseGuide(),
            ),
            const Divider(),
            Container(
              color: Colors.grey[300],
              child: _buildStyleTile(),
            ),
            const Divider(),
            Container(child: _buildDevLinksTile()),
            const Divider(),
            Container(
              color: Colors.grey[300],
              child: _buildTermsTile(),
            ),
            const Divider(),
            Container(child: _buildResetTile()),
            if (_isDev) Container(child: _buildSystemMonitorSection()),
          ],
        ),
      ),
    );
  }

  void _onItemTap(int index) {
    setState(() {
      if (_selectedIndex == index) {
        _selectedIndex = null;
        _langExpanded = false;
        _themeExpanded = false;
      } else {
        _selectedIndex = index;
        _langExpanded = false;
        _themeExpanded = false;
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
        onRefreshKMB: _refreshCache,
      ),
    );
  }

  Widget _buildSystemMonitorSection() {
    return GestureDetector(
      onTap: () => _onItemTap(_systemMonitorIndex),
      child: const SystemMonitorSection(),
    );
  }

  Widget _buildWidgetSection() {
    return GestureDetector(
      onTap: () => _onItemTap(_widgetIndex),
      child: const WidgetSettingsSection(),
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
        DeveloperLinksDialog.show(context);
      },
    );
  }

  Widget _buildResetTile() {
    return GestureDetector(
      onTap: () => _onItemTap(_resetIndex),
      child: const ResetAppTile(),
    );
  }

  Widget _buildLanguageSection() {
    return LanguageSection(
      langKey: _langKey,
      langExpanded: _langExpanded,
      onTap: () => _onItemTap(_languageIndex),
    );
  }

  Widget _buildThemeSection() {
    return ThemeSection(
      themeKey: _themeKey,
      themeExpanded: _themeExpanded,
      onTap: () => _onItemTap(_themeIndex),
    );
  }

  Widget _buildAppUseGuide() {
    final loc = AppLocalizations.of(context)!;
    return ListTile(
      leading: const Icon(Icons.help_outline),
      title: Text(loc.appUseGuide),
      subtitle: Text(loc.appUseGuideSubtitle),
      onTap: () => _showAppUseGuideDialog(),
    );
  }

  void _showAppUseGuideDialog() {
    showDialog(
      context: context,
      builder: (context) => const AppUseGuideDialog(),
    );
  }
}
