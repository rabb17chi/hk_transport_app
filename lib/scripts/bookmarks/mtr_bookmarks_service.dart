import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MTRBookmarkItem {
  final String lineCode;
  final String stationId; // e.g. ADM, CEN
  final String stationNameTc;
  final String stationNameEn;

  const MTRBookmarkItem({
    required this.lineCode,
    required this.stationId,
    required this.stationNameTc,
    required this.stationNameEn,
  });

  Map<String, dynamic> toJson() => {
        'lineCode': lineCode,
        'stationId': stationId,
        'stationNameTc': stationNameTc,
        'stationNameEn': stationNameEn,
      };

  static MTRBookmarkItem fromJson(Map<String, dynamic> json) => MTRBookmarkItem(
        lineCode: json['lineCode'] as String,
        stationId: json['stationId'] as String,
        stationNameTc: json['stationNameTc'] as String? ?? '',
        stationNameEn: json['stationNameEn'] as String? ?? '',
      );
}

class MTRBookmarksService {
  static const String _bookmarksKey = 'mtr_bookmarks_v1';
  static String keyFor(MTRBookmarkItem item) =>
      '${item.lineCode}|${item.stationId}';

  static final ValueNotifier<int> _refreshTrigger = ValueNotifier<int>(0);
  static ValueNotifier<int> get refreshTrigger => _refreshTrigger;

  static Future<List<MTRBookmarkItem>> getBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_bookmarksKey);
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

  static Future<void> _save(List<MTRBookmarkItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final enc = json.encode(items.map((e) => e.toJson()).toList());
    await prefs.setString(_bookmarksKey, enc);
  }

  static Future<void> addBookmark(MTRBookmarkItem item) async {
    final existing = await getBookmarks();
    final already = existing.any((b) => keyFor(b) == keyFor(item));
    if (already) return;
    existing.add(item);
    await _save(existing);
    _refreshTrigger.value++;
  }

  static Future<void> removeBookmark(MTRBookmarkItem item) async {
    final existing = await getBookmarks();
    existing.removeWhere((b) => keyFor(b) == keyFor(item));
    await _save(existing);
    _refreshTrigger.value++;
  }

  static Future<bool> isBookmarked(MTRBookmarkItem item) async {
    final existing = await getBookmarks();
    return existing.any((b) => keyFor(b) == keyFor(item));
  }
}
