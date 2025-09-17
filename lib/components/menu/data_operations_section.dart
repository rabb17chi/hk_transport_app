import 'package:hk_transport_app/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
// removed duplicate import
import '../../scripts/utils/settings_service.dart';

class DataOperationsSection extends StatelessWidget {
  final bool showSpecialRoutes;
  final ValueChanged<bool> onToggleSpecialRoutes;
  final Future<void> Function() onRefreshKMB;

  const DataOperationsSection({
    super.key,
    required this.showSpecialRoutes,
    required this.onToggleSpecialRoutes,
    required this.onRefreshKMB,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTileTheme(
      data: const ExpansionTileThemeData(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.transparent, width: 0),
        ),
        collapsedShape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.transparent, width: 0),
        ),
      ),
      child: ExpansionTile(
        leading: const Icon(Icons.tune),
        title: Text(AppLocalizations.of(context)!.menuDataOpsTitle),
        trailing: const SizedBox.shrink(),
        children: [
          SwitchListTile(
            secondary: const Icon(Icons.filter_alt),
            title: Text(AppLocalizations.of(context)!.dataOpsSpecialToggle),
            value: showSpecialRoutes,
            onChanged: onToggleSpecialRoutes,
          ),
          const SizedBox(height: 4),
          ValueListenableBuilder<bool>(
            valueListenable: SettingsService.mtrReverseStationsNotifier,
            builder: (context, value, _) => SwitchListTile(
              secondary: const Icon(Icons.swap_vert),
              title: Text(AppLocalizations.of(context)!.dataOpsMtrReverse),
              value: value,
              onChanged: (v) => SettingsService.setMtrReverseStations(v),
            ),
          ),
          const SizedBox(height: 4),
          ListTile(
            leading: const Icon(Icons.sync),
            title: Text(AppLocalizations.of(context)!.dataOpsRefreshKMB),
            trailing: TextButton(
              onPressed: onRefreshKMB,
              child: Text(AppLocalizations.of(context)!.dataOpsRefreshNow),
            ),
          ),
        ],
      ),
    );
  }
}

/// Persist and notify special-routes toggle
Future<void> setShowSpecialRoutes(BuildContext context, bool value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('showSpecialRoutes', value);
}
