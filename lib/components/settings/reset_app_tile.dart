import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../scripts/kmb/kmb_cache_service.dart';
import '../ui/splash_screen.dart';
import '../../scripts/kmb/kmb_api_service.dart';
import '../../scripts/utils/first_time_service.dart';
// TODO: Uncomment after running flutter gen-l10n
import '../../l10n/app_localizations.dart';

class ResetAppTile extends StatefulWidget {
  const ResetAppTile({super.key});

  @override
  State<ResetAppTile> createState() => _ResetAppTileState();
}

class _ResetAppTileState extends State<ResetAppTile> {
  bool _isResetting = false;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Column(
      children: [
        ListTile(
          title: Text(loc.resetAppTitle),
          leading: const Icon(Icons.delete_forever, color: Colors.red),
          trailing: _isResetting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : TextButton(
                  onPressed: _confirmAndReset,
                  child: Text(
                    loc.resetButton,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
        ),
        const Divider(),
      ],
    );
  }

  Future<void> _confirmAndReset() async {
    final loc = AppLocalizations.of(context)!;
    // TODO: Replace with loc.resetAppDialogTitle after running flutter gen-l10n
    final dialogTitle = 'Reset App'; // loc.resetAppDialogTitle
    // TODO: Replace with loc.resetAppDialogContent after running flutter gen-l10n
    final dialogContent =
        'This will clear caches, bookmarks and preferences.'; // loc.resetAppDialogContent
    // TODO: Replace with loc.cancel after running flutter gen-l10n
    final cancelText = 'Cancel'; // loc.cancel

    final shouldReset = await showDialog<bool>(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text(dialogTitle),
              content: Text(dialogContent),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: Text(cancelText),
                ),
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: Text(
                    loc.resetButton,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
    if (!shouldReset) return;

    setState(() {
      _isResetting = true;
    });
    try {
      // Clear KMB cache
      await KMBCacheService.clearCache();

      // Clear SharedPreferences keys used by the app
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('kmb_bookmarks_v1');
      await prefs.remove('mtr_bookmarks_v1');
      await prefs.remove('last_platform');
      // Reset first-time guide flag
      await FirstTimeService.reset();

      // Remove per-route-stop cache entries
      final keys = prefs.getKeys();
      for (final k in keys) {
        if (k.startsWith('kmb_route_stops_') ||
            k.startsWith('kmb_route_stops_timestamp_')) {
          await prefs.remove(k);
        }
      }

      // Prefetch fresh KMB data
      try {
        await KMBApiService.getAllRoutes();
      } catch (_) {}
      try {
        await KMBApiService.getAllStops();
      } catch (_) {}

      if (!mounted) return;

      // Restart to splash
      Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (_, __, ___) => const SplashScreen(),
          transitionsBuilder: (_, animation, __, child) => FadeTransition(
            opacity: animation,
            child: child,
          ),
        ),
        (route) => false,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isResetting = false;
        });
      }
    }
  }
}
