/// Notification Preferences Service
///
/// Manages which bookmarks should be tracked for notifications
/// 管理哪些書籤應該被追蹤以顯示通知

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../bookmarks/bookmarks_service.dart';
import '../bookmarks/mtr_bookmarks_service.dart';

class NotificationPreferencesService {
  static const String _trackedBookmarksKey = 'notification_tracked_bookmarks_v1';
  static const String _trackedMTRBookmarksKey =
      'notification_tracked_mtr_bookmarks_v1';

  /// Get list of tracked bus bookmarks
  /// 獲取被追蹤的巴士書籤列表
  static Future<List<BookmarkItem>> getTrackedBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_trackedBookmarksKey);
    if (raw == null) return [];
    try {
      final list = (json.decode(raw) as List<dynamic>)
          .map((e) => BookmarkItem.fromJson(e as Map<String, dynamic>))
          .toList();
      return list;
    } catch (_) {
      return [];
    }
  }

  /// Get list of tracked MTR bookmarks
  /// 獲取被追蹤的 MTR 書籤列表
  static Future<List<MTRBookmarkItem>> getTrackedMTRBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_trackedMTRBookmarksKey);
    if (raw == null) return [];
    try {
      final list = (json.decode(raw) as List<dynamic>)
          .map((e) => MTRBookmarkItem.fromJson(e as Map<String, dynamic>))
          .toList();
      return list;
    } catch (_) {
      return [];
    }
  }

  /// Check if a bus bookmark is being tracked
  /// 檢查巴士書籤是否正在被追蹤
  static Future<bool> isTracked(BookmarkItem bookmark) async {
    final tracked = await getTrackedBookmarks();
    return tracked.any((b) =>
        BookmarksService.keyFor(b) == BookmarksService.keyFor(bookmark));
  }

  /// Check if an MTR bookmark is being tracked
  /// 檢查 MTR 書籤是否正在被追蹤
  static Future<bool> isMTRTracked(MTRBookmarkItem bookmark) async {
    final tracked = await getTrackedMTRBookmarks();
    return tracked.any((b) =>
        MTRBookmarksService.keyFor(b) ==
        MTRBookmarksService.keyFor(bookmark));
  }

  /// Add a bus bookmark to tracking list
  /// 將巴士書籤添加到追蹤列表
  static Future<void> addTrackedBookmark(BookmarkItem bookmark) async {
    final tracked = await getTrackedBookmarks();
    final alreadyTracked = tracked.any((b) =>
        BookmarksService.keyFor(b) == BookmarksService.keyFor(bookmark));
    if (alreadyTracked) return;

    tracked.add(bookmark);
    await _saveTrackedBookmarks(tracked);
  }

  /// Add an MTR bookmark to tracking list
  /// 將 MTR 書籤添加到追蹤列表
  static Future<void> addTrackedMTRBookmark(MTRBookmarkItem bookmark) async {
    final tracked = await getTrackedMTRBookmarks();
    final alreadyTracked = tracked.any((b) =>
        MTRBookmarksService.keyFor(b) ==
        MTRBookmarksService.keyFor(bookmark));
    if (alreadyTracked) return;

    tracked.add(bookmark);
    await _saveTrackedMTRBookmarks(tracked);
  }

  /// Remove a bus bookmark from tracking list
  /// 從追蹤列表中移除巴士書籤
  static Future<void> removeTrackedBookmark(BookmarkItem bookmark) async {
    final tracked = await getTrackedBookmarks();
    tracked.removeWhere((b) =>
        BookmarksService.keyFor(b) == BookmarksService.keyFor(bookmark));
    await _saveTrackedBookmarks(tracked);
  }

  /// Remove an MTR bookmark from tracking list
  /// 從追蹤列表中移除 MTR 書籤
  static Future<void> removeTrackedMTRBookmark(
      MTRBookmarkItem bookmark) async {
    final tracked = await getTrackedMTRBookmarks();
    tracked.removeWhere((b) =>
        MTRBookmarksService.keyFor(b) ==
        MTRBookmarksService.keyFor(bookmark));
    await _saveTrackedMTRBookmarks(tracked);
  }

  /// Toggle tracking for a bus bookmark
  /// 切換巴士書籤的追蹤狀態
  static Future<bool> toggleTracking(BookmarkItem bookmark) async {
    final isTracked = await NotificationPreferencesService.isTracked(bookmark);
    if (isTracked) {
      await removeTrackedBookmark(bookmark);
      return false;
    } else {
      await addTrackedBookmark(bookmark);
      return true;
    }
  }

  /// Toggle tracking for an MTR bookmark
  /// 切換 MTR 書籤的追蹤狀態
  static Future<bool> toggleMTRTracking(MTRBookmarkItem bookmark) async {
    final isTracked =
        await NotificationPreferencesService.isMTRTracked(bookmark);
    if (isTracked) {
      await removeTrackedMTRBookmark(bookmark);
      return false;
    } else {
      await addTrackedMTRBookmark(bookmark);
      return true;
    }
  }

  /// Save tracked bus bookmarks
  /// 儲存被追蹤的巴士書籤
  static Future<void> _saveTrackedBookmarks(
      List<BookmarkItem> bookmarks) async {
    final prefs = await SharedPreferences.getInstance();
    final enc = json.encode(bookmarks.map((e) => e.toJson()).toList());
    await prefs.setString(_trackedBookmarksKey, enc);
  }

  /// Save tracked MTR bookmarks
  /// 儲存被追蹤的 MTR 書籤
  static Future<void> _saveTrackedMTRBookmarks(
      List<MTRBookmarkItem> bookmarks) async {
    final prefs = await SharedPreferences.getInstance();
    final enc = json.encode(bookmarks.map((e) => e.toJson()).toList());
    await prefs.setString(_trackedMTRBookmarksKey, enc);
  }

  /// Clear all tracked bookmarks
  /// 清除所有被追蹤的書籤
  static Future<void> clearAllTracked() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_trackedBookmarksKey);
    await prefs.remove(_trackedMTRBookmarksKey);
  }
}

