import 'package:flutter/material.dart';
import '../../scripts/bookmarks_service.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<BookmarkItem> _kmbBookmarks = [];
  List<Map<String, dynamic>> _mtrBookmarks =
      []; // Placeholder for MTR bookmarks
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadBookmarks();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadBookmarks() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load KMB bookmarks
      final kmbBookmarks = await BookmarksService.getBookmarks();

      // For now, MTR bookmarks are empty - this would be implemented later
      // when MTR bookmark functionality is added
      final mtrBookmarks = <Map<String, dynamic>>[];

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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('載入書籤時發生錯誤: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('書籤'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.directions_bus),
              text: '巴士',
            ),
            Tab(
              icon: Icon(Icons.train),
              text: '港鐵',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildKMBBookmarks(),
          _buildMTRBookmarks(),
        ],
      ),
    );
  }

  Widget _buildKMBBookmarks() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_kmbBookmarks.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bookmark_border,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              '沒有巴士書籤',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '在巴士路線頁面添加書籤',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
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
              '${bookmark.route} 往 ${bookmark.bound}',
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
          ),
        );
      },
    );
  }

  Widget _buildMTRBookmarks() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_mtrBookmarks.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bookmark_border,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              '沒有港鐵書籤',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '港鐵書籤功能即將推出',
              style: TextStyle(
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
              bookmark['nameTc'] ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(bookmark['fullName'] ?? ''),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _removeMTRBookmark(bookmark),
            ),
          ),
        );
      },
    );
  }

  Future<void> _removeKMBBookmark(BookmarkItem bookmark) async {
    try {
      await BookmarksService.removeBookmark(bookmark);
      await _loadBookmarks();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('已移除書籤')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('移除書籤時發生錯誤: $e')),
        );
      }
    }
  }

  Future<void> _removeMTRBookmark(Map<String, dynamic> bookmark) async {
    // Placeholder for MTR bookmark removal
    // This would be implemented when MTR bookmark functionality is added
    setState(() {
      _mtrBookmarks.remove(bookmark);
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('已移除書籤')),
      );
    }
  }
}
