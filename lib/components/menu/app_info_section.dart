import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// TODO: Re-enable after running flutter gen-l10n
// import '../../l10n/app_localizations.dart';

class AppInfoSection extends StatelessWidget {
  const AppInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with loc.appInfoSectionTitle after running flutter gen-l10n
    return ExpansionTile(
      maintainState: true,
      leading: const Icon(Icons.info_outline),
      title: const Text('App Information'),
      trailing: const SizedBox.shrink(),
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: Colors.transparent, width: 0),
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      collapsedShape: const RoundedRectangleBorder(
        side: BorderSide(color: Colors.transparent, width: 0),
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      tilePadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      childrenPadding:
          const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      children: [
        // TODO: Replace with loc.appInfoVersion after running flutter gen-l10n
        _buildInfoRow(
          context,
          'Version',
          '1.0.0',
          Icons.tag,
        ),
        const SizedBox(height: 8),
        // TODO: Replace with loc.appInfoDescription and loc.appInfoDescriptionText after running flutter gen-l10n
        _buildInfoRow(
          context,
          'Description',
          'HK Transport App - Check bus and MTR ETA',
          Icons.description,
        ),
        const SizedBox(height: 8),
        
      ],
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return InkWell(
      onTap: () {
        Clipboard.setData(ClipboardData(text: value));
        // TODO: Replace with loc.appInfoCopied after running flutter gen-l10n
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Copied: $value'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
