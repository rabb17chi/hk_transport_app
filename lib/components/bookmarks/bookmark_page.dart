import 'package:flutter/material.dart';
import '../../scripts/bookmarks/bookmarks_service.dart';
import '../../scripts/bookmarks/mtr_bookmarks_service.dart';
import '../../theme/app_color_scheme.dart';
import '../../l10n/locale_utils.dart';
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
  bool _isEditMode = false;

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

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
    });
  }

  Future<void> _deleteKMBBookmark(BookmarkItem bookmark) async {
    final loc = AppLocalizations.of(context)!;
    final isZh = LocaleUtils.isChinese(context);
    final stationName = isZh ? bookmark.stopNameTc : bookmark.stopNameEn;
    final bookmarkInfo = '${bookmark.route} - $stationName';
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(loc.removeBookmarkSuccess),
            content: Text(
              loc.deleteBookmarkConfirm(bookmarkInfo),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(loc.cancel),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(
                  foregroundColor: AppColorScheme.dangerColor,
                ),
                child: Text(loc.confirm),
              ),
            ],
          ),
        ) ??
        false;

    if (confirmed == true) {
      try {
        await BookmarksService.removeBookmark(bookmark);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(loc.removeBookmarkSuccess),
              duration: const Duration(seconds: 2),
            ),
          );
        }
        // Reload bookmarks to refresh the list
        await _loadBookmarks();
        // Check if we should exit edit mode
        if (_kmbBookmarks.isEmpty) {
          setState(() {
            _isEditMode = false;
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${loc.removeBookmarkError}: $e'),
              backgroundColor: AppColorScheme.snackbarErrorColor,
            ),
          );
        }
      }
    }
  }

  Future<void> _deleteMTRBookmark(MTRBookmarkItem bookmark) async {
    final loc = AppLocalizations.of(context)!;
    final isZh = LocaleUtils.isChinese(context);
    final stationName = isZh ? bookmark.stationNameTc : bookmark.stationNameEn;
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(loc.removeBookmarkSuccess),
            content: Text(
              loc.deleteBookmarkConfirm(stationName),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(loc.cancel),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(
                  foregroundColor: AppColorScheme.dangerColor,
                ),
                child: Text(loc.confirm),
              ),
            ],
          ),
        ) ??
        false;

    if (confirmed == true) {
      try {
        await MTRBookmarksService.removeBookmark(bookmark);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(loc.removeBookmarkSuccess),
              duration: const Duration(seconds: 2),
            ),
          );
        }
        // Reload bookmarks to refresh the list
        await _loadBookmarks();
        // Check if we should exit edit mode
        if (_mtrBookmarks.isEmpty) {
          setState(() {
            _isEditMode = false;
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${loc.removeBookmarkError}: $e'),
              backgroundColor: AppColorScheme.snackbarErrorColor,
            ),
          );
        }
      }
    }
  }

  Widget _buildKMBBookmarks() {
    final loc = AppLocalizations.of(context)!;
    return Column(
      children: [
        Expanded(
          child: KMBBookmarksWidget(
            kmbBookmarks: _kmbBookmarks,
            isLoading: _isLoading,
            isEditMode: _isEditMode,
            onDelete: _deleteKMBBookmark,
          ),
        ),
        // Edit button for KMB tab - only show if there's at least 1 bookmark
        if (_kmbBookmarks.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: _toggleEditMode,
              icon: Icon(_isEditMode ? Icons.done : Icons.edit),
              label: Text(_isEditMode ? loc.close : loc.editItemsPlaceholder),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: _isEditMode
                    ? AppColorScheme.successStateColor
                    : AppColorScheme.buttonColor,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMTRBookmarks() {
    final loc = AppLocalizations.of(context)!;
    return Column(
      children: [
        Expanded(
          child: MTRBookmarksWidget(
            mtrBookmarks: _mtrBookmarks,
            isLoading: _isLoading,
            isEditMode: _isEditMode,
            onDelete: _deleteMTRBookmark,
          ),
        ),
        // Edit button for MTR tab - only show if there's at least 1 bookmark
        if (_mtrBookmarks.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: _toggleEditMode,
              icon: Icon(_isEditMode ? Icons.done : Icons.edit),
              label: Text(_isEditMode ? loc.close : loc.editItemsPlaceholder),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: _isEditMode
                    ? AppColorScheme.successStateColor
                    : AppColorScheme.buttonColor,
              ),
            ),
          ),
      ],
    );
  }
}
