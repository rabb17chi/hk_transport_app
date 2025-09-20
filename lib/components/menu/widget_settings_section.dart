import 'package:flutter/material.dart';
import 'package:hk_transport_app/l10n/app_localizations.dart';
import '../../services/widget_service.dart';

class WidgetSettingsSection extends StatelessWidget {
  const WidgetSettingsSection({super.key});

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
        leading: const Icon(Icons.widgets),
        title: Text(AppLocalizations.of(context)!.menuWidgetTitle),
        trailing: const SizedBox.shrink(),
        children: [
          ListTile(
            leading: const Icon(Icons.directions_bus),
            title: Text(AppLocalizations.of(context)!.widgetUpdateKMB),
            subtitle:
                Text(AppLocalizations.of(context)!.widgetUpdateKMBSubtitle),
            trailing: TextButton(
              onPressed: () async {
                await WidgetService.updateWithFavoriteRoute();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text(AppLocalizations.of(context)!.widgetUpdated),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: Text(AppLocalizations.of(context)!.widgetUpdateNow),
            ),
          ),
          const SizedBox(height: 4),
          ListTile(
            leading: const Icon(Icons.train),
            title: Text(AppLocalizations.of(context)!.widgetUpdateMTR),
            subtitle:
                Text(AppLocalizations.of(context)!.widgetUpdateMTRSubtitle),
            trailing: TextButton(
              onPressed: () async {
                await WidgetService.updateMTRWidget(
                  station: 'Central',
                  line: 'TWL',
                  nextTrain: 'Next: 3 mins',
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text(AppLocalizations.of(context)!.widgetUpdated),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: Text(AppLocalizations.of(context)!.widgetUpdateNow),
            ),
          ),
          const SizedBox(height: 4),
          ListTile(
            leading: const Icon(Icons.clear),
            title: Text(AppLocalizations.of(context)!.widgetClear),
            subtitle: Text(AppLocalizations.of(context)!.widgetClearSubtitle),
            trailing: TextButton(
              onPressed: () async {
                await WidgetService.clearWidgetData();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text(AppLocalizations.of(context)!.widgetCleared),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: Text(AppLocalizations.of(context)!.widgetClearNow),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.bug_report),
            title: const Text('Test Widget'),
            subtitle: const Text('Send test data to widget'),
            trailing: TextButton(
              onPressed: () async {
                await WidgetService.testWidget();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Test data sent to widget')),
                  );
                }
              },
              child: const Text('Test'),
            ),
          ),
        ],
      ),
    );
  }
}
