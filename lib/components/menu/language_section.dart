import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../scripts/locale/locale_service.dart';

class LanguageSection extends StatelessWidget {
  final Key langKey;
  final bool langExpanded;
  final VoidCallback onTap;

  const LanguageSection({
    super.key,
    required this.langKey,
    required this.langExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: onTap,
      child: ExpansionTile(
        key: langKey,
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
        onExpansionChanged: null,
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
                  child: const Text('English'),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () async {
                    await LocaleService.setLocale(const Locale('zh', 'HK'));
                  },
                  child: const Text('繁體中文'),
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
      ),
    );
  }
}
