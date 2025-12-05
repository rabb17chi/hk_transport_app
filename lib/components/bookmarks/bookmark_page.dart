import 'package:flutter/material.dart';
import '../../scripts/bookmarks/bookmarks_service.dart';
import '../../scripts/bookmarks/mtr_bookmarks_service.dart';
import '../../l10n/app_localizations.dart';
import 'bus_bookmarks_widget.dart';
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
            // Edit button at the bottom
            Container(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                onPressed: () => _showEditDialog(),
                icon: const Icon(Icons.edit),
                label: const Text('Edit Items'), // loc.editItems
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog() {
    // TODO: Implement edit dialog for reordering and deleting bookmarks
    final loc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        // TODO: Replace with loc.editItems after running flutter gen-l10n
        title: const Text('Edit Items'), // loc.editItems
        content: const Text('Edit mode coming soon'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(loc.close),
          ),
        ],
      ),
    );
  }

  Widget _buildKMBBookmarks() {
    return KMBBookmarksWidget(
      kmbBookmarks: _kmbBookmarks,
      isLoading: _isLoading,
    );
  }

  Widget _buildMTRBookmarks() {
    return MTRBookmarksWidget(
      mtrBookmarks: _mtrBookmarks,
      isLoading: _isLoading,
    );
  }
}
