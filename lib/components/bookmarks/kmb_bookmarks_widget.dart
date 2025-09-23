import 'package:flutter/material.dart';
import '../../scripts/bookmarks/bookmarks_service.dart';
import '../../scripts/kmb/kmb_api_service.dart';
import '../../l10n/locale_utils.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_scheme.dart';
import 'bookmarks_empty_state.dart';

/// KMB Bookmarks Widget
///
/// Displays a list of KMB bookmarked routes with ETA functionality
class KMBBookmarksWidget extends StatelessWidget {
  final List<BookmarkItem> kmbBookmarks;
  final bool isLoading;
  final Function(BookmarkItem) onRemoveBookmark;

  const KMBBookmarksWidget({
    super.key,
    required this.kmbBookmarks,
    required this.isLoading,
    required this.onRemoveBookmark,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    // no-op

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (kmbBookmarks.isEmpty) {
      return const BookmarksEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: kmbBookmarks.length,
      itemBuilder: (context, index) {
        final bookmark = kmbBookmarks[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Container(
              width: 100,
              height: 50,
              child: Center(
                child: Text(
                  bookmark.route,
                  style: const TextStyle(
                    color: AppColorScheme.kmbColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            title: Text(
              '${loc.toWord} ${LocaleUtils.isChinese(context) ? bookmark.destTc : bookmark.destEn}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              LocaleUtils.isChinese(context)
                  ? bookmark.stopNameTc
                  : bookmark.stopNameEn,
              style: const TextStyle(color: AppColorScheme.textMutedColor),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: AppColorScheme.dangerColor),
              onPressed: () => onRemoveBookmark(bookmark),
            ),
            onTap: () async {
              try {
                final eta = await KMBApiService.getETA(
                    bookmark.stopId, bookmark.route, bookmark.serviceType);
                if (!context.mounted) return;
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                          '${bookmark.route} ${loc.toWord} ${LocaleUtils.isChinese(context) ? bookmark.destTc : bookmark.destEn} - ${LocaleUtils.isChinese(context) ? bookmark.stopNameTc : bookmark.stopNameEn}'),
                      content: SizedBox(
                        width: 260,
                        child: eta.isEmpty
                            ? Text(loc.etaEmpty)
                            : ListView(
                                shrinkWrap: true,
                                children: eta.take(6).map((e) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 6),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            '${loc.etaSeqPrefix}${e.etaSeq}${loc.etaSeqSuffix}'),
                                        Text(
                                          e.arrivalTimeString,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(loc.close),
                        ),
                      ],
                    );
                  },
                );
              } catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${loc.etaLoadFailed}: $e')),
                );
              }
            },
          ),
        );
      },
    );
  }
}
