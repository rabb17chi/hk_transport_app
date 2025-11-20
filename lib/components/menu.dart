import 'package:flutter/material.dart';
import 'package:hk_transport_app/l10n/app_localizations.dart';
import '../scripts/kmb/kmb_cache_service.dart';
import '../scripts/ctb/ctb_api_service.dart';
import '../../scripts/kmb/kmb_api_service.dart';
import 'menu/data_operations_section.dart';
import 'menu/app_use_guide_dialog.dart';
import 'menu/language_section.dart';
import 'menu/theme_section.dart';
import 'menu/developer_links_dialog.dart';
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
  bool _dataOpsExpanded = false;

  late final ExpansibleController _dataOpsController;
  late final ExpansibleController _themeController;
  late final ExpansibleController _languageController;

  @override
  void initState() {
    super.initState();
    _dataOpsController = ExpansibleController();
    _themeController = ExpansibleController();
    _languageController = ExpansibleController();
  }

  @override
  void dispose() {
    _dataOpsController.dispose();
    _themeController.dispose();
    _languageController.dispose();
    super.dispose();
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
      await CTBApiService.getAllRoutes();
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
            const Divider(),
            Container(
              child: _buildAppUseGuide(),
            ),
            const Divider(),
            Container(
              child: _buildStyleTile(),
            ),
            const Divider(),
            Container(child: _buildDevLinksTile()),
            const Divider(),
            Container(
              child: _buildTermsTile(),
            ),
            const Divider(),
            Container(child: _buildResetTile()),
          ],
        ),
      ),
    );
  }

  void _onSectionExpansionChanged(_TrackedSection section, bool expanded) {
    if (expanded) {
      switch (section) {
        case _TrackedSection.dataOps:
          if (_themeExpanded) {
            _themeController.collapse();
          }
          if (_langExpanded) {
            _languageController.collapse();
          }
          break;
        case _TrackedSection.theme:
          if (_dataOpsExpanded) {
            _dataOpsController.collapse();
          }
          if (_langExpanded) {
            _languageController.collapse();
          }
          break;
        case _TrackedSection.language:
          if (_dataOpsExpanded) {
            _dataOpsController.collapse();
          }
          if (_themeExpanded) {
            _themeController.collapse();
          }
          break;
      }
    }

    setState(() {
      if (section == _TrackedSection.dataOps) {
        _dataOpsExpanded = expanded;
        if (expanded) {
          _themeExpanded = false;
          _langExpanded = false;
        }
      } else if (section == _TrackedSection.theme) {
        _themeExpanded = expanded;
        if (expanded) {
          _dataOpsExpanded = false;
          _langExpanded = false;
        }
      } else if (section == _TrackedSection.language) {
        _langExpanded = expanded;
        if (expanded) {
          _dataOpsExpanded = false;
          _themeExpanded = false;
        }
      }
    });
  }

  Widget _buildDataOperationsSection() {
    return DataOperationsSection(
      controller: _dataOpsController,
      expanded: _dataOpsExpanded,
      onExpansionChanged: (expanded) =>
          _onSectionExpansionChanged(_TrackedSection.dataOps, expanded),
      onRefreshKMB: _refreshCache,
    );
  }

  Widget _buildStyleTile() {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.menuStyle),
      subtitle: Text(AppLocalizations.of(context)!.menuStyleSubtitle),
      leading: const Icon(Icons.format_paint),
      onTap: () {},
    );
  }

  Widget _buildTermsTile() {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.menuTerms),
      subtitle: Text(AppLocalizations.of(context)!.menuTermsSubtitle),
      leading: const Icon(Icons.description),
      onTap: () {},
    );
  }

  Widget _buildDevLinksTile() {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.menuDevLinks),
      // subtitle: Text(AppLocalizations.of(context)!.menuDevLinksSubtitle),
      leading: const Icon(Icons.code),
      onTap: () {
        DeveloperLinksDialog.show(context);
      },
    );
  }

  Widget _buildResetTile() {
    return const ResetAppTile();
  }

  Widget _buildLanguageSection() {
    return LanguageSection(
      langExpanded: _langExpanded,
      controller: _languageController,
      onExpansionChanged: (expanded) =>
          _onSectionExpansionChanged(_TrackedSection.language, expanded),
    );
  }

  Widget _buildThemeSection() {
    return ThemeSection(
      themeExpanded: _themeExpanded,
      controller: _themeController,
      onExpansionChanged: (expanded) =>
          _onSectionExpansionChanged(_TrackedSection.theme, expanded),
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

enum _TrackedSection { dataOps, theme, language }
