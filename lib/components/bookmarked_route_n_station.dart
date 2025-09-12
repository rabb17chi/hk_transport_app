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
  int _lastTriggerValue = 0;

  @override
  void initState() {
    super.initState();
    _bookmarksFuture = BookmarksService.getBookmarks();
  }

  @override
  void didUpdateWidget(BookmarkedRouteWithStation oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Refresh when widget updates (triggered by ValueListenableBuilder)
    _refresh();
  }

  Future<void> _refresh() async {
    final data = await BookmarksService.getBookmarks();
    if (!mounted) return;
    setState(() {
      _bookmarksFuture = Future.value(data);
    });
  }

  // Expose refresh method to parent
  void refreshBookmarks() {
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: BookmarksService.refreshTrigger,
      builder: (context, value, child) {
        // Only refresh if trigger value actually changed
        if (value != _lastTriggerValue) {
          _lastTriggerValue = value;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _refresh();
            }
          });
        }
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
                          title: Text('${b.route} - ${b.stopNameTc}'),
                          content: SizedBox(
                            width: 200,
                            child: ListView(
                              shrinkWrap: true,
                              children: eta.take(5).map((e) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('第 ${e.etaSeq} 班'),
                                      Text(
                                        e.arrivalTimeString,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
