import 'package:flutter/material.dart';
import '../../scripts/bookmarks_service.dart';
import '../../scripts/kmb_api_service.dart';
import '../../scripts/mtr/mtr_bookmarks_service.dart';
import '../../scripts/mtr/mtr_schedule_service.dart';
import '../mtr/mtr_schedule_dialog.dart';
import '../../l10n/app_localizations.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<BookmarkItem> _kmbBookmarks = [];
  List<MTRBookmarkItem> _mtrBookmarks = [];
  bool _isLoading = true;
  int _kmbTrigger = 0;
  int _mtrTrigger = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadBookmarks();
    // Listen to both bookmark services for instant updates
    BookmarksService.refreshTrigger.addListener(_onKMBTrigger);
    MTRBookmarksService.refreshTrigger.addListener(_onMTRTrigger);
  }

  @override
  void dispose() {
    _tabController.dispose();
    BookmarksService.refreshTrigger.removeListener(_onKMBTrigger);
    MTRBookmarksService.refreshTrigger.removeListener(_onMTRTrigger);
    super.dispose();
  }

  void _onKMBTrigger() {
    if (mounted) {
      final v = BookmarksService.refreshTrigger.value;
      if (v != _kmbTrigger) {
        _kmbTrigger = v;
        _loadBookmarks();
      }
    }
  }

  void _onMTRTrigger() {
    if (mounted) {
      final v = MTRBookmarksService.refreshTrigger.value;
      if (v != _mtrTrigger) {
        _mtrTrigger = v;
        _loadBookmarks();
      }
    }
  }

  Future<void> _loadBookmarks() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load KMB and MTR bookmarks
      final kmbBookmarks = await BookmarksService.getBookmarks();
      final mtrBookmarks = await MTRBookmarksService.getBookmarks();

      setState(() {
        _kmbBookmarks = kmbBookmarks;
        _mtrBookmarks = mtrBookmarks;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        final loc = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${loc.errorLoadBookmarks}: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              tabs: [
                Tab(
                  icon: const Icon(Icons.directions_bus),
                  text: loc.tabBus,
                ),
                Tab(
                  icon: const Icon(Icons.train),
                  text: loc.tabMTR,
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildKMBBookmarks(),
                  _buildMTRBookmarks(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKMBBookmarks() {
    final loc = AppLocalizations.of(context)!;
    final isChinese = Localizations.localeOf(context).languageCode == 'zh';
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_kmbBookmarks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.bookmark_border,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              loc.kmbEmptyTitle,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            isChinese
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(loc.kmbEmptyInstructionPrefix,
                          style: const TextStyle(color: Colors.grey)),
                      const SizedBox(width: 4),
                      Text(loc.kmbEmptyInstructionAction,
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20)),
                      const SizedBox(width: 4),
                      Text(loc.kmbEmptyInstructionSuffix,
                          style: const TextStyle(color: Colors.grey)),
                    ],
                  )
                : Column(
                    children: [
                      Text(loc.kmbEmptyInstructionPrefix,
                          style: const TextStyle(color: Colors.grey)),
                      Text(loc.kmbEmptyInstructionAction,
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                      Text(loc.kmbEmptyInstructionSuffix,
                          style: const TextStyle(color: Colors.grey)),
                    ],
                  )
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _kmbBookmarks.length,
      itemBuilder: (context, index) {
        final bookmark = _kmbBookmarks[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: const Icon(Icons.directions_bus, color: Colors.orange),
            title: Text(
              '${bookmark.route} ${loc.toWord} ${bookmark.bound}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(bookmark.stopNameTc),
                if (bookmark.stopNameEn.isNotEmpty)
                  Text(
                    bookmark.stopNameEn,
                    style: const TextStyle(color: Colors.grey),
                  ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _removeKMBBookmark(bookmark),
            ),
            onTap: () async {
              try {
                final eta = await KMBApiService.getETA(
                    bookmark.stopId, bookmark.route, bookmark.serviceType);
                if (!mounted) return;
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('${bookmark.route} - ${bookmark.stopNameTc}'),
                      content: SizedBox(
                        width: 260,
                        child: eta.isEmpty
                            ? Text(loc.etaEmpty)
                            : ListView(
                                shrinkWrap: true,
                                children: eta.take(6).map((e) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 6),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            '${loc.etaSeqPrefix}${e.etaSeq}${loc.etaSeqSuffix}'),
                                        Text(
                                          e.arrivalTimeString,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(loc.close),
                        ),
                      ],
                    );
                  },
                );
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${loc.etaLoadFailed}: $e')),
                );
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildMTRBookmarks() {
    final loc = AppLocalizations.of(context)!;
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_mtrBookmarks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.bookmark_border,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              loc.mtrEmptyTitle,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              loc.mtrEmptySubtitle,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _mtrBookmarks.length,
      itemBuilder: (context, index) {
        final bookmark = _mtrBookmarks[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: const Icon(Icons.train, color: Colors.blue),
            title: Text(
              bookmark.stationNameTc,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(bookmark.stationNameEn),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _removeMTRBookmark(bookmark),
            ),
            onTap: () async {
              try {
                final resp = await MTRScheduleService.getSchedule(
                  lineCode: bookmark.lineCode,
                  stationId: bookmark.stationId,
                );
                if (!mounted) return;
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
                if (!mounted) return;
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

  Future<void> _removeKMBBookmark(BookmarkItem bookmark) async {
    final loc = AppLocalizations.of(context)!;
    try {
      await BookmarksService.removeBookmark(bookmark);
      await _loadBookmarks();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loc.removeBookmarkSuccess)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${loc.removeBookmarkError}: $e')),
        );
      }
    }
  }

  Future<void> _removeMTRBookmark(MTRBookmarkItem bookmark) async {
    final loc = AppLocalizations.of(context)!;
    try {
      await MTRBookmarksService.removeBookmark(bookmark);
      await _loadBookmarks();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loc.removeBookmarkSuccess)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${loc.removeBookmarkError}: $e')),
        );
      }
    }
  }
}
