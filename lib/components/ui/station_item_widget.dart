import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../scripts/bookmarks/bookmarks_service.dart';
import '../../scripts/utils/responsive_utils.dart';
import '../../scripts/utils/text_utils.dart';
import '../../theme/app_color_scheme.dart';

/// Reusable Station Item Widget
///
/// Displays a station with number, name, and bookmark functionality
/// Used by both KMB and CTB route stations screens
class StationItemWidget extends StatelessWidget {
  final int index;
  final bool isSelected;
  final String nameTc;
  final String nameEn;
  final bool isChinese;
  final bool showSubtitle;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final Future<bool> Function() isBookmarkedFuture;
  final Widget? additionalContent;

  const StationItemWidget({
    super.key,
    required this.index,
    required this.isSelected,
    required this.nameTc,
    required this.nameEn,
    required this.isChinese,
    required this.showSubtitle,
    required this.onTap,
    required this.onLongPress,
    required this.isBookmarkedFuture,
    this.additionalContent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          onLongPress: onLongPress,
          child: FutureBuilder<bool>(
            future: isBookmarkedFuture(),
            builder: (context, snap) {
              final bookmarked = snap.data == true;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: bookmarked
                      ? AppColorScheme.bookmarkedColor.withOpacity(
                          Theme.of(context).brightness == Brightness.dark
                              ? 0.85
                              : 0.35)
                      : Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[900]
                          : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? AppColorScheme.selectedBorderColor
                        : Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                    width: isSelected ? 3 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    // Station Number Badge
                    _buildStationNumberBadge(context),
                    const SizedBox(width: 16),
                    // Station Info
                    Expanded(
                      child: _buildStationInfo(context),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        // Additional content (like ETA display)
        if (additionalContent != null) additionalContent!,
      ],
    );
  }

  Widget _buildStationNumberBadge(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFF7A925),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          '${index + 1}',
          style: TextStyle(
            fontSize: ResponsiveUtils.getOverflowSafeFontSize(context, 16.0),
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildStationInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main station name
        Text(
          _cleanStopName(isChinese ? nameTc : nameEn),
          style: TextStyle(
            fontSize: ResponsiveUtils.getOverflowSafeFontSize(context, 18.0),
            fontWeight: FontWeight.bold,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
        // Subtitle (other language)
        if (showSubtitle)
          Text(
            _cleanStopName(isChinese ? nameEn : nameTc),
            style: TextStyle(
              fontSize: ResponsiveUtils.getOverflowSafeFontSize(context, 14.0),
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : AppColorScheme.textMediumColor,
            ),
          ),
      ],
    );
  }

  String _cleanStopName(String name) => TextUtils.cleanupStopDisplayName(name);
}
