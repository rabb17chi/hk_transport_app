import 'package:flutter/material.dart';
import '../../scripts/kmb/kmb_api_service.dart';
import '../../theme/app_color_scheme.dart';
import '../ui/eta_dialog.dart';
import '../../scripts/bookmarks/bookmarks_service.dart';
import '../../l10n/app_localizations.dart';

/// BookmarkedRouteWithStation Widget
///
/// A widget for displaying bookmarked routes with their stations
class BookmarkedRouteWithStation extends StatefulWidget {
  final VoidCallback? onSettingsTap;
  const BookmarkedRouteWithStation({super.key, this.onSettingsTap});

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
    return SafeArea(
      child: Column(
        children: [
          // Custom header bar
          Container(
            color: AppColorScheme.kmbBannerTextColor,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'My Bus Bookmarks',
                    style: TextStyle(
                      color: AppColorScheme.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  color: Colors.black,
                  tooltip: 'Refresh',
                  onPressed: _refresh,
                ),
                IconButton(
                  icon: const Icon(Icons.settings),
                  color: Colors.black,
                  tooltip: 'Settings',
                  onPressed: widget.onSettingsTap,
                ),
              ],
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<int>(
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
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Center(
                            child: Text(AppLocalizations.of(context)!
                                .longPressToBookmark)),
                      );
                    }
                    final limited =
                        items.length > 50 ? items.sublist(0, 50) : items;
                    return ListView.separated(
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
                            await EtaDialog.showWithPairs(
                              context,
                              title: '${b.route} - ${b.stopNameTc}',
                              emptyText: '',
                              rows: eta
                                  .take(5)
                                  .map((e) => MapEntry('第 ${e.etaSeq} 班',
                                      e.getArrivalTimeString(context)))
                                  .toList(),
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
