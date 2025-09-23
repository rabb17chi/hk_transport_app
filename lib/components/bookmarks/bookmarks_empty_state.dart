import 'package:flutter/material.dart';
import '../../l10n/locale_utils.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_scheme.dart';

class BookmarksEmptyState extends StatelessWidget {
  const BookmarksEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isChinese = LocaleUtils.isChinese(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.bookmark_border,
            size: 64,
            color: AppColorScheme.textMutedColor,
          ),
          const SizedBox(height: 16),
          Text(
            loc.emptyTitle,
            style: const TextStyle(
              fontSize: 18,
              color: AppColorScheme.textMutedColor,
            ),
          ),
          const SizedBox(height: 8),
          isChinese
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      loc.emptyInstructionAction,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      loc.emptyInstructionSuffix,
                      style: const TextStyle(
                        color: AppColorScheme.textMutedColor,
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Text(
                      loc.emptyInstructionAction,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      loc.emptyInstructionSuffix,
                      style: const TextStyle(
                        color: AppColorScheme.textMutedColor,
                      ),
                    ),
                  ],
                )
        ],
      ),
    );
  }
}
