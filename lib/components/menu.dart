import 'package:flutter/material.dart';
import 'package:hk_transport_app/l10n/app_localizations.dart';
import '../scripts/kmb_cache_service.dart';
import '../../scripts/kmb_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'menu/data_operations_section.dart';
import 'settings/reset_app_tile.dart';
import 'package:url_launcher/url_launcher.dart';
import '../scripts/locale_service.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  bool _isRefreshing = false;
  // Reset UI moved to ResetAppTile
  bool _langExpanded = false;
  bool _themeExpanded = false;
  Key _langKey = UniqueKey();
  Key _themeKey = UniqueKey();
  bool _showSpecialRoutes = false; // Toggle for special KMB routes (2/5)

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
          DataOperationsSection(
            showSpecialRoutes: _showSpecialRoutes,
            onToggleSpecialRoutes: (v) async {
              setState(() {
                _showSpecialRoutes = v;
              });
              await _setShowSpecialRoutes(v);
            },
            onRefreshKMB: _refreshCache,
          ),
          const Divider(),
          _buildThemeSection(),
          const Divider(),
          ListTile(
            title: Text(AppLocalizations.of(context)!.menuStyle),
            subtitle: Text(AppLocalizations.of(context)!.menuStyleSubtitle),
            leading: const Icon(Icons.format_paint),
          ),
          const Divider(),
          ListTile(
            title: Text(AppLocalizations.of(context)!.menuTerms),
            subtitle: Text(AppLocalizations.of(context)!.menuTermsSubtitle),
            leading: const Icon(Icons.description),
          ),
          const Divider(),
          ListTile(
            title: Text(AppLocalizations.of(context)!.menuDevLinks),
            subtitle: Text(AppLocalizations.of(context)!.menuDevLinksSubtitle),
            leading: const Icon(Icons.link),
            onTap: _routeToGithub,
          ),
          const Divider(),
          _buildLanguageSection(),
          const Divider(),
          const ResetAppTile(),
        ],
      ),
    );
  }

  Future<void> _setShowSpecialRoutes(bool value) async {
    await setShowSpecialRoutes(context, value);
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
    return ExpansionTile(
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
      onExpansionChanged: (expanded) {
        setState(() {
          _langExpanded = expanded;
          if (expanded) {
            _themeExpanded = false;
            _themeKey = UniqueKey();
          }
        });
      },
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
    );
  }

  Widget _buildThemeSection() {
    final loc = AppLocalizations.of(context)!;
    return ExpansionTile(
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
      onExpansionChanged: (expanded) {
        setState(() {
          _themeExpanded = expanded;
          if (expanded) {
            _langExpanded = false;
            _langKey = UniqueKey();
          }
        });
      },
      childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      children: [
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${loc.themeLight} - coming soon')),
                  );
                },
                child: Text(loc.themeLight),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${loc.themeDark} - coming soon')),
                  );
                },
                child: Text(loc.themeDark),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('${loc.themeSystemDefault} - coming soon')),
                  );
                },
                child: Text(loc.themeSystemDefault),
              ),
            ),
          ],
        )
      ],
    );
  }
}
