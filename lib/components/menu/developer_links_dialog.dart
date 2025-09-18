import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/app_localizations.dart';

class DeveloperLinksDialog {
  static Future<void> show(BuildContext context) async {
    if (!context.mounted) return;

    await showDialog(
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
              if (context.mounted) Navigator.of(ctx).pop();
            },
            child: Text(AppLocalizations.of(context)!.github),
          ),
        ],
      ),
    );
  }
}
