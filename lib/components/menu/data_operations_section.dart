import 'package:hk_transport_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import '../../scripts/utils/settings_service.dart';

class DataOperationsSection extends StatelessWidget {
  final Future<void> Function() onRefreshKMB;

  const DataOperationsSection({
    super.key,
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
          ValueListenableBuilder<bool>(
            valueListenable: SettingsService.showSubtitleNotifier,
            builder: (context, value, _) => SwitchListTile(
              secondary: const Icon(Icons.subtitles),
              title: Text(AppLocalizations.of(context)!.dataOpsSubtitleToggle),
              value: value,
              onChanged: (v) => SettingsService.setShowSubtitle(v),
            ),
          ),
          const SizedBox(height: 4),
          ValueListenableBuilder<bool>(
            valueListenable: SettingsService.vibrationEnabledNotifier,
            builder: (context, value, _) => SwitchListTile(
              secondary: const Icon(Icons.vibration),
              title: Text(AppLocalizations.of(context)!.dataOpsVibrationToggle),
              value: value,
              onChanged: (v) => SettingsService.setVibrationEnabled(v),
            ),
          ),
          const SizedBox(height: 4),
          ValueListenableBuilder<bool>(
            valueListenable: SettingsService.showSpecialRoutesNotifier,
            builder: (context, value, _) => SwitchListTile(
              secondary: const Icon(Icons.filter_alt),
              title: Text(AppLocalizations.of(context)!.dataOpsSpecialToggle),
              value: value,
              onChanged: (v) => SettingsService.setShowSpecialRoutes(v),
            ),
          ),
          const SizedBox(height: 4),
          ValueListenableBuilder<bool>(
            valueListenable: SettingsService.displayBusFullNameNotifier,
            builder: (context, value, _) => SwitchListTile(
              secondary: const Icon(Icons.badge),
              title:
                  Text(AppLocalizations.of(context)!.dataOpsDisplayBusFullName),
              value: value,
              onChanged: (v) => SettingsService.setDisplayBusFullName(v),
            ),
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
          ValueListenableBuilder<bool>(
            valueListenable: SettingsService.mtrAutoRefreshNotifier,
            builder: (context, value, _) => SwitchListTile(
              secondary: const Icon(Icons.autorenew),
              title: Text(AppLocalizations.of(context)!.dataOpsMtrAutoRefresh),
              value: value,
              onChanged: (v) => SettingsService.setMtrAutoRefresh(v),
            ),
          ),
          const SizedBox(height: 4),
          ValueListenableBuilder<bool>(
            valueListenable: SettingsService.openAppAnimationEnabledNotifier,
            builder: (context, value, _) => SwitchListTile(
              secondary: const Icon(Icons.play_circle),
              title:
                  Text(AppLocalizations.of(context)!.dataOpsOpenAppAnimation),
              value: value,
              onChanged: (v) => SettingsService.setOpenAppAnimationEnabled(v),
            ),
          ),
          const SizedBox(height: 4),
          ListTile(
            leading: const Icon(Icons.sync),
            title: Text(AppLocalizations.of(context)!.dataOpsRefreshKMB),
            trailing: IconButton(
              onPressed: onRefreshKMB,
              icon: const Icon(Icons.refresh),
              tooltip: AppLocalizations.of(context)!.dataOpsRefreshNow,
            ),
          ),
        ],
      ),
    );
  }
}
