import 'package:flutter/material.dart';
import 'bookmarks_service.dart';

/// Service for handling bookmark toggle operations
class BookmarkToggleService {
  /// Toggle bookmark status for a given item
  static Future<void> toggleBookmark(
    BuildContext context,
    BookmarkItem item,
    VoidCallback onStateChanged,
  ) async {
    try {
      final already = await BookmarksService.isBookmarked(item);

      if (already) {
        await BookmarksService.removeBookmark(item);
      } else {
        await BookmarksService.addBookmark(item);
      }

      if (context.mounted) {
        onStateChanged();
      }
    } catch (e) {
      // Handle error silently or show snackbar
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error toggling bookmark: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }
}
