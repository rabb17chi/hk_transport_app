import 'package:flutter/material.dart';
import '../scripts/kmb_api_service.dart';
import '../scripts/bookmarks_service.dart';

/// BookmarkedRouteWithStation Widget
///
/// A widget for displaying bookmarked routes with their stations
class BookmarkedRouteWithStation extends StatefulWidget {
  const BookmarkedRouteWithStation({super.key});

  @override
  State<BookmarkedRouteWithStation> createState() =>
      _BookmarkedRouteWithStationState();
}

class _BookmarkedRouteWithStationState
    extends State<BookmarkedRouteWithStation> {
  Future<List<BookmarkItem>>? _bookmarksFuture;

  @override
  void initState() {
    super.initState();
    _bookmarksFuture = BookmarksService.getBookmarks();
  }

  Future<void> _refresh() async {
    final data = await BookmarksService.getBookmarks();
    if (!mounted) return;
    setState(() {
      _bookmarksFuture = Future.value(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BookmarkItem>>(
      future: _bookmarksFuture,
      builder: (context, snapshot) {
        final items = snapshot.data ?? [];
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (items.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Center(child: Text('你可以長按巴士站增加至收藏')),
          );
        }
        final limited = items.length > 50 ? items.sublist(0, 50) : items;
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: limited.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final b = limited[index];
            return ListTile(
              title: Text('${b.route} - ${b.stopNameTc}'),
              subtitle: Text(b.stopNameEn),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final eta = await KMBApiService.getETA(
                    b.stopId, b.route, b.serviceType);
                if (!mounted) return;
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('ETA  ${b.route} - ${b.stopNameTc}'),
                      content: SizedBox(
                        width: double.maxFinite,
                        child: ListView(
                          shrinkWrap: true,
                          children: eta.take(5).map((e) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('第 ${e.etaSeq} 班'),
                                  Text(e.arrivalTimeString),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Close'),
                        )
                      ],
                    );
                  },
                );
              },
              onLongPress: () async {
                await BookmarksService.removeBookmark(b);
                await _refresh();
              },
            );
          },
        );
      },
    );
  }
}
