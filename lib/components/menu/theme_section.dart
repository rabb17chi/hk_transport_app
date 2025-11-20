import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../scripts/theme/theme_service.dart';

class ThemeSection extends StatelessWidget {
  final bool themeExpanded;
  final ValueChanged<bool> onExpansionChanged;
  final ExpansionTileController controller;

  const ThemeSection({
    super.key,
    required this.themeExpanded,
    required this.onExpansionChanged,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return ExpansionTile(
      controller: controller,
      maintainState: true,
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
      initiallyExpanded: themeExpanded,
      onExpansionChanged: onExpansionChanged,
      tilePadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      children: [
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () async {
                  await ThemeService.setTheme(ThemeMode.light);
                },
                child: Text(loc.themeLight),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () async {
                  await ThemeService.setTheme(ThemeMode.dark);
                },
                child: Text(loc.themeDark),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () async {
                  await ThemeService.setTheme(ThemeMode.system);
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
