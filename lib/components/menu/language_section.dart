import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../scripts/locale/locale_service.dart';

class LanguageSection extends StatelessWidget {
  final bool langExpanded;
  final ValueChanged<bool> onExpansionChanged;
  final ExpansionTileController controller;

  const LanguageSection({
    super.key,
    required this.langExpanded,
    required this.onExpansionChanged,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return ExpansionTile(
      controller: controller,
      maintainState: true,
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
      initiallyExpanded: langExpanded,
      onExpansionChanged: onExpansionChanged,
      tilePadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
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
                child: Text(loc.languageEnglishLabel),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () async {
                  await LocaleService.setLocale(const Locale('zh'));
                },
                child: Text(loc.languageChineseLabel),
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
}
