import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkItem {
  final String route;
  final String bound;
  final String stopId;
  final String stopNameTc;
  final String stopNameEn;
  final String serviceType;
  final String destTc;
  final String destEn;

  const BookmarkItem({
    required this.route,
    required this.bound,
    required this.stopId,
    required this.stopNameTc,
    required this.stopNameEn,
    required this.serviceType,
    required this.destTc,
    required this.destEn,
  });

  Map<String, dynamic> toJson() => {
        'route': route,
        'bound': bound,
        'stopId': stopId,
        'stopNameTc': stopNameTc,
        'stopNameEn': stopNameEn,
        'serviceType': serviceType,
        'destTc': destTc,
        'destEn': destEn,
      };

  static BookmarkItem fromJson(Map<String, dynamic> json) => BookmarkItem(
        route: json['route'] as String,
        bound: json['bound'] as String,
        stopId: json['stopId'] as String,
        stopNameTc: json['stopNameTc'] as String? ?? '',
        stopNameEn: json['stopNameEn'] as String? ?? '',
        serviceType: json['serviceType'] as String? ?? '1',
        destTc: json['destTc'] as String? ?? '',
        destEn: json['destEn'] as String? ?? '',
      );
}

class BookmarksService {
  static const String _bookmarksKey = 'kmb_bookmarks_v1';
  static String keyFor(BookmarkItem item) =>
      '${item.route}|${item.bound}|${item.stopId}|${item.serviceType}';

  // Global refresh trigger for all bookmark widgets
  static final ValueNotifier<int> _refreshTrigger = ValueNotifier<int>(0);
  static ValueNotifier<int> get refreshTrigger => _refreshTrigger;

  static Future<List<BookmarkItem>> getBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_bookmarksKey);
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

  static Future<void> _save(List<BookmarkItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final enc = json.encode(items.map((e) => e.toJson()).toList());
    await prefs.setString(_bookmarksKey, enc);
  }

  static Future<void> addBookmark(BookmarkItem item) async {
    final existing = await getBookmarks();
    final already = existing.any((b) => keyFor(b) == keyFor(item));
    if (already) return;
    existing.add(item);
    await _save(existing);
    _refreshTrigger.value++;
  }

  static Future<void> removeBookmark(BookmarkItem item) async {
    final existing = await getBookmarks();
    existing.removeWhere((b) => keyFor(b) == keyFor(item));
    await _save(existing);
    _refreshTrigger.value++;
  }

  static Future<bool> isBookmarked(BookmarkItem item) async {
    final existing = await getBookmarks();
    return existing.any((b) => keyFor(b) == keyFor(item));
  }
}
