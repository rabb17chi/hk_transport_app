import 'package:flutter/material.dart';
import '../../scripts/bookmarks/bookmarks_service.dart';
import '../../scripts/bookmarks/mtr_bookmarks_service.dart';
import '../../l10n/app_localizations.dart';
import 'kmb_bookmarks_widget.dart';
import 'mtr_bookmarks_widget.dart';

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
    return KMBBookmarksWidget(
      kmbBookmarks: _kmbBookmarks,
      isLoading: _isLoading,
      onRemoveBookmark: _removeKMBBookmark,
    );
  }

  Widget _buildMTRBookmarks() {
    return MTRBookmarksWidget(
      mtrBookmarks: _mtrBookmarks,
      isLoading: _isLoading,
      onRemoveBookmark: _removeMTRBookmark,
    );
  }

  Future<void> _removeKMBBookmark(BookmarkItem bookmark) async {
    final loc = AppLocalizations.of(context)!;
    try {
      await BookmarksService.removeBookmark(bookmark);
      await _loadBookmarks();
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
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${loc.removeBookmarkError}: $e')),
        );
      }
    }
  }
}
