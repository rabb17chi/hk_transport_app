import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkItem {
  final String route;
  final String bound;
  final String stopId;
  final String stopNameTc;
  final String stopNameEn;
  final String serviceType;

  const BookmarkItem({
    required this.route,
    required this.bound,
    required this.stopId,
    required this.stopNameTc,
    required this.stopNameEn,
    required this.serviceType,
  });

  Map<String, dynamic> toJson() => {
        'route': route,
        'bound': bound,
        'stopId': stopId,
        'stopNameTc': stopNameTc,
        'stopNameEn': stopNameEn,
        'serviceType': serviceType,
      };

  static BookmarkItem fromJson(Map<String, dynamic> json) => BookmarkItem(
        route: json['route'] as String,
        bound: json['bound'] as String,
        stopId: json['stopId'] as String,
        stopNameTc: json['stopNameTc'] as String? ?? '',
        stopNameEn: json['stopNameEn'] as String? ?? '',
        serviceType: json['serviceType'] as String? ?? '1',
      );
}

class BookmarksService {
  static const String _bookmarksKey = 'kmb_bookmarks_v1';

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
    final already = existing.any((b) =>
        b.route == item.route &&
        b.bound == item.bound &&
        b.stopId == item.stopId &&
        b.serviceType == item.serviceType);
    if (already) return;
    existing.add(item);
    await _save(existing);
  }

  static Future<void> removeBookmark(BookmarkItem item) async {
    final existing = await getBookmarks();
    existing.removeWhere((b) =>
        b.route == item.route &&
        b.bound == item.bound &&
        b.stopId == item.stopId &&
        b.serviceType == item.serviceType);
    await _save(existing);
  }
}
