import 'package:flutter/material.dart';
import '../../scripts/bookmarks/bookmarks_service.dart';
import '../../scripts/kmb/kmb_api_service.dart';
import '../../scripts/ctb/ctb_route_stops_service.dart';
import '../ui/eta_dialog.dart';
import '../../l10n/locale_utils.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_scheme.dart';
import '../../scripts/utils/text_utils.dart';
import '../../scripts/utils/settings_service.dart';
import '../../scripts/utils/responsive_utils.dart';
import 'bookmarks_empty_state.dart';

/// KMB Bookmarks Widget
///
/// Displays a list of KMB bookmarked routes with ETA functionality
class KMBBookmarksWidget extends StatefulWidget {
  final List<BookmarkItem> kmbBookmarks;
  final bool isLoading;

  const KMBBookmarksWidget({
    super.key,
    required this.kmbBookmarks,
    required this.isLoading,
  });

  @override
  State<KMBBookmarksWidget> createState() => _KMBBookmarksWidgetState();
}

class _KMBBookmarksWidgetState extends State<KMBBookmarksWidget> {
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    if (widget.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.kmbBookmarks.isEmpty) {
      return const BookmarksEmptyState();
    }

    // Group bookmarks by route + bound + serviceType
    final Map<String, List<BookmarkItem>> groupedBookmarks = {};
    for (final bookmark in widget.kmbBookmarks) {
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

        return FutureBuilder<Map<String, int>>(
          future: _getStopSequences(firstBookmark, isCTB),
          builder: (context, snapshot) {
            // Sort bookmarks by sequence if we have the data
            List<BookmarkItem> sortedBookmarks = groupBookmarks;
            if (snapshot.hasData) {
              final seqMap = snapshot.data!;
              sortedBookmarks = List<BookmarkItem>.from(groupBookmarks)
                ..sort((a, b) {
                  final seqA = seqMap[a.stopId] ?? 9999;
                  final seqB = seqMap[b.stopId] ?? 9999;
                  return seqA.compareTo(seqB);
                });
            }

            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Container(
                          width: 120,
                          height: 56,
                          decoration: isCTB
                              ? BoxDecoration(
                                  color: AppColorScheme.ctbBannerBackgroundColor
                                      .withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(8),
                                )
                              : null,
                          child: Center(
                            child: Text(
                              firstBookmark.route,
                              style: TextStyle(
                                color: isCTB
                                    ? AppColorScheme.ctbBannerTextColor
                                    : AppColorScheme.kmbColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${loc.toWord} ${isZh ? firstBookmark.destTc : firstBookmark.destEn}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: sortedBookmarks.map((bookmark) {
                        return _buildStationItem(
                            context, bookmark, isZh, isCTB, loc);
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// Fetch route stops and create a map of stopId -> sequence number
  Future<Map<String, int>> _getStopSequences(
      BookmarkItem bookmark, bool isCTB) async {
    try {
      final Map<String, int> seqMap = {};

      if (isCTB) {
        final dir = bookmark.bound == 'I' ? 'inbound' : 'outbound';
        final routeStops = await CTBRouteStopsService.getRouteStops(
          route: bookmark.route,
          bound: dir,
        );
        for (final stop in routeStops) {
          seqMap[stop.stop] = stop.seq;
        }
      } else {
        final routeStops = await KMBApiService.getRouteStops(
          bookmark.route,
          bookmark.bound,
          bookmark.serviceType,
        );
        for (final stop in routeStops) {
          seqMap[stop.stop] = stop.seq;
        }
      }

      return seqMap;
    } catch (e) {
      // Return empty map on error - bookmarks will maintain original order
      return {};
    }
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

  Widget _buildStationItem(BuildContext context, BookmarkItem bookmark,
      bool isZh, bool isCTB, AppLocalizations loc) {
    // Get station name based on language
    String stationName = isCTB
        ? (isZh ? bookmark.stopNameTc : bookmark.stopNameEn).trim()
        : TextUtils.cleanupStopDisplayName(
            isZh ? bookmark.stopNameTc : bookmark.stopNameEn);

    return ValueListenableBuilder<bool>(
      valueListenable: SettingsService.displayBusFullNameNotifier,
      builder: (context, showFullName, _) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[850]
                : Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[700]!
                  : Colors.grey[300]!,
              width: 1,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _showETA(context, bookmark, loc),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Station name
                    Text(
                      stationName,
                      style: TextStyle(
                        fontSize: ResponsiveUtils.getOverflowSafeFontSize(
                            context, 20.0),
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
