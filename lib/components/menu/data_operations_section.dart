import 'package:hk_transport_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import '../../scripts/utils/settings_service.dart';
import '../../scripts/notifications/notification_service.dart';
import '../../scripts/notifications/notification_tracking_service.dart';
import '../../scripts/notifications/notification_preferences_service.dart';
import '../../l10n/locale_utils.dart';

class DataOperationsSection extends StatelessWidget {
  final Future<void> Function() onRefreshKMB;
  final bool expanded;
  final ValueChanged<bool> onExpansionChanged;
  final ExpansionTileController controller;

  const DataOperationsSection({
    super.key,
    required this.onRefreshKMB,
    required this.expanded,
    required this.onExpansionChanged,
    required this.controller,
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
        controller: controller,
        maintainState: true,
        initiallyExpanded: expanded,
        onExpansionChanged: onExpansionChanged,
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
          ValueListenableBuilder<bool>(
            valueListenable: SettingsService.apiReviewEnabledNotifier,
            builder: (context, value, _) => SwitchListTile(
              secondary: const Icon(Icons.api),
              title: Text(AppLocalizations.of(context)!.dataOpsApiReviewToggle),
              value: value,
              onChanged: (v) => SettingsService.setApiReviewEnabled(v),
            ),
          ),
          const SizedBox(height: 4),
          ValueListenableBuilder<bool>(
            valueListenable: SettingsService.notificationPermissionEnabledNotifier,
            builder: (context, value, _) {
              final isZh = LocaleUtils.isChinese(context);
              return SwitchListTile(
                secondary: const Icon(Icons.notifications),
                title: Text(isZh ? '通知權限' : 'Notification Permission'),
                subtitle: Text(
                  isZh
                      ? '允許應用程式發送通知'
                      : 'Allow app to send notifications',
                ),
                value: value,
                onChanged: (v) => _handleNotificationPermissionToggle(context, v),
              );
            },
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

  Future<void> _handleNotificationPermissionToggle(
      BuildContext context, bool enabled) async {
    if (enabled) {
      // Request permission when enabling
      final notificationService = NotificationService();
      final hasPermission = await notificationService.hasPermission();
      
      if (!hasPermission) {
        final granted = await notificationService.requestPermission();
        if (!granted) {
          // Permission denied, don't enable the toggle
          if (context.mounted) {
            final isZh = LocaleUtils.isChinese(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(isZh
                    ? '需要通知權限才能啟用此功能'
                    : 'Notification permission is required to enable this feature'),
              ),
            );
          }
          return;
        }
      }
      
      // Permission granted, enable the setting
      await SettingsService.setNotificationPermissionEnabled(true);
      
      // Start tracking if there are tracked bookmarks
      final trackingService = NotificationTrackingService();
      final trackedBookmarks = await NotificationPreferencesService.getTrackedBookmarks();
      final trackedMTRBookmarks = await NotificationPreferencesService.getTrackedMTRBookmarks();
      if (trackedBookmarks.isNotEmpty || trackedMTRBookmarks.isNotEmpty) {
        await trackingService.startTracking();
      }
    } else {
      // Disable notification permission
      await SettingsService.setNotificationPermissionEnabled(false);
      
      // Stop tracking
      final trackingService = NotificationTrackingService();
      trackingService.stopTracking();
    }
  }
}
