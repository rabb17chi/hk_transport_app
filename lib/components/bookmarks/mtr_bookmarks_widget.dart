import 'package:flutter/material.dart';
import '../../scripts/bookmarks/mtr_bookmarks_service.dart';
import '../../scripts/mtr/mtr_schedule_service.dart';
import '../../scripts/mtr/mtr_data.dart';
import '../../l10n/locale_utils.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_scheme.dart';
import '../mtr/mtr_schedule_dialog.dart';

/// MTR Bookmarks Widget
///
/// Displays a list of MTR bookmarked stations with schedule functionality
class MTRBookmarksWidget extends StatelessWidget {
  final List<MTRBookmarkItem> mtrBookmarks;
  final bool isLoading;
  final Function(MTRBookmarkItem) onRemoveBookmark;

  const MTRBookmarksWidget({
    super.key,
    required this.mtrBookmarks,
    required this.isLoading,
    required this.onRemoveBookmark,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (mtrBookmarks.isEmpty) {
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
              loc.mtrEmptyTitle,
              style: const TextStyle(
                fontSize: 18,
                color: AppColorScheme.textMutedColor,
              ),
            ),
            Text(loc.longPress,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 20)),
            Text(
              loc.mtrEmptySubtitle,
              style: const TextStyle(
                color: AppColorScheme.textMutedColor,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: mtrBookmarks.length,
      itemBuilder: (context, index) {
        final bookmark = mtrBookmarks[index];
        final stationLines = MTRData.getStationLines(bookmark.stationId);
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Row(
              children: [
                // Station name
                Expanded(
                  child: Text(
                    LocaleUtils.isChinese(context)
                        ? bookmark.stationNameTc
                        : bookmark.stationNameEn,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                // Lines badges
                if (stationLines.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  Wrap(
                    spacing: 4,
                    runSpacing: 2,
                    children: stationLines.map((lineCode) {
                      final lineColor = MTRData.getLineColor(lineCode);
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: lineColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: lineColor, width: 1),
                        ),
                        child: Text(
                          lineCode,
                          style: TextStyle(
                            color: lineColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: AppColorScheme.dangerColor),
              onPressed: () => onRemoveBookmark(bookmark),
            ),
            onTap: () async {
              try {
                final resp = await MTRScheduleService.getSchedule(
                  lineCode: bookmark.lineCode,
                  stationId: bookmark.stationId,
                );
                if (!context.mounted) return;
                if (resp == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(loc.timetableUnavailable)),
                  );
                  return;
                }
                showDialog(
                  context: context,
                  builder: (context) => MTRScheduleDialog(
                    initialResponse: resp,
                    stationName: bookmark.stationNameTc,
                    lineCode: bookmark.lineCode,
                    stationId: bookmark.stationId,
                  ),
                );
              } catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${loc.errorLoadBookmarks}: $e')),
                );
              }
            },
          ),
        );
      },
    );
  }
}
