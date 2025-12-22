import 'package:flutter/material.dart';
import '../../scripts/bookmarks/mtr_bookmarks_service.dart';
import '../../scripts/mtr/mtr_schedule_service.dart';
import '../../scripts/mtr/mtr_data.dart';
import '../../theme/app_color_scheme.dart';
import '../../l10n/locale_utils.dart';
import '../../l10n/app_localizations.dart';
import '../mtr/mtr_schedule_dialog.dart';
import 'bookmarks_empty_state.dart';

/// MTR Bookmarks Widget
///
/// Displays a list of MTR bookmarked stations with schedule functionality
class MTRBookmarksWidget extends StatefulWidget {
  final List<MTRBookmarkItem> mtrBookmarks;
  final bool isLoading;
  final bool isEditMode;
  final Future<void> Function(MTRBookmarkItem) onDelete;

  const MTRBookmarksWidget({
    super.key,
    required this.mtrBookmarks,
    required this.isLoading,
    this.isEditMode = false,
    required this.onDelete,
  });

  @override
  State<MTRBookmarksWidget> createState() => _MTRBookmarksWidgetState();
}

class _MTRBookmarksWidgetState extends State<MTRBookmarksWidget> {

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    // no-op

    if (widget.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.mtrBookmarks.isEmpty) {
      return const BookmarksEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.mtrBookmarks.length,
      itemBuilder: (context, index) {
        final bookmark = widget.mtrBookmarks[index];
        final stationLines = MTRData.getStationLines(bookmark.stationId);
        final isZh = LocaleUtils.isChinese(context);
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Row(
              children: [
                // Station name
                Expanded(
                  child: Text(
                    isZh ? bookmark.stationNameTc : bookmark.stationNameEn,
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
                // Trash icon in edit mode
                if (widget.isEditMode) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    color: AppColorScheme.dangerColor,
                    onPressed: () => widget.onDelete(bookmark),
                    tooltip: loc.removeBookmarkSuccess,
                  ),
                ],
              ],
            ),
            onTap: widget.isEditMode ? null : () async {
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
