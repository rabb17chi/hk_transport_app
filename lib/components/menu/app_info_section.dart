import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../l10n/app_localizations.dart';

class AppInfoSection extends StatelessWidget {
  const AppInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
      final loc = AppLocalizations.of(context)!;
      return ExpansionTile(
        maintainState: true,
        leading: const Icon(Icons.info_outline),
        title: Text(loc.appInfoSectionTitle),
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
        _buildInfoRow(
          context,
          loc.appInfoVersion,
          '1.0.0',
          Icons.tag,
        ),
        const SizedBox(height: 8),
        _buildInfoRow(
          context,
          loc.appInfoDescription,
          loc.appInfoDescriptionText,
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
        final loc = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc.appInfoCopiedMessage(value)),
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
