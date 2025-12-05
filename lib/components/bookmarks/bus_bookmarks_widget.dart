import 'package:flutter/material.dart';
import '../../scripts/bookmarks/bookmarks_service.dart';
import '../../scripts/kmb/kmb_api_service.dart';
import '../../scripts/ctb/ctb_route_stops_service.dart';
import '../ui/eta_dialog.dart';
import '../../l10n/locale_utils.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_scheme.dart';
import '../../scripts/utils/text_utils.dart';
import 'bookmarks_empty_state.dart';

/// KMB Bookmarks Widget
///
/// Displays a list of KMB bookmarked routes with ETA functionality
class KMBBookmarksWidget extends StatelessWidget {
  final List<BookmarkItem> kmbBookmarks;
  final bool isLoading;

  const KMBBookmarksWidget({
    super.key,
    required this.kmbBookmarks,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    String cleanStopName(String name) => TextUtils.cleanupStopDisplayName(name);
    // no-op

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (kmbBookmarks.isEmpty) {
      return const BookmarksEmptyState();
    }

    // Group bookmarks by route + bound + serviceType
    final Map<String, List<BookmarkItem>> groupedBookmarks = {};
    for (final bookmark in kmbBookmarks) {
      final key =
          '${bookmark.operator}|${bookmark.route}|${bookmark.bound}|${bookmark.serviceType}';
      groupedBookmarks.putIfAbsent(key, () => []).add(bookmark);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: groupedBookmarks.length,
      itemBuilder: (context, index) {
        final groupKey = groupedBookmarks.keys.elementAt(index);
        final groupBookmarks = groupedBookmarks[groupKey]!;
        final firstBookmark = groupBookmarks.first;
        final isZh = LocaleUtils.isChinese(context);
        final isCTB = firstBookmark.operator.toUpperCase() == 'CTB';

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 50,
                      child: Center(
                        child: Text(
                          firstBookmark.route,
                          style: TextStyle(
                            color: isCTB
                                ? AppColorScheme.ctbBannerBackgroundColor
                                : AppColorScheme.kmbColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '${loc.toWord} ${isZh ? firstBookmark.destTc : firstBookmark.destEn}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: groupBookmarks.map((bookmark) {
                    final stopName = isCTB
                        ? (isZh ? bookmark.stopNameTc : bookmark.stopNameEn)
                            .trim()
                        : cleanStopName(
                            isZh ? bookmark.stopNameTc : bookmark.stopNameEn);
                    return TextButton(
                      onPressed: () => _showETA(context, bookmark, loc),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.centerLeft,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(stopName),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showETA(
      BuildContext context, BookmarkItem bookmark, AppLocalizations loc) async {
    try {
      final isCTB = bookmark.operator.toUpperCase() == 'CTB';
      if (isCTB) {
        final eta = await CTBRouteStopsService.getETA(
          stopId: bookmark.stopId,
          route: bookmark.route,
        );
        if (!context.mounted) return;
        final isZh = LocaleUtils.isChinese(context);
        final filtered = eta
            .where((e) => e.dir.toUpperCase() == bookmark.bound.toUpperCase())
            .toList()
          ..sort((a, b) => a.etaSeq.compareTo(b.etaSeq));
        await EtaDialog.showWithPairs(
          context,
          title:
              '${bookmark.route} ${loc.toWord} ${isZh ? bookmark.destTc : bookmark.destEn} - ${isZh ? (bookmark.stopNameTc.isEmpty ? bookmark.stopId : bookmark.stopNameTc) : (bookmark.stopNameEn.isEmpty ? bookmark.stopId : bookmark.stopNameEn)}',
          emptyText: loc.etaEmpty,
          rows: filtered.take(6).map((e) {
            final label = isZh ? e.arrivalTimeStringZh : e.arrivalTimeStringEn;
            int seq = e.etaSeq;
            if (seq > 3) seq -= 3;
            return MapEntry(
                '${loc.etaSeqPrefix}$seq${loc.etaSeqSuffix}', label);
          }).toList(),
        );
      } else {
        final eta = await KMBApiService.getETA(
            bookmark.stopId, bookmark.route, bookmark.serviceType);
        if (!context.mounted) return;
        await EtaDialog.showWithPairs(
          context,
          title:
              '${bookmark.route} ${loc.toWord} ${LocaleUtils.isChinese(context) ? bookmark.destTc : bookmark.destEn} - ${LocaleUtils.isChinese(context) ? bookmark.stopNameTc : bookmark.stopNameEn}',
          emptyText: loc.etaEmpty,
          rows: eta
              .take(6)
              .map((e) => MapEntry(
                  '${loc.etaSeqPrefix}${e.etaSeq}${loc.etaSeqSuffix}',
                  e.getArrivalTimeString(context)))
              .toList(),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${loc.etaLoadFailed}: $e')),
      );
    }
  }
}
